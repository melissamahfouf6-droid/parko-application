import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_health.dart';
import '../../favorites/application/favorites_providers.dart';
import '../../predictions/application/prediction_providers.dart';
import 'map_tiles_providers.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../notifications/application/notifications_providers.dart';
import '../../reservations/application/reservation_providers.dart';
import '../../wallet/application/wallet_providers.dart';
import 'home_providers.dart';

/// Refreshes map lots, wallet, loyalty, notifications, reservations, favorites.
void refreshHomeMapData(WidgetRef ref) {
  ref.invalidate(nearbyLotsProvider);
  ref.invalidate(apiHealthProvider);
  ref.invalidate(mapTilesReachableProvider);
  ref.invalidate(waitlistSyncProvider);
  ref.invalidate(walletSummaryProvider);
  ref.invalidate(notificationFeedProvider);
  ref.invalidate(savedLotsProvider);
  ref.invalidate(reservationsBundleProvider);
  ref.read(loyaltyControllerProvider.notifier).refresh();
}
