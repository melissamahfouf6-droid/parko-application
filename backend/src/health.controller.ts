import {
  Controller,
  Get,
  ServiceUnavailableException,
} from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';

type CheckStatus = 'up' | 'down';

@Controller()
export class HealthController {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  @Get(['health', 'healthz'])
  async health() {
    const payload = await this.collectHealth();
    if (!payload.ok) {
      throw new ServiceUnavailableException(payload);
    }
    return payload;
  }

  private async collectHealth() {
    const time = new Date().toISOString();
    const database = await this.checkDatabase();

    return {
      ok: database.status === 'up',
      service: 'parko-api',
      version: process.env.npm_package_version ?? '0.1.0',
      time,
      checks: {
        database,
      },
    };
  }

  private async checkDatabase(): Promise<{
    status: CheckStatus;
    latencyMs?: number;
    error?: string;
  }> {
    const started = Date.now();
    try {
      if (!this.dataSource.isInitialized) {
        return { status: 'down', error: 'database_not_initialized' };
      }
      await this.dataSource.query('SELECT 1');
      return { status: 'up', latencyMs: Date.now() - started };
    } catch (e) {
      return {
        status: 'down',
        latencyMs: Date.now() - started,
        error: e instanceof Error ? e.message : String(e),
      };
    }
  }
}
