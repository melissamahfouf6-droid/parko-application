import 'package:dio/dio.dart';

abstract class ParkingSessionApi {
  Future<void> completeSession({
    required String lotId,
    required int durationMinutes,
    required double paidKwd,
  });
}

class ApiParkingSessionApi implements ParkingSessionApi {
  ApiParkingSessionApi({
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
  Future<void> completeSession({
    required String lotId,
    required int durationMinutes,
    required double paidKwd,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '$_base/api/parking/sessions/complete',
      data: {
        'lotId': lotId,
        'durationMinutes': durationMinutes,
        'paidKwd': paidKwd,
      },
      options: Options(headers: {'x-user-id': _userId}),
    );
  }
}
