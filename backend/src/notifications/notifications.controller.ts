import {
  BadRequestException,
  Controller,
  Delete,
  Get,
  Headers,
  Param,
  Post,
} from '@nestjs/common';
import { NotificationsService } from './notifications.service';

const HDR = 'x-user-id';

@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get()
  list(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.notifications.list(this.uid(headers));
  }

  @Post('read-all')
  readAll(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.notifications.markAllRead(this.uid(headers));
  }

  @Post(':id/read')
  readOne(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('id') id: string,
  ) {
    return this.notifications.markRead(this.uid(headers), id);
  }

  @Delete(':id')
  dismiss(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('id') id: string,
  ) {
    return this.notifications.dismiss(this.uid(headers), id);
  }

  @Post('clear-read')
  clearRead(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.notifications.clearRead(this.uid(headers));
  }
}
