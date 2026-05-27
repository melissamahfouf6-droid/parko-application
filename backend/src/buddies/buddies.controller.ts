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
import { BuddiesService } from './buddies.service';

const HDR = 'x-user-id';

@Controller('buddies')
export class BuddiesController {
  constructor(private readonly buddies: BuddiesService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get('nearby')
  nearby(@Query('destination') destination?: string) {
    if (!destination?.trim()) throw new BadRequestException('destination query required');
    return this.buddies.findByDestination(destination.trim());
  }

  @Post('join')
  join(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { destination?: string; displayName?: string; timeWindow?: string },
  ) {
    if (!body?.destination) throw new BadRequestException('destination required');
    return this.buddies.join(this.uid(headers), {
      destination: body.destination,
      displayName: body.displayName,
      timeWindow: body.timeWindow,
    });
  }

  @Get('chat/:threadId/messages')
  async messages(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('threadId') threadId: string,
  ) {
    try {
      return await this.buddies.listMessages(threadId, this.uid(headers));
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'error';
      if (msg === 'thread_not_found') throw new BadRequestException(msg);
      throw e;
    }
  }

  @Post('chat/:threadId/messages')
  async postMessage(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('threadId') threadId: string,
    @Body() body: { text?: string },
  ) {
    try {
      return await this.buddies.sendMessage(threadId, this.uid(headers), body?.text);
    } catch (e) {
      const msg = e instanceof Error ? e.message : 'error';
      if (msg === 'thread_not_found' || msg === 'text_required') {
        throw new BadRequestException(msg);
      }
      throw e;
    }
  }
}
