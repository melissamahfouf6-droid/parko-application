import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  Headers,
  Param,
  Post,
} from '@nestjs/common';
import { FavoritesService } from './favorites.service';

const HDR = 'x-user-id';

@Controller('favorites')
export class FavoritesController {
  constructor(private readonly favorites: FavoritesService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get()
  list(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.favorites.list(this.uid(headers));
  }

  @Get('check/:lotId')
  check(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('lotId') lotId: string,
  ) {
    return this.favorites.isFavorite(this.uid(headers), lotId);
  }

  @Post()
  add(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { lotId?: string; lotName?: string; lat?: number; lng?: number },
  ) {
    return this.favorites.add(this.uid(headers), body);
  }

  @Delete(':lotId')
  remove(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Param('lotId') lotId: string,
  ) {
    return this.favorites.remove(this.uid(headers), lotId);
  }
}
