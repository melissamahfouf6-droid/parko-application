import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_session_providers.dart';

/// Home banner: shared spots available nearby.
class SharedSpotsBanner extends ConsumerWidget {
  const SharedSpotsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(sharedListingsProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        final active = list.where((l) => l.status == 'active').length;
        if (active == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Material(
            color: ParkoColors.amber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.push(AppRoute.myParking.path),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.flash_on_rounded, color: ParkoColors.amber),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.shareAvailableNow(active),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: context.parko.textSecondary),
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
