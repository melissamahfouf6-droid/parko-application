import '../domain/private_spot_listing.dart';
import 'marketplace_repository.dart';

class MockMarketplaceRepository implements MarketplaceRepository {
  final List<PrivateSpotListing> _list = [
    const PrivateSpotListing(
      id: 'm1',
      title: 'Salmiya building spot',
      lat: 29.3397,
      lng: 48.0768,
      priceKwdPerDay: 1.5,
      availability: 'Weekdays 8AM–5PM',
      rating: 4.7,
      reviewCount: 12,
      estimatedMonthlyKwd: 33,
    ),
    const PrivateSpotListing(
      id: 'm2',
      title: 'Jabriya driveway',
      lat: 29.3212,
      lng: 48.0284,
      priceKwdPerDay: 2.0,
      availability: '24/7',
      rating: 4.9,
      reviewCount: 28,
      estimatedMonthlyKwd: 44,
    ),
    const PrivateSpotListing(
      id: 'm3',
      title: 'Bayan villa parking',
      lat: 29.3631,
      lng: 48.0439,
      priceKwdPerDay: 1.2,
      availability: 'Sat–Thu 6AM–10PM',
      rating: 4.4,
      reviewCount: 7,
      estimatedMonthlyKwd: 26.4,
    ),
  ];

  @override
  Future<List<PrivateSpotListing>> listings() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.from(_list);
  }

  @override
  Future<PrivateSpotListing> createListing({
    required String title,
    required double priceKwdPerDay,
    required String availability,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final spot = PrivateSpotListing(
      id: 'm-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      lat: 29.35,
      lng: 47.98,
      priceKwdPerDay: priceKwdPerDay,
      availability: availability,
      rating: 5,
      reviewCount: 0,
      estimatedMonthlyKwd: priceKwdPerDay * 22,
    );
    _list.insert(0, spot);
    return spot;
  }
}
