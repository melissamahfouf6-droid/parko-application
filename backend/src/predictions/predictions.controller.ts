import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Headers,
  Param,
  Post,
} from '@nestjs/common';
import { PredictionsService } from './predictions.service';

const HDR = 'x-user-id';

@Controller('predictions')
export class PredictionsController {
  constructor(private readonly predictions: PredictionsService) {}

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }

  @Get('highlights')
  highlights() {
    return this.predictions.getHomeHighlights();
  }

  @Get('lot/:lotId')
  lot(@Param('lotId') lotId: string) {
    return this.predictions.getLotPrediction(lotId);
  }

  @Post('waitlist')
  async waitlist(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { lotId?: string },
  ) {
    if (!body?.lotId) throw new BadRequestException('lotId required');
    return this.predictions.joinWaitlist(this.uid(headers), body.lotId);
  }

  @Get('waitlist')
  async myWaitlist(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.predictions.listWaitlist(this.uid(headers));
  }
}
