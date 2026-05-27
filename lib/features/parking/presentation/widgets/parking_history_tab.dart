import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_history_filter_providers.dart';
import '../../application/parking_history_providers.dart';
import 'history_detail_sheet.dart';

class ParkingHistoryTab extends ConsumerWidget {
  const ParkingHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(parkingHistoryProvider);
    final filter = ref.watch(parkingHistoryFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              _Chip(
                label: l10n.historyFilterAll,
                selected: filter == ParkingHistoryFilter.all,
                onTap: () => ref.read(parkingHistoryFilterProvider.notifier).state = ParkingHistoryFilter.all,
              ),
              _Chip(
                label: l10n.historyFilterSessions,
                selected: filter == ParkingHistoryFilter.sessions,
                onTap: () => ref.read(parkingHistoryFilterProvider.notifier).state = ParkingHistoryFilter.sessions,
              ),
              _Chip(
                label: l10n.historyFilterReservations,
                selected: filter == ParkingHistoryFilter.reservations,
                onTap: () => ref.read(parkingHistoryFilterProvider.notifier).state = ParkingHistoryFilter.reservations,
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: ParkoColors.sky,
            onRefresh: () async {
              ref.invalidate(parkingHistoryProvider);
              await ref.read(parkingHistoryProvider.future);
            },
            child: async.when(
              loading: () => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
              error: (e, _) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  Center(child: Text('$e')),
                ],
              ),
              data: (items) {
                final filtered = filterParkingHistory(items, filter);
                if (filtered.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
                      Center(child: Text(l10n.emptyHistory)),
                    ],
                  );
                }
                final locale = Localizations.localeOf(context).languageCode;
                final fmt = DateFormat.MMMd(locale).add_y();
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    final icon = item.source == 'reservation'
                        ? Icons.event_available_rounded
                        : Icons.local_parking_rounded;
                    return Card(
                      child: ListTile(
                        leading: Icon(icon, color: ParkoColors.sky),
                        title: Text(item.lotName, style: Theme.of(context).textTheme.titleSmall),
                        subtitle: Text('${fmt.format(item.startedAt)} • ${item.durationLabel}'),
                        trailing: Text(
                          '${item.paidKwd.toStringAsFixed(2)} KWD',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: ParkoColors.green),
                        ),
                        onTap: () => HistoryDetailSheet.show(context, item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: ParkoColors.sky.withOpacity(0.2),
        checkmarkColor: ParkoColors.sky,
      ),
    );
  }
}
