import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../wallet/application/wallet_providers.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/notifications/parko_local_notifications.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../notifications/application/notifications_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../data/api_reservation_repository.dart';
import '../data/mock_reservation_repository.dart';
import '../data/reservation_repository.dart';
import '../domain/parking_reservation.dart';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockReservationRepository();
  return ApiReservationRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

final reservationsBundleProvider = FutureProvider<ReservationsBundle>((ref) {
  return ref.watch(reservationRepositoryProvider).listReservations();
});

final upcomingReservationsProvider = Provider<AsyncValue<List<ParkingReservation>>>((ref) {
  return ref.watch(reservationsBundleProvider).whenData((b) => b.upcoming);
});

final nextReservationProvider = Provider<ParkingReservation?>((ref) {
  final upcoming = ref.watch(upcomingReservationsProvider).valueOrNull;
  if (upcoming == null || upcoming.isEmpty) return null;
  return upcoming.first;
});

class ReservationController {
  ReservationController(this._ref);

  final Ref _ref;

  Future<ParkingReservation> reserve({
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
    final useApi = ApiConfig.parkoApiBase.trim().isNotEmpty;
    if (!useApi && payFromWallet && priceKwd > 0) {
      await _ref.read(walletControllerProvider).payParking(
            amountKwd: priceKwd,
            lotId: lotId,
            lotName: 'Reserve $lotName',
          );
    }
    final r = await _ref.read(reservationRepositoryProvider).createReservation(
          lotId: lotId,
          lotName: lotName,
          lat: lat,
          lng: lng,
          startAt: startAt,
          endAt: endAt,
          priceKwd: priceKwd,
          zoneLabel: zoneLabel,
          payFromWallet: payFromWallet,
        );
    _ref.invalidate(reservationsBundleProvider);
    _ref.invalidate(walletSummaryProvider);
    _ref.invalidate(notificationFeedProvider);
    if (_ref.read(userSettingsProvider).parkingReminders) {
      await ParkoLocalNotifications.instance.scheduleReservationReminder(
        reservationId: r.id,
        lotName: r.lotName,
        startAt: r.startAt,
      );
    }
    return r;
  }

  Future<double> cancel(String id) async {
    final useApi = ApiConfig.parkoApiBase.trim().isNotEmpty;
    var refund = await _ref.read(reservationRepositoryProvider).cancelReservation(id);
    if (!useApi && refund > 0) {
      await _ref.read(walletControllerProvider).topUp(refund);
    }
    await ParkoLocalNotifications.instance.cancelReservationReminder(id);
    _ref.invalidate(reservationsBundleProvider);
    _ref.invalidate(notificationFeedProvider);
    _ref.invalidate(walletSummaryProvider);
    return refund;
  }
}

final reservationControllerProvider = Provider<ReservationController>((ref) {
  return ReservationController(ref);
});
