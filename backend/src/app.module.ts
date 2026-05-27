import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LoyaltyModule } from './loyalty/loyalty.module';
import { LoyaltyAccount } from './loyalty/entities/loyalty-account.entity';
import { PointsTransaction } from './loyalty/entities/points-transaction.entity';
import { PredictionsModule } from './predictions/predictions.module';
import { AvailabilityWaitlist } from './predictions/entities/availability-waitlist.entity';
import { ShareModule } from './share/share.module';
import { SharedSpotListing } from './share/entities/shared-spot-listing.entity';
import { BuddiesModule } from './buddies/buddies.module';
import { BuddySeeker } from './buddies/entities/buddy-seeker.entity';
import { BuddyMessage } from './buddies/entities/buddy-message.entity';
import { MarketplaceModule } from './marketplace/marketplace.module';
import { PrivateSpotListing } from './marketplace/entities/private-spot-listing.entity';
import { ReservationsModule } from './reservations/reservations.module';
import { ParkingReservation } from './reservations/entities/parking-reservation.entity';
import { WalletModule } from './wallet/wallet.module';
import { WalletAccount } from './wallet/entities/wallet-account.entity';
import { WalletTransaction } from './wallet/entities/wallet-transaction.entity';
import { NotificationsModule } from './notifications/notifications.module';
import { AppNotification } from './notifications/entities/app-notification.entity';
import { ParkingModule } from './parking/parking.module';
import { ParkingSessionRecord } from './parking/entities/parking-session.entity';
import { ParkingLotReview } from './parking/entities/parking-lot-review.entity';
import { FavoritesModule } from './favorites/favorites.module';
import { SavedLot } from './favorites/entities/saved-lot.entity';
import { AuthModule } from './auth/auth.module';
import { AppUser } from './auth/entities/app-user.entity';
import { HealthController } from './health.controller';

@Module({
  controllers: [HealthController],
  imports: [
    TypeOrmModule.forRoot({
      type: 'sqlite',
      database: 'parko.db',
      entities: [
        LoyaltyAccount,
        PointsTransaction,
        AvailabilityWaitlist,
        SharedSpotListing,
        BuddySeeker,
        BuddyMessage,
        PrivateSpotListing,
        ParkingReservation,
        WalletAccount,
        WalletTransaction,
        AppNotification,
        ParkingSessionRecord,
        ParkingLotReview,
        SavedLot,
        AppUser,
      ],
      synchronize: true,
      logging: false,
    }),
    LoyaltyModule,
    PredictionsModule,
    ShareModule,
    BuddiesModule,
    MarketplaceModule,
    ReservationsModule,
    WalletModule,
    NotificationsModule,
    ParkingModule,
    FavoritesModule,
    AuthModule,
  ],
})
export class AppModule {}
