import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BuddySeeker } from './entities/buddy-seeker.entity';
import { BuddyMessage } from './entities/buddy-message.entity';

function destKey(destination: string): string {
  return destination.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

@Injectable()
export class BuddiesService implements OnModuleInit {
  constructor(
    @InjectRepository(BuddySeeker)
    private readonly seekers: Repository<BuddySeeker>,
    @InjectRepository(BuddyMessage)
    private readonly messages: Repository<BuddyMessage>,
  ) {}

  async onModuleInit() {
    const count = await this.seekers.count();
    if (count > 0) return;
    const seeds = [
      { userId: 'buddy-1', displayName: 'Sara', destination: '360 Mall', destinationKey: '360-mall', timeWindow: 'within_1h', seatsNeeded: 1 },
      { userId: 'buddy-2', displayName: 'Fahad', destination: '360 Mall', destinationKey: '360-mall', timeWindow: 'within_1h', seatsNeeded: 2 },
      { userId: 'buddy-3', displayName: 'Noura', destination: '360 Mall', destinationKey: '360-mall', timeWindow: 'within_2h', seatsNeeded: 1 },
    ];
    for (const s of seeds) {
      await this.seekers.save(this.seekers.create(s));
    }
  }

  async findByDestination(destination: string) {
    const key = destKey(destination);
    const rows = await this.seekers.find({
      where: { destinationKey: key },
      order: { createdAt: 'DESC' },
    });
    return rows.map((r) => ({
      id: r.id,
      userId: r.userId,
      displayName: r.displayName,
      destination: r.destination,
      timeWindow: r.timeWindow,
      seatsNeeded: r.seatsNeeded,
    }));
  }

  async join(userId: string, body: { destination: string; displayName?: string; timeWindow?: string }) {
    const key = destKey(body.destination);
    const row = this.seekers.create({
      userId,
      displayName: body.displayName ?? 'Parko user',
      destination: body.destination,
      destinationKey: key,
      timeWindow: body.timeWindow ?? 'within_1h',
      seatsNeeded: 1,
    });
    await this.seekers.save(row);
    return { ok: true, id: row.id };
  }

  async listMessages(threadId: string, userId: string) {
    const thread = await this.seekers.findOne({ where: { id: threadId } });
    if (!thread) throw new Error('thread_not_found');
    let rows = await this.messages.find({
      where: { threadId },
      order: { createdAt: 'ASC' },
      take: 200,
    });
    if (rows.length === 0) {
      await this.messages.save(
        this.messages.create({
          threadId,
          senderUserId: thread.userId,
          text: `Hi! I'm ${thread.displayName} — want to coordinate parking at ${thread.destination}?`,
        }),
      );
      rows = await this.messages.find({
        where: { threadId },
        order: { createdAt: 'ASC' },
      });
    }
    return rows.map((m) => ({
      id: m.id,
      threadId: m.threadId,
      senderUserId: m.senderUserId,
      text: m.text,
      createdAt: m.createdAt.toISOString(),
      isMe: m.senderUserId === userId,
    }));
  }

  async sendMessage(threadId: string, userId: string, textRaw?: string) {
    const text = textRaw?.trim();
    if (!text) throw new Error('text_required');
    const thread = await this.seekers.findOne({ where: { id: threadId } });
    if (!thread) throw new Error('thread_not_found');
    const row = await this.messages.save(
      this.messages.create({ threadId, senderUserId: userId, text }),
    );
    return {
      id: row.id,
      threadId: row.threadId,
      senderUserId: row.senderUserId,
      text: row.text,
      createdAt: row.createdAt.toISOString(),
      isMe: true,
    };
  }
}
