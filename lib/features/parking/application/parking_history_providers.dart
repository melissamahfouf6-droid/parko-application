import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../reservations/application/reservation_providers.dart';
import '../data/api_parking_history_repository.dart';
import '../data/mock_parking_history_repository.dart';
import '../data/parking_history_repository.dart';
import '../domain/parking_history_item.dart';

final parkingHistoryRepositoryProvider = Provider<ParkingHistoryRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockParkingHistoryRepository();
  return ApiParkingHistoryRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
    reservations: ref.watch(reservationRepositoryProvider),
  );
});

final parkingHistoryProvider = FutureProvider<List<ParkingHistoryItem>>((ref) {
  ref.watch(reservationsBundleProvider);
  return ref.watch(parkingHistoryRepositoryProvider).fetchHistory();
});
