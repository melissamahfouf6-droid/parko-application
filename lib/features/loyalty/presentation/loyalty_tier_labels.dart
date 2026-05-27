import '../../../l10n/app_localizations.dart';
import '../domain/loyalty_level.dart';

String loyaltyTierLabel(LoyaltyTier tier, AppLocalizations l10n) {
  switch (tier) {
    case LoyaltyTier.bronze:
      return l10n.loyaltyTierBronze;
    case LoyaltyTier.silver:
      return l10n.loyaltyTierSilver;
    case LoyaltyTier.gold:
      return l10n.loyaltyTierGold;
    case LoyaltyTier.platinum:
      return l10n.loyaltyTierPlatinum;
  }
}

String loyaltyTierEmoji(LoyaltyTier tier) {
  switch (tier) {
    case LoyaltyTier.bronze:
      return '🥉';
    case LoyaltyTier.silver:
      return '🥈';
    case LoyaltyTier.gold:
      return '🥇';
    case LoyaltyTier.platinum:
      return '💎';
  }
}

String? nextTierLocalized(LoyaltyTier current, AppLocalizations l10n) {
  final n = nextTier(current);
  if (n == null) return null;
  return loyaltyTierLabel(n, l10n);
}
