import 'package:dio/dio.dart';

import '../domain/parking_session.dart';
import '../domain/shared_spot_listing.dart';
import 'share_parking_repository.dart';

class ApiShareParkingRepository implements ShareParkingRepository {
  ApiShareParkingRepository({
    required Dio dio,
    required String baseUrl,
    required String userId,
  })  : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<List<SharedSpotListing>> availableListings() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/api/share/available',
      options: Options(headers: _headers),
    );
    return (res.data ?? [])
        .map((e) => SharedSpotListing.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<LeaveEarlyResult> listSpotForSale(ParkingSession session) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/share/list',
      data: {
        'lotId': session.lotId,
        'lotName': session.lotName,
        'lat': session.lat,
        'lng': session.lng,
        'remainingMinutes': session.remainingMinutes,
        'originalPriceKwd': session.paidKwd,
      },
      options: Options(headers: _headers),
    );
    return LeaveEarlyResult.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<SharedSpotListing> claimListing(String listingId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/share/$listingId/claim',
      options: Options(headers: _headers),
    );
    final data = res.data ?? {};
    final listing = data['listing'] as Map<String, dynamic>? ?? data;
    return SharedSpotListing.fromJson(Map<String, dynamic>.from(listing));
  }
}
