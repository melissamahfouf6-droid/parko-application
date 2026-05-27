import { BadRequestException, Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WalletAccount } from './entities/wallet-account.entity';
import { WalletTransaction } from './entities/wallet-transaction.entity';
import { ParkingService } from '../parking/parking.service';

const DEMO_USER = 'demo-user-1';

@Injectable()
export class WalletService implements OnModuleInit {
  constructor(
    @InjectRepository(WalletAccount)
    private readonly accounts: Repository<WalletAccount>,
    @InjectRepository(WalletTransaction)
    private readonly transactions: Repository<WalletTransaction>,
    private readonly parking: ParkingService,
  ) {}

  async onModuleInit() {
    let acc = await this.accounts.findOne({ where: { userId: DEMO_USER } });
    if (!acc) {
      acc = this.accounts.create({ userId: DEMO_USER, balanceKwd: 12.5 });
      await this.accounts.save(acc);
      await this.transactions.save(
        this.transactions.create({
          userId: DEMO_USER,
          amountKwd: 12.5,
          type: 'SEED',
          reference: 'welcome_wallet',
          description: 'Welcome bonus',
        }),
      );
    }
  }

  async getOrCreate(userId: string): Promise<WalletAccount> {
    let acc = await this.accounts.findOne({ where: { userId } });
    if (!acc) {
      acc = this.accounts.create({ userId, balanceKwd: 0 });
      await this.accounts.save(acc);
    }
    return acc;
  }

  /** One-time welcome credit for new sign-ups. */
  async seedWelcome(userId: string): Promise<boolean> {
    const existing = await this.transactions.findOne({
      where: { userId, type: 'WELCOME' },
    });
    if (existing) return false;
    const acc = await this.getOrCreate(userId);
    acc.balanceKwd = Math.round((acc.balanceKwd + 10) * 1000) / 1000;
    await this.accounts.save(acc);
    await this.transactions.save(
      this.transactions.create({
        userId,
        amountKwd: 10,
        type: 'WELCOME',
        reference: 'welcome_wallet',
        description: 'Welcome to Parko',
      }),
    );
    return true;
  }

  async getSummary(userId: string) {
    const acc = await this.getOrCreate(userId);
    const txs = await this.transactions.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: 30,
    });
    return {
      balanceKwd: Math.round(acc.balanceKwd * 1000) / 1000,
      currency: 'KWD',
      paymentMethods: ['knet', 'tap'],
      transactions: txs.map((t) => this.txDto(t)),
    };
  }

  async topUp(userId: string, amountKwd: number) {
    const amount = Number(amountKwd);
    if (!Number.isFinite(amount) || amount <= 0 || amount > 500) {
      throw new BadRequestException('invalid_amount');
    }
    const acc = await this.getOrCreate(userId);
    acc.balanceKwd = Math.round((acc.balanceKwd + amount) * 1000) / 1000;
    await this.accounts.save(acc);
    const tx = await this.transactions.save(
      this.transactions.create({
        userId,
        amountKwd: amount,
        type: 'TOP_UP',
        reference: `topup_${Date.now()}`,
        description: 'Demo top-up (Tap/KNET)',
      }),
    );
    return { balanceKwd: acc.balanceKwd, transaction: this.txDto(tx) };
  }

  async refund(userId: string, amountKwd: number, reference: string, description: string) {
    const amount = Number(amountKwd);
    if (!Number.isFinite(amount) || amount <= 0) {
      throw new BadRequestException('invalid_amount');
    }
    const acc = await this.getOrCreate(userId);
    acc.balanceKwd = Math.round((acc.balanceKwd + amount) * 1000) / 1000;
    await this.accounts.save(acc);
    const tx = await this.transactions.save(
      this.transactions.create({
        userId,
        amountKwd: amount,
        type: 'REFUND',
        reference,
        description,
      }),
    );
    return { balanceKwd: acc.balanceKwd, transaction: this.txDto(tx) };
  }

  async creditRedemption(userId: string, kwd: number, reference: string) {
    const amount = Number(kwd);
    if (!Number.isFinite(amount) || amount <= 0) {
      throw new BadRequestException('invalid_amount');
    }
    const acc = await this.getOrCreate(userId);
    acc.balanceKwd = Math.round((acc.balanceKwd + amount) * 1000) / 1000;
    await this.accounts.save(acc);
    const tx = await this.transactions.save(
      this.transactions.create({
        userId,
        amountKwd: amount,
        type: 'LOYALTY_REDEEM',
        reference,
        description: 'Parko Points redemption',
      }),
    );
    return { balanceKwd: acc.balanceKwd, transaction: this.txDto(tx) };
  }

  async pay(
    userId: string,
    body: { amountKwd: number; reference: string; description?: string },
  ) {
    const amount = Number(body.amountKwd);
    if (!Number.isFinite(amount) || amount <= 0) {
      throw new BadRequestException('invalid_amount');
    }
    if (!body.reference?.trim()) throw new BadRequestException('reference required');

    const acc = await this.getOrCreate(userId);
    if (acc.balanceKwd < amount) {
      throw new BadRequestException('insufficient_balance');
    }
    acc.balanceKwd = Math.round((acc.balanceKwd - amount) * 1000) / 1000;
    await this.accounts.save(acc);
    const tx = await this.transactions.save(
      this.transactions.create({
        userId,
        amountKwd: -amount,
        type: 'PAYMENT',
        reference: body.reference.trim(),
        description: body.description?.trim() ?? 'Parking payment',
      }),
    );
    const ref = body.reference.trim();
    if (ref.startsWith('parking_')) {
      const lotId = ref.slice('parking_'.length);
      await this.parking.recordSession(userId, {
        lotId,
        lotName: body.description?.trim() ?? lotId,
        paidKwd: amount,
      });
    }
    return { balanceKwd: acc.balanceKwd, transaction: this.txDto(tx) };
  }

  private txDto(t: WalletTransaction) {
    return {
      id: t.id,
      amountKwd: t.amountKwd,
      type: t.type,
      reference: t.reference,
      description: t.description,
      createdAt: t.createdAt.toISOString(),
    };
  }
}
