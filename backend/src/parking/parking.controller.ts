import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Headers,
  Param,
  Post,
  Query,
} from '@nestjs/common';
import { ParkingService } from './parking.service';

const HDR = 'x-user-id';

@Controller('parking')
export class ParkingController {
  constructor(private readonly parking: ParkingService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get('lots/nearby')
  nearby(
    @Query('lat') latStr: string,
    @Query('lng') lngStr: string,
    @Query('radiusKm') radiusStr?: string,
  ) {
    const lat = Number(latStr);
    const lng = Number(lngStr);
    if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
      throw new BadRequestException('lat and lng required');
    }
    const radiusKm = radiusStr ? Number(radiusStr) : 30;
    return this.parking.nearbyLots(lat, lng, radiusKm);
  }

  @Get('sessions/history')
  history(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.parking.history(this.uid(headers));
  }

  @Post('sessions/complete')
  completeSession(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body()
    body: { lotId?: string; durationMinutes?: number; paidKwd?: number },
  ) {
    return this.parking.completeActiveSession(this.uid(headers), body);
  }

  @Post('lots/:lotId/review')
  review(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('lotId') lotId: string,
    @Body() body: { stars?: number; comment?: string },
  ) {
    return this.parking.submitReview(this.uid(headers), lotId, body);
  }
}
