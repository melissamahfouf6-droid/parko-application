import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  Headers,
  Param,
  Post,
} from '@nestjs/common';
import { ReservationsService } from './reservations.service';

const HDR = 'x-user-id';

@Controller('reservations')
export class ReservationsController {
  constructor(private readonly reservations: ReservationsService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get()
  list(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.reservations.listForUser(this.uid(headers));
  }

  @Post()
  create(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body()
    body: {
      lotId?: string;
      lotName?: string;
      lat?: number;
      lng?: number;
      startAt?: string;
      endAt?: string;
      priceKwd?: number;
      zoneLabel?: string;
      payFromWallet?: boolean;
    },
  ) {
    if (!body?.lotId || !body.lotName || !body.startAt || !body.endAt) {
      throw new BadRequestException('lotId, lotName, startAt, endAt required');
    }
    try {
      return this.reservations.create(this.uid(headers), {
        lotId: body.lotId,
        lotName: body.lotName,
        lat: body.lat != null ? Number(body.lat) : undefined,
        lng: body.lng != null ? Number(body.lng) : undefined,
        startAt: body.startAt,
        endAt: body.endAt,
        priceKwd: Number(body.priceKwd ?? 0),
        zoneLabel: body.zoneLabel,
        payFromWallet: body.payFromWallet === true,
      });
    } catch {
      throw new BadRequestException('invalid reservation dates');
    }
  }

  @Delete(':id')
  cancel(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('id') id: string,
  ) {
    return this.reservations.cancel(this.uid(headers), id);
  }
}
