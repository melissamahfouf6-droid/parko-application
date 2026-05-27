import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { NotificationsService } from '../notifications/notifications.service';
import { WalletService } from '../wallet/wallet.service';
import { ParkingReservation } from './entities/parking-reservation.entity';

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(ParkingReservation)
    private readonly reservations: Repository<ParkingReservation>,
    private readonly notifications: NotificationsService,
    private readonly wallet: WalletService,
  ) {}

  async listForUser(userId: string) {
    const rows = await this.reservations.find({
      where: { userId },
      order: { startAt: 'ASC' },
    });
    const now = new Date();
    const upcoming = rows.filter((r) => r.status === 'confirmed' && r.startAt > now);
    const history = rows.filter((r) => r.status !== 'confirmed' || r.endAt <= now);
    return {
      upcoming: upcoming.map((r) => this.toDto(r)),
      history: history.map((r) => this.toDto(r)),
    };
  }

  async create(
    userId: string,
    body: {
      lotId: string;
      lotName: string;
      lat?: number;
      lng?: number;
      startAt: string;
      endAt: string;
      priceKwd: number;
      zoneLabel?: string;
      payFromWallet?: boolean;
    },
  ) {
    const start = new Date(body.startAt);
    const end = new Date(body.endAt);
    if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime()) || end <= start) {
      throw new BadRequestException('invalid_dates');
    }
    const row = this.reservations.create({
      userId,
      lotId: body.lotId,
      lotName: body.lotName,
      lat: body.lat ?? null,
      lng: body.lng ?? null,
      startAt: start,
      endAt: end,
      priceKwd: body.priceKwd,
      zoneLabel: body.zoneLabel ?? null,
      status: 'confirmed',
      walletPaid: false,
    });
    await this.reservations.save(row);

    if (body.payFromWallet && body.priceKwd > 0) {
      try {
        await this.wallet.pay(userId, {
          amountKwd: body.priceKwd,
          reference: `reserve-${row.id}`,
          description: `Reserve ${body.lotName}`,
        });
        row.walletPaid = true;
        await this.reservations.save(row);
      } catch (e) {
        await this.reservations.remove(row);
        if (e instanceof BadRequestException) throw e;
        throw new BadRequestException('insufficient_balance');
      }
    }

    const startLabel = start.toLocaleString('en-KW', {
      weekday: 'short',
      hour: 'numeric',
      minute: '2-digit',
    });
    await this.notifications.push(
      userId,
      'Reservation confirmed',
      `${body.lotName} · ${startLabel}${body.zoneLabel ? ` · ${body.zoneLabel}` : ''}`,
      'reservation',
    );
    const minsUntil = Math.round((start.getTime() - Date.now()) / 60000);
    if (minsUntil > 5) {
      await this.notifications.push(
        userId,
        'Parking reminder',
        `${body.lotName} starts in ${minsUntil} min — open Parko before you arrive`,
        'reminder',
      );
    }
    return this.toDto(row);
  }

  async cancel(userId: string, id: string) {
    const row = await this.reservations.findOne({ where: { id, userId } });
    if (!row) throw new NotFoundException('reservation_not_found');
    let refundKwd = 0;
    const now = new Date();
    if (
      row.walletPaid &&
      row.priceKwd > 0 &&
      row.status === 'confirmed' &&
      now < row.startAt
    ) {
      await this.wallet.refund(
        userId,
        row.priceKwd,
        `refund-reserve-${row.id}`,
        `Refund · ${row.lotName}`,
      );
      refundKwd = row.priceKwd;
    }
    row.status = 'cancelled';
    await this.reservations.save(row);
    await this.notifications.push(
      userId,
      'Reservation cancelled',
      refundKwd > 0
        ? `${row.lotName} · ${refundKwd.toFixed(2)} KWD refunded to wallet`
        : row.lotName,
      'reservation',
    );
    return { ...this.toDto(row), refundKwd };
  }

  private toDto(r: ParkingReservation) {
    return {
      id: r.id,
      lotId: r.lotId,
      lotName: r.lotName,
      lat: r.lat,
      lng: r.lng,
      startAt: r.startAt.toISOString(),
      endAt: r.endAt.toISOString(),
      priceKwd: r.priceKwd,
      status: r.status,
      zoneLabel: r.zoneLabel,
      walletPaid: r.walletPaid,
    };
  }
}
