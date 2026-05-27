import '../domain/parking_history_item.dart';

abstract class ParkingHistoryRepository {
  Future<List<ParkingHistoryItem>> fetchHistory();
}
