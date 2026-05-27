import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SharedSpotListing } from './entities/shared-spot-listing.entity';

const DISCOUNT = 0.2;
const SELLER_REFUND_RATE = 0.7;

@Injectable()
export class ShareService {
  constructor(
    @InjectRepository(SharedSpotListing)
    private readonly listings: Repository<SharedSpotListing>,
  ) {}

  async listAvailable() {
    const now = new Date();
    const rows = await this.listings.find({
      where: { status: 'active' },
      order: { createdAt: 'DESC' },
    });
    return rows
      .filter((r) => !r.expiresAt || r.expiresAt > now)
      .map((r) => this.toDto(r));
  }

  async createListing(
    userId: string,
    body: {
      lotId: string;
      lotName: string;
      lat: number;
      lng: number;
      remainingMinutes: number;
      originalPriceKwd: number;
    },
  ) {
    const existing = await this.listings.findOne({
      where: { sellerUserId: userId, status: 'active' },
    });
    if (existing) {
      throw new BadRequestException('already_listed');
    }
    const salePriceKwd = Math.round(body.originalPriceKwd * (1 - DISCOUNT) * 100) / 100;
    const expiresAt = new Date(Date.now() + body.remainingMinutes * 60 * 1000);
    const row = this.listings.create({
      sellerUserId: userId,
      lotId: body.lotId,
      lotName: body.lotName,
      lat: body.lat,
      lng: body.lng,
      remainingMinutes: body.remainingMinutes,
      originalPriceKwd: body.originalPriceKwd,
      salePriceKwd,
      status: 'active',
      expiresAt,
    });
    await this.listings.save(row);
    const sellerRefundKwd = Math.round(body.originalPriceKwd * SELLER_REFUND_RATE * 100) / 100;
    return {
      listing: this.toDto(row),
      sellerRefundKwd,
      platformFeeKwd: Math.round((body.originalPriceKwd - sellerRefundKwd) * 100) / 100,
      handoffMinutes: 10,
    };
  }

  async claimListing(buyerUserId: string, listingId: string) {
    const row = await this.listings.findOne({ where: { id: listingId, status: 'active' } });
    if (!row) throw new NotFoundException('listing_not_found');
    if (row.sellerUserId === buyerUserId) {
      throw new BadRequestException('cannot_buy_own_listing');
    }
    row.status = 'claimed';
    await this.listings.save(row);
    return {
      listing: this.toDto(row),
      message: 'Spot claimed. Seller should exit within 10 minutes; you can enter the space.',
    };
  }

  private toDto(r: SharedSpotListing) {
    return {
      id: r.id,
      sellerUserId: r.sellerUserId,
      lotId: r.lotId,
      lotName: r.lotName,
      lat: r.lat,
      lng: r.lng,
      remainingMinutes: r.remainingMinutes,
      originalPriceKwd: r.originalPriceKwd,
      salePriceKwd: r.salePriceKwd,
      discountPercent: Math.round(DISCOUNT * 100),
      status: r.status,
      createdAt: r.createdAt.toISOString(),
      expiresAt: r.expiresAt?.toISOString() ?? null,
    };
  }
}
