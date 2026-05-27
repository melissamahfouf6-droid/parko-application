import { BadRequestException, Body, Controller, Get, Headers, Post } from '@nestjs/common';
import { MarketplaceService } from './marketplace.service';

const HDR = 'x-user-id';

@Controller('marketplace')
export class MarketplaceController {
  constructor(private readonly marketplace: MarketplaceService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get('listings')
  listings() {
    return this.marketplace.listAll();
  }

  @Post('listings')
  create(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body()
    body: { title?: string; priceKwdPerDay?: number; availability?: string; lat?: number; lng?: number },
  ) {
    if (!body?.title || body.priceKwdPerDay == null) {
      throw new BadRequestException('title and priceKwdPerDay required');
    }
    return this.marketplace.create(this.uid(headers), {
      title: body.title,
      priceKwdPerDay: Number(body.priceKwdPerDay),
      availability: body.availability ?? 'Weekdays 8AM–5PM',
      lat: body.lat,
      lng: body.lng,
    });
  }
}
