import 'package:dio/dio.dart';

import '../domain/parking_prediction.dart';
import 'prediction_repository.dart';

class ApiPredictionRepository implements PredictionRepository {
  ApiPredictionRepository({
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
  Future<List<ParkingPrediction>> homeHighlights() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/api/predictions/highlights',
      options: Options(headers: _headers),
    );
    return (res.data ?? [])
        .map((e) => ParkingPrediction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ParkingPrediction> lotPrediction(String lotId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/predictions/lot/$lotId',
      options: Options(headers: _headers),
    );
    return ParkingPrediction.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<bool> joinWaitlist(String lotId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/predictions/waitlist',
      data: {'lotId': lotId},
      options: Options(headers: _headers),
    );
    final data = res.data ?? {};
    return data['alreadyRegistered'] != true;
  }

  @override
  Future<List<String>> listWaitlistLotIds() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/api/predictions/waitlist',
      options: Options(headers: _headers),
    );
    return (res.data ?? [])
        .map((e) => (e as Map<String, dynamic>)['lotId']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
  }
}
