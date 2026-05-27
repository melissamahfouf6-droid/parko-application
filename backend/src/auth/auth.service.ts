import { BadRequestException, Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LoyaltyService } from '../loyalty/loyalty.service';
import { WalletService } from '../wallet/wallet.service';
import { AppUser } from './entities/app-user.entity';

type OtpEntry = { code: string; expiresAt: number };

@Injectable()
export class AuthService {
  /** Demo OTP store (use SMS provider in production). */
  private readonly pending = new Map<string, OtpEntry>();

  constructor(
    @InjectRepository(AppUser)
    private readonly users: Repository<AppUser>,
    private readonly wallet: WalletService,
    private readonly loyalty: LoyaltyService,
  ) {}

  sendOtp(phoneRaw?: string) {
    const phone = this.normalizePhone(phoneRaw);
    const code = '123456';
    this.pending.set(phone, {
      code,
      expiresAt: Date.now() + 10 * 60 * 1000,
    });
    return {
      sent: true,
      phone,
      /** Shown only in dev — remove in production. */
      demoCode: code,
      expiresInSeconds: 600,
    };
  }

  async verifyOtp(phoneRaw?: string, codeRaw?: string) {
    const phone = this.normalizePhone(phoneRaw);
    const code = codeRaw?.trim();
    if (!code) throw new BadRequestException('code required');

    const entry = this.pending.get(phone);
    if (!entry || entry.expiresAt < Date.now()) {
      throw new UnauthorizedException('otp_expired');
    }
    if (entry.code !== code) {
      throw new UnauthorizedException('otp_invalid');
    }
    this.pending.delete(phone);

    let user = await this.users.findOne({ where: { phone } });
    let isNew = false;
    if (!user) {
      isNew = true;
      user = await this.users.save(
        this.users.create({ phone, displayName: null }),
      );
      await this.wallet.seedWelcome(user.id);
      await this.loyalty.seedWelcome(user.id);
    }
    return {
      userId: user.id,
      phone: user.phone,
      displayName: user.displayName,
      email: user.email ?? null,
      token: `demo-${user.id}`,
      welcomeBonus: isNew,
      welcomeWalletKwd: isNew ? 10 : 0,
      welcomePoints: isNew ? 250 : 0,
    };
  }

  async updateProfile(
    userId: string,
    body: { displayName?: string; email?: string },
  ) {
    const user = await this.users.findOne({ where: { id: userId } });
    if (!user) throw new BadRequestException('user_not_found');
    if (body.displayName !== undefined) {
      user.displayName = body.displayName?.trim() || null;
    }
    if (body.email !== undefined) {
      user.email = body.email?.trim() || null;
    }
    await this.users.save(user);
    return this.profile(userId);
  }

  async profile(userId: string) {
    const user = await this.users.findOne({ where: { id: userId } });
    if (!user) throw new BadRequestException('user_not_found');
    return {
      userId: user.id,
      phone: user.phone,
      displayName: user.displayName,
      email: user.email ?? null,
      memberSince: user.createdAt.toISOString(),
    };
  }

  private normalizePhone(raw?: string): string {
    const digits = (raw ?? '').replace(/\D/g, '');
    if (digits.length < 8) throw new BadRequestException('invalid_phone');
    if (digits.startsWith('965')) return `+${digits}`;
    return `+965${digits}`;
  }
}
