import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../buddies/application/buddies_providers.dart';
import '../../buddies/presentation/widgets/parking_buddies_sheet.dart';
import '../../home/application/home_providers.dart';
import '../../home/application/map_location_providers.dart';
import '../../home/domain/parking_lot.dart';
import '../data/destination_lots.dart';
import '../data/search_history_store.dart';

class SearchDestination {
  const SearchDestination({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
}

/// Mock Kuwait destinations (Places API later).
const _kKuwaitDestinations = <SearchDestination>[
  SearchDestination(title: 'The Avenues Mall', subtitle: 'Rai • Major retail'),
  SearchDestination(title: '360 Mall', subtitle: 'South Surra'),
  SearchDestination(title: 'Kuwait International Airport', subtitle: 'Farwaniya'),
  SearchDestination(title: 'Souq Al-Mubarakiya', subtitle: 'Kuwait City'),
  SearchDestination(title: 'Dasman Diabetes Institute', subtitle: 'Sharq'),
  SearchDestination(title: 'Kuwait University (Shadadiya)', subtitle: 'Education'),
  SearchDestination(title: 'Marina Mall', subtitle: 'Salmiya • waterfront'),
];

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  List<SearchDestination> _filtered = _kKuwaitDestinations;
  List<ParkingLot> _lotMatches = [];
  List<String> _recent = [];

  @override
  void initState() {
    super.initState();
    _recent = ref.read(searchHistoryStoreProvider).load();
    _controller.addListener(_onQuery);
    _onQuery();
  }

  @override
  void dispose() {
    _controller.removeListener(_onQuery);
    _controller.dispose();
    super.dispose();
  }

  void _onQuery() {
    if (!mounted) return;
    final q = _controller.text.trim().toLowerCase();
    final lots = ref.read(nearbyLotsProvider).valueOrNull ?? [];
    setState(() {
      if (q.isEmpty) {
        _filtered = _kKuwaitDestinations;
        _lotMatches = [];
      } else {
        _filtered = _kKuwaitDestinations
            .where((d) => d.title.toLowerCase().contains(q) || d.subtitle.toLowerCase().contains(q))
            .toList();
        _lotMatches = lots.where((l) => l.name.toLowerCase().contains(q)).toList();
      }
    });
  }

  Future<void> _selectDestination(BuildContext context, String title) async {
    ref.read(selectedDestinationProvider.notifier).state = title;
    await ref.read(searchHistoryStoreProvider).add(title);
    final lotId = lotIdForDestination(title);
    if (lotId != null) {
      ref.read(mapFocusLotIdProvider.notifier).state = lotId;
    }
    if (!context.mounted) return;
    context.pop(title);
  }

  Future<void> _selectLot(BuildContext context, ParkingLot lot) async {
    await ref.read(searchHistoryStoreProvider).add(lot.name);
    ref.read(mapFocusLotIdProvider.notifier).state = lot.id;
    ref.read(selectedParkingLotIdProvider.notifier).state = lot.id;
    if (!context.mounted) return;
    context.pop(lot.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.watch(nearbyLotsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
          color: context.parko.textPrimary,
        ),
        title: Text(l10n.searchTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ListTile(
              leading: const Icon(Icons.my_location_rounded, color: ParkoColors.green),
              title: Text(l10n.searchNearMe),
              subtitle: Text(l10n.searchNearMeHint),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: context.parko.border),
              ),
              onTap: () async {
                final ok = await ref.read(mapLocationControllerProvider).centerOnUser();
                if (!context.mounted) return;
                if (ok) {
                  context.pop(l10n.searchNearMe);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.locationUnavailable)),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => _controller.clear(),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_controller.text.isEmpty && _recent.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.searchRecentTitle,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ref.read(searchHistoryStoreProvider).clear();
                            if (!mounted) return;
                            setState(() => _recent = []);
                          },
                          child: Text(l10n.searchRecentClear),
                        ),
                      ],
                    ),
                  ),
                  ..._recent.map(
                    (title) => ListTile(
                      leading: const Icon(Icons.history_rounded, color: ParkoColors.gray),
                      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
                      onTap: () => _selectDestination(context, title),
                    ),
                  ),
                  const Divider(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(l10n.searchPopularTitle, style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
                if (_lotMatches.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(l10n.searchLotsTitle, style: Theme.of(context).textTheme.titleSmall),
                  ),
                  ..._lotMatches.map((lot) {
                    final ratio = lot.availabilityRatio;
                    final spots = '${lot.availableSpots}/${lot.totalSpots}';
                    return ListTile(
                      leading: Icon(
                        Icons.local_parking_rounded,
                        color: ratio <= 0.1
                            ? ParkoColors.red
                            : ratio <= 0.3
                                ? ParkoColors.amber
                                : ParkoColors.green,
                      ),
                      title: Text(lot.name, style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text(
                        l10n.searchLotSubtitle(
                          spots,
                          lot.priceKwdPerHour == 0
                              ? l10n.filterQuickFree
                              : '${lot.priceKwdPerHour.toStringAsFixed(1)} KWD/hr',
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _selectLot(context, lot),
                    );
                  }),
                  if (_filtered.isNotEmpty) const Divider(height: 16),
                ],
                if (_filtered.isEmpty && _lotMatches.isEmpty && _controller.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text(l10n.searchNoResults)),
                  ),
                ...List.generate(_filtered.length, (i) {
                  final d = _filtered[i];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (i > 0) const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.place_outlined, color: ParkoColors.sky),
                        title: Text(d.title, style: Theme.of(context).textTheme.titleSmall),
                        subtitle: Text(d.subtitle, style: Theme.of(context).textTheme.bodySmall),
                        trailing: IconButton(
                          icon: const Icon(Icons.groups_rounded, color: ParkoColors.sky),
                          tooltip: l10n.buddySearchAction,
                          onPressed: () {
                            ref.read(selectedDestinationProvider.notifier).state = d.title;
                            ParkingBuddiesSheet.show(context, d.title);
                          },
                        ),
                        onTap: () => _selectDestination(context, d.title),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
