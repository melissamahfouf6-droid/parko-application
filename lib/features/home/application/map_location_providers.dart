import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/location/location_service.dart';
import '../../../core/location/map_center.dart';
import '../domain/parking_lot.dart';
import 'home_providers.dart';

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final locationBusyProvider = StateProvider<bool>((ref) => false);

final mapLocationControllerProvider = Provider<MapLocationController>((ref) {
  return MapLocationController(ref);
});

class MapLocationController {
  MapLocationController(this._ref);

  final Ref _ref;

  Future<bool> centerOnUser() async {
    _ref.read(locationBusyProvider.notifier).state = true;
    try {
      final center = await _ref.read(locationServiceProvider).getCurrentCenter();
      if (center == null) return false;
      _ref.read(mapCenterProvider.notifier).state = center;
      _ref.invalidate(nearbyLotsProvider);
      return true;
    } finally {
      _ref.read(locationBusyProvider.notifier).state = false;
    }
  }

  void focusLot(ParkingLot lot) {
    _ref.read(mapCenterProvider.notifier).state = MapCenter(
      lat: lot.lat,
      lng: lot.lng,
      label: lot.name,
    );
    _ref.read(mapFocusLotIdProvider.notifier).state = lot.id;
    _ref.read(selectedParkingLotIdProvider.notifier).state = lot.id;
    _ref.invalidate(nearbyLotsProvider);
  }

  void clearFocus() {
    _ref.read(mapFocusLotIdProvider.notifier).state = null;
  }
}

/// Distance in km from current map center to a lot.
double lotDistanceKm(ParkingLot lot, MapCenter center) {
  const dist = Distance();
  return dist.as(
    LengthUnit.Kilometer,
    LatLng(center.lat, center.lng),
    LatLng(lot.lat, lot.lng),
  );
}
