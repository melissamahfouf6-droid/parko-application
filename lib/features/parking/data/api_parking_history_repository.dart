import 'package:dio/dio.dart';

import '../../reservations/domain/parking_reservation.dart';
import '../../reservations/data/reservation_repository.dart';
import '../domain/parking_history_item.dart';
import 'parking_history_repository.dart';

class ApiParkingHistoryRepository implements ParkingHistoryRepository {
  ApiParkingHistoryRepository({
    required Dio dio,
    required String baseUrl,
    required String userId,
    required ReservationRepository reservations,
  })  : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId,
        _reservations = reservations;

  final Dio _dio;
  final String _base;
  final String _userId;
  final ReservationRepository _reservations;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<List<ParkingHistoryItem>> fetchHistory() async {
    final sessionsRes = await _dio.get<List<dynamic>>(
      '$_base/api/parking/sessions/history',
      options: Options(headers: _headers),
    );
    final sessions = (sessionsRes.data ?? [])
        .map((e) => ParkingHistoryItem.fromSessionJson(e as Map<String, dynamic>))
        .toList();

    final bundle = await _reservations.listReservations();
    final fromReservations = bundle.history.map(_fromReservation).toList();

    final merged = [...sessions, ...fromReservations];
    merged.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return merged;
  }

  ParkingHistoryItem _fromReservation(ParkingReservation r) {
    return ParkingHistoryItem.fromReservation(
      lotId: r.lotId,
      id: r.id,
      lotName: r.lotName,
      priceKwd: r.priceKwd,
      startAt: r.startAt,
      endAt: r.endAt,
    );
  }
}
