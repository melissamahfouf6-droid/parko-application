import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/loyalty_providers.dart';

class HomeCheckInBanner extends ConsumerWidget {
  const HomeCheckInBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(canCheckInTodayProvider)) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: ParkoColors.amber.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push(AppRoute.loyalty.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.stars_rounded, color: ParkoColors.amber, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.homeCheckInPrompt,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.parko.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
