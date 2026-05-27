import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_marketplace_repository.dart';
import '../data/marketplace_repository.dart';
import '../data/mock_marketplace_repository.dart';
import '../domain/private_spot_listing.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockMarketplaceRepository();
  return ApiMarketplaceRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final marketplaceListingsProvider = FutureProvider<List<PrivateSpotListing>>((ref) {
  return ref.watch(marketplaceRepositoryProvider).listings();
});
