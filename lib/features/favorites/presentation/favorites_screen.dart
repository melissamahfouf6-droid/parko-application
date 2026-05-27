import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../application/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(savedLotsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
          color: context.parko.textPrimary,
        ),
        title: Text(l10n.favoritesTitle),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.favoritesEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.parko.textSecondary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final lot = list[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.star_rounded, color: ParkoColors.amber),
                  title: Text(lot.lotName, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(l10n.favoritesSavedOn(_formatDate(context, lot.savedAt))),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: ParkoColors.red),
                    onPressed: () async {
                      await ref.read(favoritesRepositoryProvider).remove(lot.lotId);
                      ref.invalidate(savedLotsProvider);
                    },
                  ),
                  onTap: () {
                    ref.read(favoritesControllerProvider).openOnMap(lot);
                    context.go(AppRoute.home.path);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime dt) {
    return MaterialLocalizations.of(context).formatShortDate(dt);
  }
}
