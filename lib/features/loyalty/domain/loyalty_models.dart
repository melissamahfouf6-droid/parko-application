import 'loyalty_level.dart';

class PointsTransaction {
  const PointsTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
    this.reference,
  });

  final String id;
  final int amount;
  final String type;
  final String? reference;
  final DateTime createdAt;

  factory PointsTransaction.fromJson(Map<String, dynamic> j) {
    return PointsTransaction(
      id: j['id'] as String? ?? '',
      amount: (j['amount'] as num?)?.toInt() ?? 0,
      type: j['type'] as String? ?? '',
      reference: j['reference'] as String?,
      createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class LoyaltySummary {
  const LoyaltySummary({
    required this.userId,
    required this.balancePoints,
    required this.lifetimeEarned,
    required this.tier,
    required this.pointsToNextTier,
    required this.transactions,
  });

  final String userId;
  final int balancePoints;
  final int lifetimeEarned;
  final LoyaltyTier tier;
  final int pointsToNextTier;
  final List<PointsTransaction> transactions;

  factory LoyaltySummary.fromJson(Map<String, dynamic> j) {
    final lifetime = (j['lifetimeEarned'] as num?)?.toInt() ?? 0;
    final tierName = j['level'] as String? ?? 'bronze';
    return LoyaltySummary(
      userId: j['userId'] as String? ?? '',
      balancePoints: (j['balancePoints'] as num?)?.toInt() ?? 0,
      lifetimeEarned: lifetime,
      tier: parseLoyaltyTier(tierName),
      pointsToNextTier: (j['pointsToNextLevel'] as num?)?.toInt() ?? remainingPointsToNextTier(lifetime),
      transactions: (j['transactions'] as List<dynamic>? ?? [])
          .map((e) => PointsTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LoyaltyEarnResult {
  const LoyaltyEarnResult({
    required this.pointsAwarded,
    required this.levelUp,
    this.previousTier,
    this.newTier,
  });

  final int pointsAwarded;
  final bool levelUp;
  final LoyaltyTier? previousTier;
  final LoyaltyTier? newTier;

  factory LoyaltyEarnResult.fromJson(Map<String, dynamic> j) {
    return LoyaltyEarnResult(
      pointsAwarded: (j['pointsAwarded'] as num?)?.toInt() ?? 0,
      levelUp: j['levelUp'] as bool? ?? false,
      previousTier: j['previousLevel'] != null ? parseLoyaltyTier(j['previousLevel'] as String) : null,
      newTier: j['newLevel'] != null ? parseLoyaltyTier(j['newLevel'] as String) : null,
    );
  }
}
