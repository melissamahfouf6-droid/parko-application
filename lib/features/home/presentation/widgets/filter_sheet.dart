import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_filters.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late bool _availableNow;
  late bool _reservableAhead;
  late bool _showFullLots;

  @override
  void initState() {
    super.initState();
    final f = ref.read(parkingMapFiltersProvider);
    _availableNow = f.availableNow;
    _reservableAhead = f.reservableAhead;
    _showFullLots = f.showFullLots;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SheetScaffold(
      title: l10n.filterTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ToggleRow(
            title: l10n.availableNow,
            value: _availableNow,
            onChanged: (v) => setState(() => _availableNow = v),
          ),
          _ToggleRow(
            title: l10n.reservableAhead,
            value: _reservableAhead,
            onChanged: (v) => setState(() => _reservableAhead = v),
          ),
          _ToggleRow(
            title: l10n.showFullLots,
            value: _showFullLots,
            onChanged: (v) => setState(() => _showFullLots = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _availableNow = true;
                    _reservableAhead = false;
                    _showFullLots = false;
                  }),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(l10n.resetFilters),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  label: l10n.applyFilters,
                  onPressed: () {
                    ref.read(parkingMapFiltersProvider.notifier).state = ParkingMapFilters(
                      availableNow: _availableNow,
                      reservableAhead: _reservableAhead,
                      showFullLots: _showFullLots,
                    );
                    Navigator.of(context).pop();
                    final count = ref.read(filteredLotCountProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.filterApplied(count))),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.parko.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.parko.border),
      ),
      child: SwitchListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleSmall),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.25,
      maxChildSize: 0.92,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          color: context.parko.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: context.parko.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
