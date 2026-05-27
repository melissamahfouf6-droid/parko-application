import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Headers,
  Post,
} from '@nestjs/common';
import { WalletService } from './wallet.service';

const HDR = 'x-user-id';

@Controller('wallet')
export class WalletController {
  constructor(private readonly wallet: WalletService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get('summary')
  summary(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.wallet.getSummary(this.uid(headers));
  }

  @Post('top-up')
  topUp(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { amountKwd?: number },
  ) {
    if (body?.amountKwd == null) throw new BadRequestException('amountKwd required');
    return this.wallet.topUp(this.uid(headers), Number(body.amountKwd));
  }

  @Post('pay')
  pay(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { amountKwd?: number; reference?: string; description?: string },
  ) {
    if (body?.amountKwd == null || !body?.reference) {
      throw new BadRequestException('amountKwd and reference required');
    }
    try {
      return this.wallet.pay(this.uid(headers), {
        amountKwd: Number(body.amountKwd),
        reference: body.reference,
        description: body.description,
      });
    } catch (e) {
      if (e instanceof BadRequestException) throw e;
      throw new BadRequestException('payment_failed');
    }
  }
}
