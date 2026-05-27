import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BuddySeeker } from './entities/buddy-seeker.entity';
import { BuddyMessage } from './entities/buddy-message.entity';
import { BuddiesController } from './buddies.controller';
import { BuddiesService } from './buddies.service';

@Module({
  imports: [TypeOrmModule.forFeature([BuddySeeker, BuddyMessage])],
  controllers: [BuddiesController],
  providers: [BuddiesService],
})
export class BuddiesModule {}
