import '../domain/private_spot_listing.dart';

abstract class MarketplaceRepository {
  Future<List<PrivateSpotListing>> listings();
  Future<PrivateSpotListing> createListing({
    required String title,
    required double priceKwdPerDay,
    required String availability,
  });
}
