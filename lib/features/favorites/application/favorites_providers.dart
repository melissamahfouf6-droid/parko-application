import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/location/map_center.dart';
import '../../../core/network/dio_client.dart';
import '../../home/application/home_providers.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/favorites_repository.dart';
import '../domain/saved_lot.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockFavoritesRepository();
  return ApiFavoritesRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final savedLotsProvider = FutureProvider<List<SavedLot>>((ref) {
  return ref.watch(favoritesRepositoryProvider).fetchAll();
});

final isLotSavedProvider = Provider.family<bool, String>((ref, lotId) {
  final list = ref.watch(savedLotsProvider).valueOrNull;
  if (list == null) return false;
  return list.any((e) => e.lotId == lotId);
});

final favoritesControllerProvider = Provider<FavoritesController>((ref) {
  return FavoritesController(ref);
});

class FavoritesController {
  FavoritesController(this._ref);

  final Ref _ref;

  FavoritesRepository get _repo => _ref.read(favoritesRepositoryProvider);

  Future<bool> toggle({
    required String lotId,
    required String lotName,
    required double lat,
    required double lng,
    required bool currentlySaved,
  }) async {
    if (currentlySaved) {
      await _repo.remove(lotId);
    } else {
      await _repo.save(lotId: lotId, lotName: lotName, lat: lat, lng: lng);
    }
    _ref.invalidate(savedLotsProvider);
    return !currentlySaved;
  }

  void openOnMap(SavedLot lot) {
    _ref.read(mapCenterProvider.notifier).state = MapCenter(lat: lot.lat, lng: lot.lng, label: lot.lotName);
    _ref.read(selectedParkingLotIdProvider.notifier).state = lot.lotId;
    _ref.read(mapFocusLotIdProvider.notifier).state = lot.lotId;
  }
}
