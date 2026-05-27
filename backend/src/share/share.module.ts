import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SharedSpotListing } from './entities/shared-spot-listing.entity';
import { ShareController } from './share.controller';
import { ShareService } from './share.service';

@Module({
  imports: [TypeOrmModule.forFeature([SharedSpotListing])],
  controllers: [ShareController],
  providers: [ShareService],
})
export class ShareModule {}
