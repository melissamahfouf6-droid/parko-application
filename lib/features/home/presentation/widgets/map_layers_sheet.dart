import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/map_layers_providers.dart';

class MapLayersSheet extends ConsumerStatefulWidget {
  const MapLayersSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MapLayersSheet(),
    );
  }

  @override
  ConsumerState<MapLayersSheet> createState() => _MapLayersSheetState();
}

class _MapLayersSheetState extends ConsumerState<MapLayersSheet> {
  late bool _shared;
  late bool _private;
  late ParkoMapDisplayType _display;

  @override
  void initState() {
    super.initState();
    final s = ref.read(mapLayerSettingsProvider);
    _shared = s.showSharedSpots;
    _private = s.showPrivateSpots;
    _display = s.displayType;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: context.parko.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.paddingOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: 14),
          Text(l10n.mapLayersTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Text(l10n.mapLayersOverlays, style: Theme.of(context).textTheme.titleSmall),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.mapLayersSharedSpots),
            value: _shared,
            activeColor: ParkoColors.sky,
            onChanged: (v) => setState(() => _shared = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.mapLayersPrivateSpots),
            value: _private,
            activeColor: ParkoColors.sky,
            onChanged: (v) => setState(() => _private = v),
          ),
          const SizedBox(height: 8),
          Text(l10n.mapLayersStyle, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<ParkoMapDisplayType>(
            segments: [
              ButtonSegment(
                value: ParkoMapDisplayType.normal,
                label: Text(l10n.mapLayersNormal),
                icon: const Icon(Icons.map_rounded, size: 18),
              ),
              ButtonSegment(
                value: ParkoMapDisplayType.satellite,
                label: Text(l10n.mapLayersSatellite),
                icon: const Icon(Icons.satellite_alt_rounded, size: 18),
              ),
            ],
            selected: {_display},
            onSelectionChanged: (s) => setState(() => _display = s.first),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: l10n.applyFilters,
            onPressed: () {
              ref.read(mapLayerSettingsProvider.notifier).state = MapLayerSettings(
                showSharedSpots: _shared,
                showPrivateSpots: _private,
                displayType: _display,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
