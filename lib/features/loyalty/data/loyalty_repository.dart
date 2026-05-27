import '../domain/loyalty_models.dart';

abstract class LoyaltyRepository {
  Future<LoyaltySummary> fetchSummary();

  /// Awards points from completed parking (1 pt per 1 KWD rounded).
  Future<LoyaltyEarnResult> earnParkingSession(double kwdSpent, {String? reference});

  Future<LoyaltyEarnResult> dailyCheckIn();

  Future<LoyaltyEarnResult> earnReview({String? reference});

  /// Redeem [points] from balance (e.g. 100 → 5 KWD credit on server).
  Future<LoyaltySummary> redeem(int points);
}
