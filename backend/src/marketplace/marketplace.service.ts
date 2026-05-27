import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PrivateSpotListing } from './entities/private-spot-listing.entity';

@Injectable()
export class MarketplaceService implements OnModuleInit {
  constructor(
    @InjectRepository(PrivateSpotListing)
    private readonly listings: Repository<PrivateSpotListing>,
  ) {}

  async onModuleInit() {
    if ((await this.listings.count()) > 0) return;
    const seeds = [
      { ownerUserId: 'owner-1', title: 'Salmiya building spot', lat: 29.3397, lng: 48.0768, priceKwdPerDay: 1.5, availability: 'Weekdays 8AM–5PM', rating: 4.7, reviewCount: 12 },
      { ownerUserId: 'owner-2', title: 'Jabriya driveway', lat: 29.3212, lng: 48.0284, priceKwdPerDay: 2.0, availability: '24/7', rating: 4.9, reviewCount: 28 },
      { ownerUserId: 'owner-3', title: 'Bayan villa parking', lat: 29.3631, lng: 48.0439, priceKwdPerDay: 1.2, availability: 'Sat–Thu 6AM–10PM', rating: 4.4, reviewCount: 7 },
    ];
    for (const s of seeds) {
      await this.listings.save(this.listings.create({ ...s, status: 'active' }));
    }
  }

  async listAll() {
    const rows = await this.listings.find({
      where: { status: 'active' },
      order: { createdAt: 'DESC' },
    });
    return rows.map((r) => this.toDto(r));
  }

  async create(
    userId: string,
    body: { title: string; lat?: number; lng?: number; priceKwdPerDay: number; availability: string },
  ) {
    const row = this.listings.create({
      ownerUserId: userId,
      title: body.title,
      lat: body.lat ?? 29.35,
      lng: body.lng ?? 47.98,
      priceKwdPerDay: body.priceKwdPerDay,
      availability: body.availability,
      rating: 5,
      reviewCount: 0,
      status: 'active',
    });
    await this.listings.save(row);
    return this.toDto(row);
  }

  private toDto(r: PrivateSpotListing) {
    return {
      id: r.id,
      title: r.title,
      lat: r.lat,
      lng: r.lng,
      priceKwdPerDay: r.priceKwdPerDay,
      availability: r.availability,
      rating: r.rating,
      reviewCount: r.reviewCount,
      estimatedMonthlyKwd: Math.round(r.priceKwdPerDay * 22 * 10) / 10,
    };
  }
}
