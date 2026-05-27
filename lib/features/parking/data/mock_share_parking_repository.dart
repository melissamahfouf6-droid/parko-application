import '../domain/parking_session.dart';
import '../domain/shared_spot_listing.dart';
import 'share_parking_repository.dart';

class MockShareParkingRepository implements ShareParkingRepository {
  final List<SharedSpotListing> _listings = [
    const SharedSpotListing(
      id: 'demo-shared-1',
      lotId: 'hospital',
      lotName: 'Dasman Diabetes Institute',
      lat: 29.3683,
      lng: 47.9874,
      remainingMinutes: 95,
      originalPriceKwd: 2.0,
      salePriceKwd: 1.6,
      discountPercent: 20,
      sellerUserId: 'other-user',
    ),
  ];

  String? _myListingId;

  @override
  Future<List<SharedSpotListing>> availableListings() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.from(_listings.where((l) => l.status == 'active'));
  }

  @override
  Future<LeaveEarlyResult> listSpotForSale(ParkingSession session) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (_myListingId != null) throw StateError('already_listed');
    final sale = (session.paidKwd * 0.8 * 100).round() / 100;
    final listing = SharedSpotListing(
      id: 'my-listing-${DateTime.now().millisecondsSinceEpoch}',
      sellerUserId: 'demo-user-1',
      lotId: session.lotId,
      lotName: session.lotName,
      lat: session.lat,
      lng: session.lng,
      remainingMinutes: session.remainingMinutes,
      originalPriceKwd: session.paidKwd,
      salePriceKwd: sale,
      discountPercent: 20,
    );
    _listings.insert(0, listing);
    _myListingId = listing.id;
    return LeaveEarlyResult(
      listing: listing,
      sellerRefundKwd: (session.paidKwd * 0.7 * 100).round() / 100,
      handoffMinutes: 10,
    );
  }

  @override
  Future<SharedSpotListing> claimListing(String listingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final i = _listings.indexWhere((l) => l.id == listingId);
    if (i < 0) throw StateError('listing_not_found');
    final updated = SharedSpotListing(
      id: _listings[i].id,
      sellerUserId: _listings[i].sellerUserId,
      lotId: _listings[i].lotId,
      lotName: _listings[i].lotName,
      lat: _listings[i].lat,
      lng: _listings[i].lng,
      remainingMinutes: _listings[i].remainingMinutes,
      originalPriceKwd: _listings[i].originalPriceKwd,
      salePriceKwd: _listings[i].salePriceKwd,
      discountPercent: _listings[i].discountPercent,
      status: 'claimed',
    );
    _listings[i] = updated;
    return updated;
  }
}
