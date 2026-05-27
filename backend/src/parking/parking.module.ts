import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationsModule } from '../notifications/notifications.module';
import { ParkingLotReview } from './entities/parking-lot-review.entity';
import { ParkingSessionRecord } from './entities/parking-session.entity';
import { ParkingController } from './parking.controller';
import { ParkingService } from './parking.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([ParkingSessionRecord, ParkingLotReview]),
    NotificationsModule,
  ],
  controllers: [ParkingController],
  providers: [ParkingService],
  exports: [ParkingService],
})
export class ParkingModule {}
