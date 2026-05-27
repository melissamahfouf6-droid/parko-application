import 'package:latlong2/latlong.dart';

import 'parking_lot.dart';

class LotMapCluster {
  const LotMapCluster({
    required this.center,
    required this.lots,
  });

  final LatLng center;
  final List<ParkingLot> lots;

  bool get isSingle => lots.length == 1;
  ParkingLot get representative => lots.first;

  int get totalAvailable => lots.fold<int>(0, (s, l) => s + l.availableSpots);

  double get minAvailabilityRatio {
    return lots.map((l) => l.availabilityRatio).reduce((a, b) => a < b ? a : b);
  }
}

List<LotMapCluster> clusterParkingLots(List<ParkingLot> lots, double zoom) {
  if (zoom >= 14 || lots.length <= 1) {
    return lots
        .map((l) => LotMapCluster(center: LatLng(l.lat, l.lng), lots: [l]))
        .toList();
  }

  final cell = zoom < 12 ? 0.045 : 0.022;
  final buckets = <String, List<ParkingLot>>{};

  for (final lot in lots) {
    final key = '${(lot.lat / cell).floor()}_${(lot.lng / cell).floor()}';
    buckets.putIfAbsent(key, () => []).add(lot);
  }

  return buckets.values.map((group) {
    final lat = group.map((l) => l.lat).reduce((a, b) => a + b) / group.length;
    final lng = group.map((l) => l.lng).reduce((a, b) => a + b) / group.length;
    return LotMapCluster(center: LatLng(lat, lng), lots: group);
  }).toList();
}
