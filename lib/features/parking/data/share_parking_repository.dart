import '../domain/parking_session.dart';
import '../domain/shared_spot_listing.dart';

abstract class ShareParkingRepository {
  Future<List<SharedSpotListing>> availableListings();
  Future<LeaveEarlyResult> listSpotForSale(ParkingSession session);
  Future<SharedSpotListing> claimListing(String listingId);
}
