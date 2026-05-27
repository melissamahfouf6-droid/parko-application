import {
  Body,
  Controller,
  Get,
  Headers,
  Patch,
  Post,
  BadRequestException,
} from '@nestjs/common';
import { AuthService } from './auth.service';

const HDR = 'x-user-id';

@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('otp/send')
  sendOtp(@Body() body: { phone?: string }) {
    return this.auth.sendOtp(body.phone);
  }

  @Post('otp/verify')
  verifyOtp(@Body() body: { phone?: string; code?: string }) {
    return this.auth.verifyOtp(body.phone, body.code);
  }

  @Get('me')
  me(@Headers() headers: Record<string, string | string[] | undefined>) {
    return this.auth.profile(this.uid(headers));
  }

  @Patch('profile')
  updateProfile(
    @Headers() headers: Record<string, string | string[] | undefined>,
    @Body() body: { displayName?: string; email?: string },
  ) {
    return this.auth.updateProfile(this.uid(headers), body);
  }

  private uid(h: Record<string, string | string[] | undefined>): string {
    const raw = h[HDR] ?? h['X-User-Id'];
    const v = Array.isArray(raw) ? raw[0] : raw;
    if (!v?.trim()) throw new BadRequestException(`Missing header ${HDR}`);
    return v.trim();
  }
}
