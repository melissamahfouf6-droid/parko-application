import 'package:dio/dio.dart';

import '../domain/loyalty_models.dart';
import 'loyalty_repository.dart';

class ApiLoyaltyRepository implements LoyaltyRepository {
  ApiLoyaltyRepository({
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
  Future<LoyaltySummary> fetchSummary() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/loyalty/summary',
      options: Options(headers: _headers),
    );
    return LoyaltySummary.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<LoyaltyEarnResult> earnParkingSession(double kwdSpent, {String? reference}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/loyalty/earn',
      data: {
        'type': 'PARKING_SESSION',
        'kwdSpent': kwdSpent,
        if (reference != null) 'reference': reference,
      },
      options: Options(headers: _headers),
    );
    return LoyaltyEarnResult.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<LoyaltyEarnResult> earnReview({String? reference}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/loyalty/earn',
      data: {
        'type': 'REVIEW',
        'amount': 10,
        if (reference != null) 'reference': reference,
      },
      options: Options(headers: _headers),
    );
    return LoyaltyEarnResult.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<LoyaltyEarnResult> dailyCheckIn() async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/loyalty/check-in',
      options: Options(headers: _headers),
    );
    return LoyaltyEarnResult.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<LoyaltySummary> redeem(int points) async {
    await _dio.post<Map<String, dynamic>>(
      '$_base/api/loyalty/redeem',
      data: {'points': points},
      options: Options(headers: _headers),
    );
    return fetchSummary();
  }
}
