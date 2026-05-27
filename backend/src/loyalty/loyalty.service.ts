import {
  BadRequestException,
  ConflictException,
  Injectable,
  OnModuleInit,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LoyaltyAccount } from './entities/loyalty-account.entity';
import { PointsTransaction } from './entities/points-transaction.entity';
import { WalletService } from '../wallet/wallet.service';

export type LoyaltyLevelName = 'bronze' | 'silver' | 'gold' | 'platinum';

export function levelFromLifetime(lifetime: number): LoyaltyLevelName {
  if (lifetime >= 5000) return 'platinum';
  if (lifetime >= 2000) return 'gold';
  if (lifetime >= 500) return 'silver';
  return 'bronze';
}

/** Points needed to reach the next tier (0 if already Platinum). */
export function pointsToNextLevel(lifetime: number): number {
  if (lifetime >= 5000) return 0;
  if (lifetime >= 2000) return 5000 - lifetime;
  if (lifetime >= 500) return 2000 - lifetime;
  return 500 - lifetime;
}

const DEMO_USER = 'demo-user-1';

@Injectable()
export class LoyaltyService implements OnModuleInit {
  constructor(
    @InjectRepository(LoyaltyAccount)
    private readonly accounts: Repository<LoyaltyAccount>,
    @InjectRepository(PointsTransaction)
    private readonly transactions: Repository<PointsTransaction>,
    private readonly wallet: WalletService,
  ) {}

  async onModuleInit(): Promise<void> {
    let acc = await this.accounts.findOne({ where: { userId: DEMO_USER } });
    if (!acc) {
      acc = this.accounts.create({
        userId: DEMO_USER,
        balancePoints: 2340,
        lifetimeEarned: 2340,
        level: levelFromLifetime(2340),
      });
      await this.accounts.save(acc);
      await this.transactions.save(
        this.transactions.create({
          userId: DEMO_USER,
          amount: 2340,
          type: 'SEED',
          reference: 'welcome_bonus',
        }),
      );
    }
  }

  async getOrCreateAccount(userId: string): Promise<LoyaltyAccount> {
    let acc = await this.accounts.findOne({ where: { userId } });
    if (!acc) {
      acc = this.accounts.create({
        userId,
        balancePoints: 0,
        lifetimeEarned: 0,
        level: 'bronze',
      });
      await this.accounts.save(acc);
    }
    return acc;
  }

  /** One-time welcome points for new sign-ups. */
  async seedWelcome(userId: string): Promise<boolean> {
    const existing = await this.transactions.findOne({
      where: { userId, type: 'WELCOME' },
    });
    if (existing) return false;
    const acc = await this.getOrCreateAccount(userId);
    acc.balancePoints += 250;
    acc.lifetimeEarned += 250;
    acc.level = levelFromLifetime(acc.lifetimeEarned);
    await this.accounts.save(acc);
    await this.transactions.save(
      this.transactions.create({
        userId,
        amount: 250,
        type: 'WELCOME',
        reference: 'welcome_bonus',
      }),
    );
    return true;
  }

  async getSummary(userId: string) {
    const acc = await this.getOrCreateAccount(userId);
    const level = levelFromLifetime(acc.lifetimeEarned);
    acc.level = level;
    await this.accounts.save(acc);
    const txs = await this.transactions.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: 50,
    });
    return {
      userId: acc.userId,
      balancePoints: acc.balancePoints,
      lifetimeEarned: acc.lifetimeEarned,
      level,
      pointsToNextLevel: pointsToNextLevel(acc.lifetimeEarned),
      transactions: txs.map((t) => ({
        id: t.id,
        amount: t.amount,
        type: t.type,
        reference: t.reference,
        createdAt: t.createdAt.toISOString(),
      })),
    };
  }

  async earn(
    userId: string,
    body: { amount?: number; type: string; reference?: string; kwdSpent?: number },
  ) {
    let amount = body.amount ?? 0;
    if (body.kwdSpent != null && body.kwdSpent > 0) {
      amount = Math.round(body.kwdSpent);
    }
    if (!Number.isFinite(amount) || amount <= 0) {
      throw new BadRequestException('amount or kwdSpent must yield positive points');
    }
    const acc = await this.getOrCreateAccount(userId);
    const prevLevel = levelFromLifetime(acc.lifetimeEarned);
    acc.balancePoints += amount;
    acc.lifetimeEarned += amount;
    acc.level = levelFromLifetime(acc.lifetimeEarned);
    await this.accounts.save(acc);
    await this.transactions.save(
      this.transactions.create({
        userId,
        amount,
        type: body.type,
        reference: body.reference ?? null,
      }),
    );
    const newLevel = levelFromLifetime(acc.lifetimeEarned);
    return {
      pointsAwarded: amount,
      ...this.mapAccount(acc),
      levelUp: newLevel !== prevLevel,
      previousLevel: prevLevel,
      newLevel,
    };
  }

  async redeem(userId: string, points: number) {
    if (!Number.isFinite(points) || points <= 0) {
      throw new BadRequestException('points must be positive');
    }
    const acc = await this.getOrCreateAccount(userId);
    if (acc.balancePoints < points) {
      throw new BadRequestException('insufficient_balance');
    }
    acc.balancePoints -= points;
    await this.accounts.save(acc);
    await this.transactions.save(
      this.transactions.create({
        userId,
        amount: -points,
        type: 'REDEEM',
        reference: `redeemed_${points}_pts`,
      }),
    );
    const kwdCredit = Math.round(((points / 100) * 5) * 1000) / 1000;
    const walletResult = await this.wallet.creditRedemption(
      userId,
      kwdCredit,
      `loyalty_redeem_${points}`,
    );
    return {
      ...this.mapAccount(acc),
      creditKwd: kwdCredit,
      walletBalanceKwd: walletResult.balanceKwd,
      message:
        points === 100
          ? `Applied ${points} points → ${kwdCredit} KWD added to your Parko wallet.`
          : `Redeemed ${points} points → ${kwdCredit} KWD wallet credit.`,
    };
  }

  async dailyCheckIn(userId: string) {
    const start = new Date();
    start.setHours(0, 0, 0, 0);
    const existing = await this.transactions.findOne({
      where: { userId, type: 'DAILY_CHECKIN' },
      order: { createdAt: 'DESC' },
    });
    if (existing && existing.createdAt >= start) {
      throw new ConflictException('already_checked_in_today');
    }
    return this.earn(userId, {
      amount: 5,
      type: 'DAILY_CHECKIN',
      reference: start.toISOString().slice(0, 10),
    });
  }

  getRewardsCatalog() {
    return {
      redemptionRate: { points: 100, parkingCreditKwd: 5 },
      tiers: [
        { level: 'bronze', minLifetime: 0, maxLifetime: 499, perks: ['Basic'] },
        {
          level: 'silver',
          minLifetime: 500,
          maxLifetime: 1999,
          perks: ['5% discount on parking'],
        },
        {
          level: 'gold',
          minLifetime: 2000,
          maxLifetime: 4999,
          perks: ['10% discount', 'Priority reservations'],
        },
        {
          level: 'platinum',
          minLifetime: 5000,
          maxLifetime: null,
          perks: ['15% discount', 'VIP spots', 'Free valet'],
        },
      ],
      earnRates: [
        { action: 'parking_spend', pointsPerKwd: 1 },
        { action: 'daily_checkin', points: 5 },
        { action: 'refer_friend', points: 50 },
        { action: 'review_lot', points: 10 },
        { action: 'streak_7_days', points: 100 },
      ],
    };
  }

  private mapAccount(acc: LoyaltyAccount) {
    return {
      userId: acc.userId,
      balancePoints: acc.balancePoints,
      lifetimeEarned: acc.lifetimeEarned,
      level: levelFromLifetime(acc.lifetimeEarned),
      pointsToNextLevel: pointsToNextLevel(acc.lifetimeEarned),
    };
  }
}
