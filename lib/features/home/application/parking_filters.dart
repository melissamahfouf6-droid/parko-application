import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/parking_lot.dart';
import 'home_providers.dart';
import 'map_location_providers.dart';

enum MapQuickFilter { all, free, valet, reservable }

final mapQuickFilterProvider = StateProvider<MapQuickFilter>((ref) => MapQuickFilter.all);

class ParkingMapFilters {
  const ParkingMapFilters({
    this.availableNow = true,
    this.reservableAhead = false,
    this.showFullLots = false,
  });

  final bool availableNow;
  final bool reservableAhead;
  final bool showFullLots;

  ParkingMapFilters copyWith({
    bool? availableNow,
    bool? reservableAhead,
    bool? showFullLots,
  }) {
    return ParkingMapFilters(
      availableNow: availableNow ?? this.availableNow,
      reservableAhead: reservableAhead ?? this.reservableAhead,
      showFullLots: showFullLots ?? this.showFullLots,
    );
  }

  static const defaults = ParkingMapFilters();
}

final parkingMapFiltersProvider =
    StateProvider<ParkingMapFilters>((ref) => ParkingMapFilters.defaults);

List<ParkingLot> applyParkingFilters(
  List<ParkingLot> lots,
  ParkingMapFilters f, {
  MapQuickFilter quick = MapQuickFilter.all,
}) {
  return lots.where((lot) {
    if (f.reservableAhead && !lot.supportsReservation) return false;
    if (!f.showFullLots && lot.isNearlyFull) return false;
    if (f.availableNow && !lot.hasAvailabilityNow) return false;
    switch (quick) {
      case MapQuickFilter.free:
        if (!lot.isFree) return false;
        break;
      case MapQuickFilter.valet:
        if (!lot.hasValet) return false;
        break;
      case MapQuickFilter.reservable:
        if (!lot.supportsReservation) return false;
        break;
      case MapQuickFilter.all:
        break;
    }
    return true;
  }).toList();
}

final filteredNearbyLotsProvider = Provider<AsyncValue<List<ParkingLot>>>((ref) {
  final lotsAsync = ref.watch(nearbyLotsProvider);
  final filters = ref.watch(parkingMapFiltersProvider);
  final quick = ref.watch(mapQuickFilterProvider);
  final center = ref.watch(mapCenterProvider);
  return lotsAsync.whenData((lots) {
    var list = applyParkingFilters(lots, filters, quick: quick);
    if (center != null) {
      list = List<ParkingLot>.from(list)
        ..sort((a, b) => lotDistanceKm(a, center).compareTo(lotDistanceKm(b, center)));
    }
    return list;
  });
});

final filteredLotCountProvider = Provider<int>((ref) {
  return ref.watch(filteredNearbyLotsProvider).valueOrNull?.length ?? 0;
});

final selectedLotProvider = Provider<ParkingLot?>((ref) {
  final selectedId = ref.watch(selectedParkingLotIdProvider);
  final lots = ref.watch(filteredNearbyLotsProvider).valueOrNull ?? [];
  for (final l in lots) {
    if (l.id == selectedId) return l;
  }
  return null;
});
