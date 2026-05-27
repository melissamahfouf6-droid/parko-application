import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/parking_history_item.dart';

enum ParkingHistoryFilter { all, sessions, reservations }

final parkingHistoryFilterProvider =
    StateProvider<ParkingHistoryFilter>((ref) => ParkingHistoryFilter.all);

List<ParkingHistoryItem> filterParkingHistory(
  List<ParkingHistoryItem> items,
  ParkingHistoryFilter filter,
) {
  switch (filter) {
    case ParkingHistoryFilter.all:
      return items;
    case ParkingHistoryFilter.sessions:
      return items.where((i) => i.source == 'session').toList();
    case ParkingHistoryFilter.reservations:
      return items.where((i) => i.source == 'reservation').toList();
  }
}
