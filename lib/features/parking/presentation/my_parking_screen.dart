import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../loyalty/application/loyalty_providers.dart';
import '../../loyalty/presentation/loyalty_tier_labels.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/parking_session_providers.dart';
import 'widgets/leave_early_sheet.dart';
import 'widgets/parking_history_tab.dart';
import 'widgets/session_receipt_sheet.dart';
import 'widgets/parking_stats_header.dart';
import 'widgets/upcoming_reservations_tab.dart';

class MyParkingScreen extends ConsumerWidget {
  const MyParkingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.parko.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
            color: context.parko.textPrimary,
          ),
          title: Text(l10n.myParkingTitle),
          bottom: TabBar(
            labelColor: ParkoColors.sky,
            unselectedLabelColor: context.parko.textSecondary,
            tabs: [
              Tab(text: l10n.tabActive),
              Tab(text: l10n.tabUpcoming),
              Tab(text: l10n.tabHistory),
            ],
          ),
        ),
        body: Column(
          children: [
            const ParkingStatsHeader(),
            Expanded(
              child: TabBarView(
                children: [
                  const _ActiveTab(),
                  const UpcomingReservationsTab(),
                  const ParkingHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveTab extends ConsumerWidget {
  const _ActiveTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(activeParkingSessionProvider);
    final listed = ref.watch(hasListedSpotProvider);

    if (session == null) {
      return Column(
        children: [
          Expanded(
            child: _EmptyTab(
              message: l10n.emptyActiveParking,
              actionLabel: l10n.shareStartDemoSession,
              onAction: () => ref.read(shareParkingControllerProvider).startDemoSession(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.bolt_rounded, color: ParkoColors.amber),
              label: Text(l10n.loyaltyDemoParking),
              onPressed: () => _earnDemoLoyalty(context, ref),
            ),
          ),
        ],
      );
    }

    final h = session.remainingMinutes ~/ 60;
    final m = session.remainingMinutes % 60;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_parking_rounded, color: ParkoColors.sky, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session.lotName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          Text(l10n.shareTimeLeft(h, m), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!listed)
                  GradientButton(
                    label: l10n.shareLeaveEarly,
                    icon: Icons.sell_rounded,
                    onPressed: () => LeaveEarlySheet.show(context, session),
                  )
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: ParkoColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: ParkoColors.green),
                          const SizedBox(width: 10),
                          Expanded(child: Text(l10n.shareListedSuccess((session.paidKwd * 0.7).toStringAsFixed(2)))),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(shareParkingControllerProvider).extendSession();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.sessionExtended(30))),
                          );
                        },
                        icon: const Icon(Icons.more_time_rounded, size: 20),
                        label: Text(l10n.sessionExtend30),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final ended = await ref.read(shareParkingControllerProvider).endSession();
                          if (!context.mounted || ended == null) return;
                          await SessionReceiptSheet.show(context, ended);
                        },
                        child: Text(l10n.shareEndSession),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(l10n.shareSheetTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        _SharedListingsList(),
      ],
    );
  }

  Future<void> _earnDemoLoyalty(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      final r = await ref.read(loyaltyControllerProvider.notifier).earnParking(3.5, reference: 'my-parking-demo');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.loyaltySnackEarned(r.pointsAwarded))));
      if (r.levelUp && r.newTier != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loyaltySnackLevelUp(loyaltyTierLabel(r.newTier!, l10n)))),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loyaltyErrorMessage(e))));
    }
  }
}

class _SharedListingsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sharedListingsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('$e'),
      data: (list) {
        final active = list.where((l) => l.status == 'active').toList();
        if (active.isEmpty) return const Text('No shared spots right now.');
        return Column(
          children: active.map((l) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.flash_on_rounded, color: ParkoColors.amber),
                title: Text(l.lotName),
                subtitle: Text(AppLocalizations.of(context).shareRemaining(l.remainingMinutes, l.discountPercent)),
                trailing: Text('${l.salePriceKwd.toStringAsFixed(2)} KWD'),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_parking_outlined, size: 64, color: context.parko.border),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            SizedBox(
              width: 260,
              child: GradientButton(label: actionLabel, onPressed: onAction),
            ),
          ],
        ),
      ),
    );
  }
}
