import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
  OnModuleInit,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { NotificationsService } from '../notifications/notifications.service';
import { ParkingLotReview } from './entities/parking-lot-review.entity';
import { ParkingSessionRecord } from './entities/parking-session.entity';
import { PARKING_LOTS_SEED, haversineKm, lotById } from './parking-lots.data';

const DEMO_USER = 'demo-user-1';

@Injectable()
export class ParkingService implements OnModuleInit {
  private readonly lotRatingOverrides = new Map<
    string,
    { rating: number; reviewCount: number }
  >();

  constructor(
    @InjectRepository(ParkingSessionRecord)
    private readonly sessions: Repository<ParkingSessionRecord>,
    @InjectRepository(ParkingLotReview)
    private readonly reviews: Repository<ParkingLotReview>,
    private readonly notifications: NotificationsService,
  ) {}

  async onModuleInit() {
    await this.refreshAllLotRatings();

    const count = await this.sessions.count({ where: { userId: DEMO_USER } });
    if (count > 0) return;
    const seeds = [
      { lotId: 'avenues', lotName: 'The Avenues Mall', paidKwd: 3.5, durationMinutes: 135, daysAgo: 45 },
      { lotId: 'kuwait_uni', lotName: 'Kuwait University', paidKwd: 0, durationMinutes: 45, daysAgo: 52 },
    ];
    for (const s of seeds) {
      const started = new Date();
      started.setDate(started.getDate() - s.daysAgo);
      await this.sessions.save(
        this.sessions.create({
          userId: DEMO_USER,
          lotId: s.lotId,
          lotName: s.lotName,
          paidKwd: s.paidKwd,
          durationMinutes: s.durationMinutes,
          status: 'completed',
          startedAt: started,
        }),
      );
    }
  }

  private async refreshAllLotRatings() {
    for (const lot of PARKING_LOTS_SEED) {
      await this.recomputeLotRating(lot.id);
    }
  }

  private async recomputeLotRating(lotId: string) {
    const seed = lotById(lotId);
    if (!seed) return;
    const rows = await this.reviews.find({ where: { lotId } });
    const baseCount = seed.reviewCount;
    const baseRating = seed.rating;
    if (rows.length === 0) {
      this.lotRatingOverrides.set(lotId, { rating: baseRating, reviewCount: baseCount });
      return;
    }
    const sum = rows.reduce((s, r) => s + r.stars, 0);
    const totalCount = baseCount + rows.length;
    const weighted =
      (baseRating * baseCount + sum) / Math.max(totalCount, 1);
    this.lotRatingOverrides.set(lotId, {
      rating: Math.round(weighted * 10) / 10,
      reviewCount: totalCount,
    });
  }

  private lotDto(lot: (typeof PARKING_LOTS_SEED)[0], distanceKm: number) {
    const stats = this.lotRatingOverrides.get(lot.id);
    return {
      ...lot,
      rating: stats?.rating ?? lot.rating,
      reviewCount: stats?.reviewCount ?? lot.reviewCount,
      distanceKm: Math.round(distanceKm * 100) / 100,
      availabilityRatio: lot.totalSpots === 0 ? 0 : lot.availableSpots / lot.totalSpots,
    };
  }

  nearbyLots(lat: number, lng: number, radiusKm = 30) {
    const lots = PARKING_LOTS_SEED.map((lot) => {
      const distanceKm = haversineKm(lat, lng, lot.lat, lot.lng);
      return this.lotDto(lot, distanceKm);
    })
      .filter((l) => l.distanceKm <= radiusKm)
      .sort((a, b) => a.distanceKm - b.distanceKm);
    return { lots, center: { lat, lng } };
  }

  async submitReview(
    userId: string,
    lotId: string,
    body: { stars?: number; comment?: string },
  ) {
    const seed = lotById(lotId);
    if (!seed) throw new NotFoundException('lot_not_found');
    const stars = Number(body.stars);
    if (!Number.isFinite(stars) || stars < 1 || stars > 5) {
      throw new BadRequestException('stars must be 1-5');
    }
    const since = new Date();
    since.setHours(0, 0, 0, 0);
    const existing = await this.reviews.findOne({
      where: { userId, lotId },
      order: { createdAt: 'DESC' },
    });
    if (existing && existing.createdAt >= since) {
      throw new ConflictException('already_reviewed_today');
    }
    await this.reviews.save(
      this.reviews.create({
        userId,
        lotId,
        stars,
        comment: body.comment?.trim() || null,
      }),
    );
    await this.recomputeLotRating(lotId);
    const stats = this.lotRatingOverrides.get(lotId)!;
    return {
      lotId,
      rating: stats.rating,
      reviewCount: stats.reviewCount,
      pointsHint: 10,
    };
  }

  async recordSession(
    userId: string,
    body: { lotId: string; lotName: string; paidKwd: number; durationMinutes?: number },
  ) {
    const row = this.sessions.create({
      userId,
      lotId: body.lotId,
      lotName: body.lotName,
      paidKwd: body.paidKwd,
      durationMinutes: body.durationMinutes ?? 120,
      status: 'active',
      startedAt: new Date(),
    });
    await this.sessions.save(row);
    await this.notifications.push(
      userId,
      'Parking started',
      `${body.lotName} · session active`,
      'parking',
    );
    return this.sessionDto(row);
  }

  async completeActiveSession(
    userId: string,
    body: { lotId?: string; durationMinutes?: number; paidKwd?: number },
  ) {
    const where: { userId: string; status: string; lotId?: string } = {
      userId,
      status: 'active',
    };
    if (body.lotId?.trim()) where.lotId = body.lotId.trim();
    const row = await this.sessions.findOne({
      where,
      order: { startedAt: 'DESC' },
    });
    if (!row) {
      return { completed: false };
    }
    const used = Number(body.durationMinutes);
    if (Number.isFinite(used) && used > 0) {
      row.durationMinutes = Math.round(used);
    } else {
      const elapsed = Math.round((Date.now() - row.startedAt.getTime()) / 60000);
      row.durationMinutes = Math.max(1, elapsed);
    }
    if (body.paidKwd != null && Number.isFinite(body.paidKwd)) {
      row.paidKwd = body.paidKwd;
    }
    row.status = 'completed';
    await this.sessions.save(row);
    await this.notifications.push(
      userId,
      'Parking session ended',
      `${row.lotName} · ${row.durationMinutes} min`,
      'parking',
    );
    return { completed: true, session: this.sessionDto(row) };
  }

  async history(userId: string) {
    const rows = await this.sessions.find({
      where: { userId },
      order: { startedAt: 'DESC' },
      take: 40,
    });
    return rows
      .filter((r) => r.status === 'completed')
      .map((r) => this.sessionDto(r));
  }

  private sessionDto(r: ParkingSessionRecord) {
    const hours = Math.floor(r.durationMinutes / 60);
    const mins = r.durationMinutes % 60;
    return {
      id: r.id,
      lotId: r.lotId,
      lotName: r.lotName,
      paidKwd: r.paidKwd,
      durationMinutes: r.durationMinutes,
      durationLabel: hours > 0 ? `${hours}h ${mins}m` : `${mins}m`,
      status: r.status,
      startedAt: r.startedAt.toISOString(),
    };
  }
}
