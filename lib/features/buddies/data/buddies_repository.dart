import '../domain/parking_buddy.dart';

abstract class BuddiesRepository {
  Future<List<ParkingBuddy>> findNearby(String destination);
  Future<void> joinBuddySearch(String destination, {String? displayName});
}
