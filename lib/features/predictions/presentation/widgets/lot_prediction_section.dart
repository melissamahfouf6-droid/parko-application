import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/prediction_providers.dart';

class LotPredictionSection extends ConsumerStatefulWidget {
  const LotPredictionSection({super.key, required this.lotId});

  final String lotId;

  @override
  ConsumerState<LotPredictionSection> createState() => _LotPredictionSectionState();
}

class _LotPredictionSectionState extends ConsumerState<LotPredictionSection> {
  bool _notifying = false;

  Future<void> _notify() async {
    final l10n = AppLocalizations.of(context);
    final waitlist = ref.read(waitlistLotIdsProvider);
    if (waitlist.contains(widget.lotId)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.predictionNotifyAlready)));
      return;
    }
    setState(() => _notifying = true);
    try {
      final isNew = await ref.read(predictionRepositoryProvider).joinWaitlist(widget.lotId);
      if (!mounted) return;
      ref.read(waitlistLotIdsProvider.notifier).update((s) => {...s, widget.lotId});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isNew ? l10n.predictionNotifyDone : l10n.predictionNotifyAlready)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _notifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(lotPredictionProvider(widget.lotId));
    final onWaitlist = ref.watch(waitlistLotIdsProvider).contains(widget.lotId);

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (p) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.auto_graph_rounded, color: ParkoColors.purple, size: 22),
                const SizedBox(width: 8),
                Text(l10n.predictionSectionTitle, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: ParkoColors.purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ParkoColors.purple.withOpacity(0.25)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.insight, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text(
                      l10n.predictionChance(p.probabilityPercent),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (p.typicalOpenTime != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.predictionTypicalOpens(p.typicalOpenTime!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.predictionPatternTitle, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: p.hourlyPattern.map((pt) {
                  final h = (1 - pt.fillRate).clamp(0.05, 1.0);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: pt.fillRate < 0.35 ? ParkoColors.green : ParkoColors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${pt.hour}', style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onWaitlist || _notifying ? null : _notify,
              icon: _notifying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(onWaitlist ? Icons.notifications_active_rounded : Icons.notifications_outlined),
              label: Text(onWaitlist ? l10n.predictionNotifyAlready : l10n.predictionNotifyMe),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        );
      },
    );
  }
}
