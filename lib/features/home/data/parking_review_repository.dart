import 'package:dio/dio.dart';

abstract class ParkingReviewRepository {
  Future<LotReviewResult> submitReview({
    required String lotId,
    required int stars,
    String? comment,
  });
}

class LotReviewResult {
  const LotReviewResult({
    required this.lotId,
    required this.rating,
    required this.reviewCount,
    this.pointsAwarded = 10,
  });

  final String lotId;
  final double rating;
  final int reviewCount;
  final int pointsAwarded;

  factory LotReviewResult.fromJson(Map<String, dynamic> json) {
    return LotReviewResult(
      lotId: json['lotId'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      pointsAwarded: (json['pointsHint'] as num?)?.toInt() ?? 10,
    );
  }
}

class MockParkingReviewRepository implements ParkingReviewRepository {
  @override
  Future<LotReviewResult> submitReview({
    required String lotId,
    required int stars,
    String? comment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return LotReviewResult(
      lotId: lotId,
      rating: stars.toDouble(),
      reviewCount: 100,
      pointsAwarded: 10,
    );
  }
}

class ApiParkingReviewRepository implements ParkingReviewRepository {
  ApiParkingReviewRepository({
    required Dio dio,
    required String baseUrl,
    required String userId,
  })  : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  @override
  Future<LotReviewResult> submitReview({
    required String lotId,
    required int stars,
    String? comment,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/parking/lots/$lotId/review',
      data: {
        'stars': stars,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
      options: Options(headers: {'x-user-id': _userId}),
    );
    return LotReviewResult.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }
}
