import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Headers,
  Param,
  Post,
} from '@nestjs/common';
import { ShareService } from './share.service';

const HDR = 'x-user-id';

@Controller('share')
export class ShareController {
  constructor(private readonly share: ShareService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get('available')
  available() {
    return this.share.listAvailable();
  }

  @Post('list')
  list(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body()
    body: {
      lotId?: string;
      lotName?: string;
      lat?: number;
      lng?: number;
      remainingMinutes?: number;
      originalPriceKwd?: number;
    },
  ) {
    if (!body?.lotId || !body.lotName) throw new BadRequestException('lotId and lotName required');
    return this.share.createListing(this.uid(headers), {
      lotId: body.lotId,
      lotName: body.lotName,
      lat: Number(body.lat ?? 29.3759),
      lng: Number(body.lng ?? 47.9774),
      remainingMinutes: Number(body.remainingMinutes ?? 120),
      originalPriceKwd: Number(body.originalPriceKwd ?? 3.5),
    });
  }

  @Post(':id/claim')
  claim(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('id') id: string,
  ) {
    return this.share.claimListing(this.uid(headers), id);
  }
}
