import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SavedLot } from './entities/saved-lot.entity';

@Injectable()
export class FavoritesService {
  constructor(
    @InjectRepository(SavedLot)
    private readonly saved: Repository<SavedLot>,
  ) {}

  async list(userId: string) {
    const rows = await this.saved.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
    return {
      favorites: rows.map((r) => ({
        id: r.id,
        lotId: r.lotId,
        lotName: r.lotName,
        lat: r.lat,
        lng: r.lng,
        savedAt: r.createdAt.toISOString(),
      })),
    };
  }

  async add(
    userId: string,
    body: { lotId?: string; lotName?: string; lat?: number; lng?: number },
  ) {
    const lotId = body.lotId?.trim();
    if (!lotId) throw new BadRequestException('lotId required');
    const existing = await this.saved.findOne({ where: { userId, lotId } });
    if (existing) {
      return { favorite: this.mapRow(existing), created: false };
    }
    const row = await this.saved.save(
      this.saved.create({
        userId,
        lotId,
        lotName: body.lotName?.trim() || lotId,
        lat: Number(body.lat) || 29.3759,
        lng: Number(body.lng) || 47.9774,
      }),
    );
    return { favorite: this.mapRow(row), created: true };
  }

  async remove(userId: string, lotId: string) {
    const row = await this.saved.findOne({ where: { userId, lotId } });
    if (!row) throw new NotFoundException('favorite_not_found');
    await this.saved.remove(row);
    return { removed: true, lotId };
  }

  async isFavorite(userId: string, lotId: string) {
    const row = await this.saved.findOne({ where: { userId, lotId } });
    return { lotId, saved: !!row };
  }

  private mapRow(r: SavedLot) {
    return {
      id: r.id,
      lotId: r.lotId,
      lotName: r.lotName,
      lat: r.lat,
      lng: r.lng,
      savedAt: r.createdAt.toISOString(),
    };
  }
}
