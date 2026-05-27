import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_buddies_repository.dart';
import '../data/buddies_repository.dart';
import '../data/mock_buddies_repository.dart';
import '../domain/parking_buddy.dart';

final buddiesRepositoryProvider = Provider<BuddiesRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockBuddiesRepository();
  return ApiBuddiesRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

/// Last destination picked in search — drives home buddies card.
final selectedDestinationProvider = StateProvider<String?>((ref) => '360 Mall');

final buddiesForDestinationProvider = FutureProvider.family<List<ParkingBuddy>, String>((ref, dest) {
  return ref.watch(buddiesRepositoryProvider).findNearby(dest);
});
