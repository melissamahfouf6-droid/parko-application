import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/prediction_providers.dart';
import '../../domain/parking_prediction.dart';

class PredictionHomeBanner extends ConsumerWidget {
  const PredictionHomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(predictionHighlightsProvider);

    return async.when(
      loading: () => const SizedBox(height: 4),
      error: (_, __) => const SizedBox.shrink(),
      data: (List<ParkingPrediction> items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 88,
          child: PageView.builder(
            itemCount: items.length,
            controller: PageController(viewportFraction: 0.92),
            itemBuilder: (context, index) {
              final p = items[index];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 6, right: 8),
                child: Material(
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  color: context.parko.panel,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: ParkoColors.purple.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔮', style: TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.predictionBannerOpens(p.lotName, p.minutesUntilLikely),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.predictionChance(p.probabilityPercent),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: context.parko.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
