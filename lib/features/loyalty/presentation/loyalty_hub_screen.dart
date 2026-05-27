import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/api_config.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/loyalty_providers.dart';
import '../domain/loyalty_level.dart';
import '../domain/loyalty_models.dart';
import 'loyalty_tier_labels.dart';

class LoyaltyHubScreen extends ConsumerWidget {
  const LoyaltyHubScreen({super.key});

  Future<void> _earnDemo(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      final r = await ref.read(loyaltyControllerProvider.notifier).earnParking(3.5, reference: 'demo-session');
      messenger.showSnackBar(SnackBar(content: Text(l10n.loyaltySnackEarned(r.pointsAwarded))));
      if (r.levelUp && r.newTier != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.loyaltySnackLevelUp(loyaltyTierLabel(r.newTier!, l10n)))),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(loyaltyErrorMessage(e))));
    }
  }

  Future<void> _checkIn(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(loyaltyControllerProvider.notifier).dailyCheckIn();
      messenger.showSnackBar(SnackBar(content: Text(l10n.loyaltySnackCheckIn)));
    } catch (e) {
      final code = loyaltyErrorMessage(e);
      messenger.showSnackBar(
        SnackBar(content: Text(code == 'already_checked_in_today' ? l10n.loyaltyErrCheckInDone : code)),
      );
    }
  }

  Future<void> _redeem(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.loyaltyRedeemConfirmTitle),
        content: Text(l10n.loyaltyRedeemConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.loyaltyCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.loyaltyConfirm)),
        ],
      ),
    );
    if (go != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final kwd = await ref.read(loyaltyControllerProvider.notifier).redeemHundred();
      messenger.showSnackBar(SnackBar(content: Text(l10n.loyaltySnackRedeemWallet(kwd.toStringAsFixed(1)))));
    } catch (e) {
      final msg = loyaltyErrorMessage(e);
      messenger.showSnackBar(
        SnackBar(content: Text(msg.contains('insufficient') ? l10n.loyaltyErrBalance : msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(loyaltyControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: context.parko.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.loyaltyScreenTitle),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loyaltyErrorMessage(e), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(loyaltyControllerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (LoyaltySummary s) {
          final nextName = nextTierLocalized(s.tier, l10n);
          final progressText = s.pointsToNextTier <= 0 || nextName == null
              ? l10n.loyaltyMaxTier
              : l10n.loyaltyProgressToNext(s.pointsToNextTier, nextName);

          return RefreshIndicator(
            onRefresh: () => ref.read(loyaltyControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                if (ApiConfig.parkoApiBase.trim().isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: ParkoColors.sky.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: ParkoColors.sky),
                            const SizedBox(width: 10),
                            Expanded(child: Text(l10n.loyaltyApiHint, style: Theme.of(context).textTheme.bodySmall)),
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: ParkoColors.gradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(loyaltyTierEmoji(s.tier), style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              loyaltyTierLabel(s.tier, l10n),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.loyaltyBalance(s.balancePoints),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.loyaltyLifetime(s.lifetimeEarned),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Text(progressText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                      const SizedBox(height: 6),
                      if (s.tier != LoyaltyTier.platinum)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: _tierProgress(s.lifetimeEarned),
                            minHeight: 8,
                            backgroundColor: Colors.white24,
                            color: context.parko.panel,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.loyaltyScreenSubtitle, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 20),
                Text(l10n.loyaltyRewardsTitle, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Text(l10n.loyaltyRedemptionRule, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                GradientButton(
                  label: l10n.loyaltyRedeem100,
                  onPressed: s.balancePoints >= 100 ? () => _redeem(context, ref) : null,
                  icon: Icons.card_giftcard_rounded,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _checkIn(context, ref),
                  icon: const Icon(Icons.calendar_today_rounded),
                  label: Text(l10n.loyaltyDailyCheckIn),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _earnDemo(context, ref),
                  icon: const Icon(Icons.directions_car_filled_rounded),
                  label: Text(l10n.loyaltyDemoParking),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 28),
                Text(l10n.loyaltyTiersTitle, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                _bullet(l10n.loyaltyPerkBronze),
                _bullet(l10n.loyaltyPerkSilver),
                _bullet(l10n.loyaltyPerkGold),
                _bullet(l10n.loyaltyPerkPlatinum),
                const SizedBox(height: 28),
                Text(l10n.loyaltyHistoryTitle, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                if (s.transactions.isEmpty)
                  Text(l10n.loyaltyEmptyHistory, style: Theme.of(context).textTheme.bodyMedium)
                else
                  ...s.transactions.map((t) => _TxTile(t: t)),
              ],
            ),
          );
        },
      ),
    );
  }

  double _tierProgress(int lifetime) {
    if (lifetime >= 5000) return 1;
    if (lifetime >= 2000) return (lifetime - 2000) / 3000;
    if (lifetime >= 500) return (lifetime - 500) / 1500;
    return lifetime / 500;
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: ParkoColors.sky, fontWeight: FontWeight.w800)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  const _TxTile({required this.t});

  final PointsTransaction t;

  @override
  Widget build(BuildContext context) {
    final sign = t.amount >= 0 ? '+' : '';
    final color = t.amount >= 0 ? ParkoColors.green : ParkoColors.red;
    final date = '${t.createdAt.year}-${t.createdAt.month.toString().padLeft(2, '0')}-${t.createdAt.day.toString().padLeft(2, '0')}';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('${t.type} · $date', style: Theme.of(context).textTheme.bodyMedium),
        subtitle: t.reference != null ? Text(t.reference!, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        trailing: Text(
          '$sign${t.amount}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
