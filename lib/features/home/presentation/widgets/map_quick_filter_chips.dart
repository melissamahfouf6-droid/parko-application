import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_filters.dart';

class MapQuickFilterChips extends ConsumerWidget {
  const MapQuickFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(mapQuickFilterProvider);

    final options = <(MapQuickFilter, String, IconData)>[
      (MapQuickFilter.all, l10n.filterQuickAll, Icons.map_rounded),
      (MapQuickFilter.free, l10n.filterQuickFree, Icons.money_off_rounded),
      (MapQuickFilter.valet, l10n.filterQuickValet, Icons.key_rounded),
      (MapQuickFilter.reservable, l10n.filterQuickReserve, Icons.event_available_rounded),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (filter, label, icon) = options[i];
          final active = selected == filter;
          return FilterChip(
            label: Text(label),
            avatar: Icon(icon, size: 18, color: active ? Colors.white : ParkoColors.sky),
            selected: active,
            onSelected: (_) => ref.read(mapQuickFilterProvider.notifier).state = filter,
            selectedColor: ParkoColors.sky,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : context.parko.textPrimary,
            ),
            backgroundColor: context.parko.panel,
            side: BorderSide(color: active ? ParkoColors.sky : context.parko.border),
          );
        },
      ),
    );
  }
}
