import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../favorites/application/favorites_providers.dart';
import '../../application/home_providers.dart';

class HomeFavoritesStrip extends ConsumerWidget {
  const HomeFavoritesStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(savedLotsProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.homeFavoritesTitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push(AppRoute.favorites.path),
                    child: Text(l10n.homeFavoritesSeeAll),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final lot = list[i];
                    return ActionChip(
                      avatar: const Icon(Icons.star_rounded, size: 18, color: ParkoColors.amber),
                      label: Text(lot.lotName),
                      onPressed: () {
                        ref.read(mapFocusLotIdProvider.notifier).state = lot.lotId;
                        ref.read(selectedParkingLotIdProvider.notifier).state = lot.lotId;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
