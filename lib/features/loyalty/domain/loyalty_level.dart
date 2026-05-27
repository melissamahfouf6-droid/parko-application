enum LoyaltyTier { bronze, silver, gold, platinum }

LoyaltyTier tierFromLifetimePoints(int lifetime) {
  if (lifetime >= 5000) return LoyaltyTier.platinum;
  if (lifetime >= 2000) return LoyaltyTier.gold;
  if (lifetime >= 500) return LoyaltyTier.silver;
  return LoyaltyTier.bronze;
}

/// Points still needed to reach the next tier (0 at Platinum).
int remainingPointsToNextTier(int lifetime) {
  if (lifetime >= 5000) return 0;
  if (lifetime >= 2000) return 5000 - lifetime;
  if (lifetime >= 500) return 2000 - lifetime;
  return 500 - lifetime;
}

LoyaltyTier parseLoyaltyTier(String s) {
  switch (s.toLowerCase()) {
    case 'platinum':
      return LoyaltyTier.platinum;
    case 'gold':
      return LoyaltyTier.gold;
    case 'silver':
      return LoyaltyTier.silver;
    default:
      return LoyaltyTier.bronze;
  }
}

LoyaltyTier? nextTier(LoyaltyTier current) {
  switch (current) {
    case LoyaltyTier.bronze:
      return LoyaltyTier.silver;
    case LoyaltyTier.silver:
      return LoyaltyTier.gold;
    case LoyaltyTier.gold:
      return LoyaltyTier.platinum;
    case LoyaltyTier.platinum:
      return null;
  }
}
