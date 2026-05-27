import 'package:dio/dio.dart';

import '../domain/parking_reservation.dart';
import 'reservation_repository.dart';

class ApiReservationRepository implements ReservationRepository {
  ApiReservationRepository({required Dio dio, required String baseUrl, required String userId})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<ReservationsBundle> listReservations() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/reservations',
      options: Options(headers: _headers),
    );
    final data = res.data ?? {};
    final upcoming = (data['upcoming'] as List<dynamic>? ?? [])
        .map((e) => ParkingReservation.fromJson(e as Map<String, dynamic>))
        .toList();
    final history = (data['history'] as List<dynamic>? ?? [])
        .map((e) => ParkingReservation.fromJson(e as Map<String, dynamic>))
        .toList();
    return ReservationsBundle(upcoming: upcoming, history: history);
  }

  @override
  Future<ParkingReservation> createReservation({
    required String lotId,
    required String lotName,
    double? lat,
    double? lng,
    required DateTime startAt,
    required DateTime endAt,
    required double priceKwd,
    String? zoneLabel,
    bool payFromWallet = false,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/reservations',
      data: {
        'lotId': lotId,
        'lotName': lotName,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        'startAt': startAt.toUtc().toIso8601String(),
        'endAt': endAt.toUtc().toIso8601String(),
        'priceKwd': priceKwd,
        if (zoneLabel != null && zoneLabel.isNotEmpty) 'zoneLabel': zoneLabel,
        if (payFromWallet) 'payFromWallet': true,
      },
      options: Options(headers: _headers),
    );
    return ParkingReservation.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<double> cancelReservation(String id) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '$_base/api/reservations/$id',
      options: Options(headers: _headers),
    );
    return (res.data?['refundKwd'] as num?)?.toDouble() ?? 0;
  }
}
