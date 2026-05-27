import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/map_center.dart';
import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_parking_repository.dart';
import '../data/parking_repository.dart';
import '../domain/parking_lot.dart';

const kuwaitCityCenter = MapCenter(lat: 29.3759, lng: 47.9774, label: 'kuwait_city');

final mapCenterProvider = StateProvider<MapCenter?>((ref) => null);

final mapFocusLotIdProvider = StateProvider<String?>((ref) => null);

final parkingRepositoryProvider = Provider<ParkingRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockParkingRepository();
  return ResilientParkingRepository(
    api: ApiParkingRepository(dio: ref.watch(dioProvider), baseUrl: base),
  );
});

/// True when map lots came from offline mock fallback (API unreachable).
final mapOfflineFallbackProvider = Provider<bool>((ref) {
  ref.watch(nearbyLotsProvider);
  return ResilientParkingRepository.lastFetchUsedOfflineFallback;
});

final selectedParkingLotIdProvider = StateProvider<String?>((ref) => null);

final nearbyLotsProvider = FutureProvider<List<ParkingLot>>((ref) async {
  final center = ref.watch(mapCenterProvider) ?? kuwaitCityCenter;
  final repo = ref.watch(parkingRepositoryProvider);
  return repo.nearbyLots(lat: center.lat, lng: center.lng);
});

