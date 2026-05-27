import '../domain/loyalty_level.dart';
import '../../wallet/data/mock_wallet_repository.dart';
import '../domain/loyalty_models.dart';
import 'loyalty_repository.dart';


class _Mem {
  static int balance = 2340;
  static int lifetime = 2340;
  static final List<PointsTransaction> txs = [
    PointsTransaction(
      id: 'seed-1',
      amount: 2340,
      type: 'SEED',
      reference: 'welcome_bonus',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

/// In-memory loyalty (same rules as API) when `PARKO_API_BASE` is not set.
class MockLoyaltyRepository implements LoyaltyRepository {
  @override
  Future<LoyaltySummary> fetchSummary() async {
    final t = tierFromLifetimePoints(_Mem.lifetime);
    return LoyaltySummary(
      userId: 'demo-user-1',
      balancePoints: _Mem.balance,
      lifetimeEarned: _Mem.lifetime,
      tier: t,
      pointsToNextTier: remainingPointsToNextTier(_Mem.lifetime),
      transactions: List.from(_Mem.txs),
    );
  }

  @override
  Future<LoyaltyEarnResult> earnParkingSession(double kwdSpent, {String? reference}) async {
    final pts = kwdSpent.round().clamp(1, 100000);
    return _applyEarn(pts, 'PARKING_SESSION', reference);
  }

  @override
  Future<LoyaltyEarnResult> dailyCheckIn() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    for (final x in _Mem.txs) {
      if (x.type == 'DAILY_CHECKIN' && !x.createdAt.isBefore(start)) {
        throw StateError('already_checked_in_today');
      }
    }
    return _applyEarn(5, 'DAILY_CHECKIN', today.toIso8601String().substring(0, 10));
  }

  @override
  Future<LoyaltyEarnResult> earnReview({String? reference}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _applyEarn(10, 'REVIEW', reference);
  }

  @override
  Future<LoyaltySummary> redeem(int points) async {
    if (points <= 0 || _Mem.balance < points) {
      throw StateError('insufficient_balance');
    }
    _Mem.balance -= points;
    _Mem.txs.insert(
      0,
      PointsTransaction(
        id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
        amount: -points,
        type: 'REDEEM',
        reference: 'redeemed_${points}_pts',
        createdAt: DateTime.now(),
      ),
    );
    final kwd = ((points / 100) * 5 * 1000).round() / 1000;
    await sharedMockWalletRepository.topUp(kwd);
    return fetchSummary();
  }

  LoyaltyEarnResult _applyEarn(int amount, String type, String? reference) {
    final prev = tierFromLifetimePoints(_Mem.lifetime);
    _Mem.balance += amount;
    _Mem.lifetime += amount;
    final next = tierFromLifetimePoints(_Mem.lifetime);
    _Mem.txs.insert(
      0,
      PointsTransaction(
        id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
        amount: amount,
        type: type,
        reference: reference,
        createdAt: DateTime.now(),
      ),
    );
    return LoyaltyEarnResult(
      pointsAwarded: amount,
      levelUp: next != prev,
      previousTier: prev,
      newTier: next,
    );
  }
}
