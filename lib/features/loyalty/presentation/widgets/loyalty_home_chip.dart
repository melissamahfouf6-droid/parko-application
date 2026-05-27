import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/loyalty_providers.dart';
import '../loyalty_tier_labels.dart';

class LoyaltyHomeChip extends ConsumerWidget {
  const LoyaltyHomeChip({super.key});

  String _fmtPoints(int p) {
    if (p >= 10000) return '${(p / 1000).floor()}k';
    if (p >= 1000) return '${(p / 1000).toStringAsFixed(1)}k';
    return '$p';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(loyaltyControllerProvider);

    return async.when(
      loading: () => const SizedBox(
        width: 52,
        height: 48,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: ParkoColors.sky),
          ),
        ),
      ),
      error: (_, __) => IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        onPressed: () => ref.invalidate(loyaltyControllerProvider),
        icon: const Icon(Icons.error_outline_rounded, color: ParkoColors.red),
      ),
      data: (s) {
        final label = l10n.loyaltyHomeBadge(_fmtPoints(s.balancePoints));
        return Material(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push(AppRoute.loyalty.path),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 118, minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: context.parko.panel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.parko.border),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(loyaltyTierEmoji(s.tier), style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.parko.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
