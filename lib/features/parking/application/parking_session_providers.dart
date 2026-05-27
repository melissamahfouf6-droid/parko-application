import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../data/parking_session_api.dart';
import 'parking_history_providers.dart';
import '../../notifications/application/notifications_providers.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../data/api_share_parking_repository.dart';
import '../data/mock_share_parking_repository.dart';
import '../data/share_parking_repository.dart';
import '../domain/parking_session.dart';
import '../domain/shared_spot_listing.dart';

final shareParkingRepositoryProvider = Provider<ShareParkingRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockShareParkingRepository();
  return ApiShareParkingRepository(
    dio: ref.watch(dioProvider),
    baseUrl: base,
    userId: ref.watch(currentUserIdProvider),
  );
});

/// Demo active session — tap "Start demo session" on My Parking or home FAB flow.
final activeParkingSessionProvider = StateProvider<ParkingSession?>((ref) => null);

/// User listed their spot for early leave.
final hasListedSpotProvider = StateProvider<bool>((ref) => false);

final sharedListingsProvider = FutureProvider<List<SharedSpotListing>>((ref) {
  ref.watch(hasListedSpotProvider);
  return ref.watch(shareParkingRepositoryProvider).availableListings();
});

final shareParkingControllerProvider = Provider<ShareParkingController>((ref) {
  return ShareParkingController(ref);
});

class ShareParkingController {
  ShareParkingController(this._ref);

  final Ref _ref;

  ShareParkingRepository get _repo => _ref.read(shareParkingRepositoryProvider);

  void startDemoSession({
    String lotId = 'avenues',
    String lotName = 'The Avenues Mall',
    double lat = 29.3346,
    double lng = 47.9415,
    double paidKwd = 3.5,
    int durationMinutes = 120,
  }) {
    _ref.read(activeParkingSessionProvider.notifier).state = ParkingSession(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      lotId: lotId,
      lotName: lotName,
      lat: lat,
      lng: lng,
      durationMinutes: durationMinutes,
      paidKwd: paidKwd,
      startedAt: DateTime.now(),
    );
    _ref.read(hasListedSpotProvider.notifier).state = false;
  }

  Future<LeaveEarlyResult> leaveEarly() async {
    final session = _ref.read(activeParkingSessionProvider);
    if (session == null) throw StateError('no_active_session');
    final result = await _repo.listSpotForSale(session);
    _ref.read(hasListedSpotProvider.notifier).state = true;
    _ref.invalidate(sharedListingsProvider);
    return result;
  }

  Future<SharedSpotListing> claim(String listingId) async {
    final listing = await _repo.claimListing(listingId);
    _ref.invalidate(sharedListingsProvider);
    return listing;
  }

  void extendSession({int extraMinutes = 30}) {
    final session = _ref.read(activeParkingSessionProvider);
    if (session == null || session.isExpired) return;
    _ref.read(activeParkingSessionProvider.notifier).state = ParkingSession(
      id: session.id,
      lotId: session.lotId,
      lotName: session.lotName,
      lat: session.lat,
      lng: session.lng,
      durationMinutes: session.durationMinutes + extraMinutes,
      paidKwd: session.paidKwd,
      startedAt: session.startedAt,
    );
  }

  /// Ends session and returns the snapshot for a receipt UI.
  Future<ParkingSession?> endSession() async {
    final session = _ref.read(activeParkingSessionProvider);
    if (session != null) {
      final base = ApiConfig.parkoApiBase.trim();
      if (base.isNotEmpty) {
        try {
          final used = (session.durationMinutes - session.remainingMinutes).clamp(1, 24 * 60);
          await ApiParkingSessionApi(
            dio: _ref.read(dioProvider),
            baseUrl: base,
            userId: _ref.read(currentUserIdProvider),
          ).completeSession(
            lotId: session.lotId,
            durationMinutes: used,
            paidKwd: session.paidKwd,
          );
          _ref.invalidate(parkingHistoryProvider);
          _ref.invalidate(notificationFeedProvider);
        } catch (_) {}
      }
    }
    _ref.read(activeParkingSessionProvider.notifier).state = null;
    _ref.read(hasListedSpotProvider.notifier).state = false;
    return session;
  }
}
