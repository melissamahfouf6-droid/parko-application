import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AvailabilityWaitlist } from './entities/availability-waitlist.entity';

/** Historical fill rate 0–1 by lot, weekday (0=Sun), hour 0–23. */
type PatternMap = Record<string, Record<number, Record<number, number>>>;

const PATTERNS: PatternMap = {
  avenues: {
    4: {
      // Thursday — mall pattern from spec
      10: 0.92,
      11: 0.9,
      12: 0.85,
      13: 0.78,
      14: 0.55,
      15: 0.42,
      16: 0.48,
      17: 0.62,
      18: 0.75,
    },
    5: { 14: 0.58, 15: 0.5, 16: 0.55 },
  },
  kuwait_uni: {
    0: { 8: 0.95, 9: 0.98, 10: 0.92, 11: 0.7, 12: 0.45 },
    1: { 8: 0.94, 9: 0.96, 10: 0.9, 11: 0.68, 12: 0.42 },
    2: { 8: 0.93, 9: 0.95, 10: 0.88, 11: 0.65, 12: 0.4 },
    3: { 8: 0.94, 9: 0.97, 10: 0.91, 11: 0.72, 12: 0.44 },
    4: { 8: 0.96, 9: 0.98, 10: 0.93, 11: 0.75, 12: 0.48 },
  },
  hospital: {
    0: { 7: 0.88, 8: 0.82, 9: 0.75, 10: 0.65, 14: 0.55, 15: 0.48 },
    1: { 7: 0.87, 8: 0.8, 9: 0.74, 10: 0.63, 14: 0.52, 15: 0.45 },
    2: { 7: 0.86, 8: 0.79, 9: 0.72, 10: 0.6, 14: 0.5, 15: 0.42 },
    3: { 7: 0.88, 8: 0.81, 9: 0.76, 10: 0.64, 14: 0.54, 15: 0.47 },
    4: { 7: 0.9, 8: 0.84, 9: 0.78, 10: 0.68, 14: 0.58, 15: 0.5 },
    5: { 7: 0.85, 8: 0.78, 9: 0.7, 10: 0.58 },
    6: { 7: 0.82, 8: 0.75, 9: 0.68, 10: 0.55 },
  },
};

const LOT_NAMES: Record<string, string> = {
  avenues: 'The Avenues Mall',
  kuwait_uni: 'Kuwait University',
  hospital: 'Dasman Diabetes Institute',
};

const OPEN_THRESHOLD = 0.35;

@Injectable()
export class PredictionsService implements OnModuleInit {
  constructor(
    @InjectRepository(AvailabilityWaitlist)
    private readonly waitlist: Repository<AvailabilityWaitlist>,
  ) {}

  onModuleInit(): void {
    // patterns are in-memory; DB only for waitlist
  }

  getLotPrediction(lotId: string, now = new Date()) {
    const name = LOT_NAMES[lotId] ?? lotId;
    const day = now.getDay();
    const hour = now.getHours();
    const pattern = PATTERNS[lotId]?.[day] ?? PATTERNS[lotId]?.[4] ?? {};

    let bestHour: number | null = null;
    let bestFill = 1;
    let minutesUntil = 0;

    for (let h = hour; h < 24; h++) {
      const fill = pattern[h] ?? this.interpolateFill(pattern, h);
      if (fill < OPEN_THRESHOLD && fill < bestFill) {
        bestHour = h;
        bestFill = fill;
        minutesUntil = (h - hour) * 60 - now.getMinutes();
        if (minutesUntil < 0) minutesUntil = 15;
        break;
      }
    }

    if (bestHour == null) {
      for (let h = 0; h <= hour; h++) {
        const fill = pattern[h] ?? 0.5;
        if (fill < OPEN_THRESHOLD) {
          bestHour = h;
          bestFill = fill;
          minutesUntil = (24 - hour + h) * 60 - now.getMinutes();
          break;
        }
      }
    }

    const probabilityPercent = this.probabilityFromFill(bestFill, minutesUntil);
    const typicalOpenLabel =
      bestHour != null ? this.formatTime(bestHour, 15) : null;

    const weekdayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    const insight =
      bestHour != null
        ? `${name} parking usually eases around ${typicalOpenLabel} on ${weekdayNames[day]}s`
        : `${name} — limited historical relief today; try another lot or enable notify`;

    const hourlyPattern = Array.from({ length: 12 }, (_, i) => {
      const h = (hour + i) % 24;
      return {
        hour: h,
        fillRate: pattern[h] ?? this.interpolateFill(pattern, h),
      };
    });

    return {
      lotId,
      lotName: name,
      insight,
      typicalOpenTime: typicalOpenLabel,
      probabilityPercent,
      minutesUntilLikely: minutesUntil > 0 ? minutesUntil : 20,
      isCurrentlyFull: true,
      hourlyPattern,
    };
  }

  getHomeHighlights(now = new Date()) {
    const lotIds = ['avenues', 'kuwait_uni', 'hospital'];
    return lotIds
      .map((id) => this.getLotPrediction(id, now))
      .filter((p) => p.probabilityPercent >= 50)
      .sort((a, b) => a.minutesUntilLikely - b.minutesUntilLikely)
      .slice(0, 5);
  }

  async joinWaitlist(userId: string, lotId: string) {
    const existing = await this.waitlist.findOne({ where: { userId, lotId } });
    if (existing) {
      return { ok: true, alreadyRegistered: true, id: existing.id };
    }
    const row = this.waitlist.create({ userId, lotId });
    await this.waitlist.save(row);
    return { ok: true, alreadyRegistered: false, id: row.id };
  }

  async listWaitlist(userId: string) {
    const rows = await this.waitlist.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
    return rows.map((r) => ({
      id: r.id,
      lotId: r.lotId,
      lotName: LOT_NAMES[r.lotId] ?? r.lotId,
      createdAt: r.createdAt.toISOString(),
    }));
  }

  private interpolateFill(pattern: Record<number, number>, hour: number): number {
    const keys = Object.keys(pattern)
      .map(Number)
      .sort((a, b) => a - b);
    if (keys.length === 0) return 0.7;
    if (keys.includes(hour)) return pattern[hour];
    const before = keys.filter((k) => k < hour).pop();
    const after = keys.find((k) => k > hour);
    if (before == null && after == null) return 0.7;
    if (before == null) return pattern[after!];
    if (after == null) return pattern[before];
    const t = (hour - before) / (after - before);
    return pattern[before] * (1 - t) + pattern[after] * t;
  }

  private probabilityFromFill(fill: number, minutesUntil: number): number {
    let base = 72;
    if (fill < 0.45) base = 85;
    if (fill < 0.4) base = 88;
    if (minutesUntil <= 20) base = Math.min(92, base + 5);
    if (minutesUntil <= 45) base = Math.min(90, base + 3);
    return base;
  }

  private formatTime(hour: number, minute: number): string {
    const h12 = hour % 12 === 0 ? 12 : hour % 12;
    const ampm = hour < 12 ? 'AM' : 'PM';
    const m = minute.toString().padStart(2, '0');
    return `${h12}:${m} ${ampm}`;
  }
}
