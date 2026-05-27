import '../domain/parking_buddy.dart';
import 'buddies_repository.dart';

class MockBuddiesRepository implements BuddiesRepository {
  final List<ParkingBuddy> _all = const [
    ParkingBuddy(id: 'b1', displayName: 'Sara', destination: '360 Mall', timeWindow: 'within_1h', seatsNeeded: 1),
    ParkingBuddy(id: 'b2', displayName: 'Fahad', destination: '360 Mall', timeWindow: 'within_1h', seatsNeeded: 2),
    ParkingBuddy(id: 'b3', displayName: 'Noura', destination: '360 Mall', timeWindow: 'within_2h', seatsNeeded: 1),
    ParkingBuddy(id: 'b4', displayName: 'Yousef', destination: 'The Avenues Mall', timeWindow: 'within_1h', seatsNeeded: 1),
  ];

  @override
  Future<List<ParkingBuddy>> findNearby(String destination) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final q = destination.toLowerCase();
    return _all.where((b) => b.destination.toLowerCase().contains(q) || q.contains('360')).toList();
  }

  @override
  Future<void> joinBuddySearch(String destination, {String? displayName}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
}
