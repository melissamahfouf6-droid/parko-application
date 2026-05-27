import '../domain/parking_reservation.dart';
import 'reservation_repository.dart';

class MockReservationRepository implements ReservationRepository {
  final List<ParkingReservation> _all = [];
  final Map<String, bool> _walletPaid = {};

  MockReservationRepository() {
    final start = DateTime.now().add(const Duration(hours: 2));
    _all.add(
      ParkingReservation(
        id: 'mock-res-1',
        lotId: 'avenues',
        lotName: 'The Avenues Mall',
        startAt: start,
        endAt: start.add(const Duration(hours: 2)),
        priceKwd: 3.5,
        status: 'confirmed',
        lat: 29.3025,
        lng: 47.9408,
        zoneLabel: 'Zone B — Level 2',
      ),
    );
  }

  @override
  Future<ReservationsBundle> listReservations() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final upcoming = _all.where((r) => r.status == 'confirmed' && r.endAt.isAfter(now)).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
    final history = _all.where((r) => r.status != 'confirmed' || !r.endAt.isAfter(now)).toList()
      ..sort((a, b) => b.startAt.compareTo(a.startAt));
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
    // walletPaid tracked separately for mock refunds
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final r = ParkingReservation(
      id: 'mock-res-${DateTime.now().millisecondsSinceEpoch}',
      lotId: lotId,
      lotName: lotName,
      startAt: startAt,
      endAt: endAt,
      priceKwd: priceKwd,
      status: 'confirmed',
      lat: lat,
      lng: lng,
      zoneLabel: zoneLabel,
    );
    _all.insert(0, r);
    if (payFromWallet && priceKwd > 0) {
      _walletPaid[r.id] = true;
    }
    return r;
  }

  @override
  Future<double> cancelReservation(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final i = _all.indexWhere((r) => r.id == id);
    if (i < 0) throw StateError('reservation_not_found');
    final old = _all[i];
    _all[i] = ParkingReservation(
      id: old.id,
      lotId: old.lotId,
      lotName: old.lotName,
      startAt: old.startAt,
      endAt: old.endAt,
      priceKwd: old.priceKwd,
      status: 'cancelled',
      lat: old.lat,
      lng: old.lng,
      zoneLabel: old.zoneLabel,
    );
    final paid = _walletPaid.remove(id) == true;
    if (paid && old.priceKwd > 0 && DateTime.now().isBefore(old.startAt)) {
      return old.priceKwd;
    }
    return 0;
  }

  bool wasWalletPaid(String id) => _walletPaid[id] == true;
}
