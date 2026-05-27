import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/buddies_providers.dart';
import 'parking_buddies_sheet.dart';

class HomeBuddiesCard extends ConsumerWidget {
  const HomeBuddiesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dest = ref.watch(selectedDestinationProvider);
    if (dest == null || dest.isEmpty) return const SizedBox.shrink();

    final async = ref.watch(buddiesForDestinationProvider(dest));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (buddies) {
        if (buddies.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            color: ParkoColors.sky.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => ParkingBuddiesSheet.show(context, dest),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.groups_rounded, color: ParkoColors.sky),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.buddyCardGoing(buddies.length, dest),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
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
