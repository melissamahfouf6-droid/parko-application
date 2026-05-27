import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AvailabilityWaitlist } from './entities/availability-waitlist.entity';
import { PredictionsController } from './predictions.controller';
import { PredictionsService } from './predictions.service';

@Module({
  imports: [TypeOrmModule.forFeature([AvailabilityWaitlist])],
  controllers: [PredictionsController],
  providers: [PredictionsService],
})
export class PredictionsModule {}
