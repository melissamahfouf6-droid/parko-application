import 'package:dio/dio.dart';

import '../domain/parking_lot.dart';
import 'parking_repository.dart';

class ApiParkingRepository implements ParkingRepository {
  ApiParkingRepository({required Dio dio, required String baseUrl})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), '');

  final Dio _dio;
  final String _base;

  @override
  Future<List<ParkingLot>> nearbyLots({
    required double lat,
    required double lng,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/parking/lots/nearby',
      queryParameters: {'lat': lat, 'lng': lng, 'radiusKm': 30},
    );
    final data = res.data;
    if (data == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'empty_response',
      );
    }
    final lots = data['lots'] as List<dynamic>? ?? [];
    return lots
        .map((e) => ParkingLot.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
