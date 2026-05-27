import {
  Body,
  Controller,
  Get,
  Headers,
  Post,
  BadRequestException,
} from '@nestjs/common';
import { LoyaltyService } from './loyalty.service';

const HDR = 'x-user-id';

@Controller('loyalty')
export class LoyaltyController {
  constructor(private readonly loyalty: LoyaltyService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v || typeof v !== 'string' || !v.trim()) {
      throw new BadRequestException(`Missing header ${HDR}`);
    }
    return v.trim();
  }

  @Get('summary')
  async summary(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.loyalty.getSummary(this.uid(headers));
  }

  @Get('rewards')
  rewards() {
    return this.loyalty.getRewardsCatalog();
  }

  @Post('earn')
  async earn(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body()
    body: {
      type: string;
      amount?: number;
      reference?: string;
      kwdSpent?: number;
    },
  ) {
    if (!body?.type) throw new BadRequestException('type required');
    return this.loyalty.earn(this.uid(headers), body);
  }

  @Post('redeem')
  async redeem(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { points: number },
  ) {
    if (body?.points == null) throw new BadRequestException('points required');
    return this.loyalty.redeem(this.uid(headers), Number(body.points));
  }

  @Post('check-in')
  async checkIn(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.loyalty.dailyCheckIn(this.uid(headers));
  }
}
