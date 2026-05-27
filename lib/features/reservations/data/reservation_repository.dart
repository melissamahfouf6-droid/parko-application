import '../domain/parking_reservation.dart';

abstract class ReservationRepository {
  Future<ReservationsBundle> listReservations();

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
  });

  /// Returns KWD refunded to wallet, if any.
  Future<double> cancelReservation(String id);
}
