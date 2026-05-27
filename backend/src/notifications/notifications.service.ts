import { Injectable, NotFoundException, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AppNotification } from './entities/app-notification.entity';

const DEMO_USER = 'demo-user-1';

@Injectable()
export class NotificationsService implements OnModuleInit {
  constructor(
    @InjectRepository(AppNotification)
    private readonly notifications: Repository<AppNotification>,
  ) {}

  async onModuleInit() {
    const count = await this.notifications.count({ where: { userId: DEMO_USER } });
    if (count > 0) return;
    const seeds = [
      {
        title: 'Reservation confirmed',
        body: 'The Avenues Mall · today 6:00 PM · Zone B',
        category: 'reservation',
      },
      {
        title: 'Spot opening soon',
        body: '360 Mall predicted to ease around 4:30 PM',
        category: 'prediction',
      },
      {
        title: 'Shared spot nearby',
        body: '20% off at Dasman — 95 min left',
        category: 'share',
      },
    ];
    for (const s of seeds) {
      await this.notifications.save(
        this.notifications.create({ userId: DEMO_USER, ...s, read: false }),
      );
    }
  }

  async list(userId: string) {
    const rows = await this.notifications.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: 50,
    });
    const unread = rows.filter((r) => !r.read).length;
    return {
      unreadCount: unread,
      items: rows.map((r) => this.toDto(r)),
    };
  }

  async markRead(userId: string, id: string) {
    const row = await this.notifications.findOne({ where: { id, userId } });
    if (!row) throw new NotFoundException('notification_not_found');
    row.read = true;
    await this.notifications.save(row);
    return this.toDto(row);
  }

  async markAllRead(userId: string) {
    await this.notifications.update({ userId, read: false }, { read: true });
    return this.list(userId);
  }

  async dismiss(userId: string, id: string) {
    const row = await this.notifications.findOne({ where: { id, userId } });
    if (!row) throw new NotFoundException('notification_not_found');
    await this.notifications.remove(row);
    return { ok: true };
  }

  async clearRead(userId: string) {
    await this.notifications.delete({ userId, read: true });
    return this.list(userId);
  }

  async push(userId: string, title: string, body: string, category: string) {
    const row = await this.notifications.save(
      this.notifications.create({ userId, title, body, category, read: false }),
    );
    return this.toDto(row);
  }

  private toDto(r: AppNotification) {
    return {
      id: r.id,
      title: r.title,
      body: r.body,
      category: r.category,
      read: r.read,
      createdAt: r.createdAt.toISOString(),
    };
  }
}
