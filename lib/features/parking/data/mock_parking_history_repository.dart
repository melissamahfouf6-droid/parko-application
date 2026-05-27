import '../domain/parking_history_item.dart';
import 'parking_history_repository.dart';

class MockParkingHistoryRepository implements ParkingHistoryRepository {
  @override
  Future<List<ParkingHistoryItem>> fetchHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [
      ParkingHistoryItem(
        id: 'mock-h1',
        lotName: 'The Avenues Mall',
        paidKwd: 3.5,
        durationLabel: '2h 15m',
        startedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ParkingHistoryItem(
        id: 'mock-h2',
        lotName: 'Kuwait University',
        paidKwd: 0,
        durationLabel: '45m',
        startedAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }
}
