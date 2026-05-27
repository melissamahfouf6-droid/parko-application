import 'package:dio/dio.dart';

import '../domain/private_spot_listing.dart';
import 'marketplace_repository.dart';

class ApiMarketplaceRepository implements MarketplaceRepository {
  ApiMarketplaceRepository({required Dio dio, required String baseUrl, required String userId})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<List<PrivateSpotListing>> listings() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/api/marketplace/listings',
      options: Options(headers: _headers),
    );
    return (res.data ?? []).map((e) => PrivateSpotListing.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PrivateSpotListing> createListing({
    required String title,
    required double priceKwdPerDay,
    required String availability,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/marketplace/listings',
      data: {'title': title, 'priceKwdPerDay': priceKwdPerDay, 'availability': availability},
      options: Options(headers: _headers),
    );
    return PrivateSpotListing.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }
}
