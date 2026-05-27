import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/application/home_providers.dart';
import '../../domain/parking_history_item.dart';

class HistoryDetailSheet extends ConsumerWidget {
  const HistoryDetailSheet({super.key, required this.item});

  final ParkingHistoryItem item;

  static void show(BuildContext context, ParkingHistoryItem item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => HistoryDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fmt = DateFormat.yMMMd(locale).add_jm();

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.parko.background,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(item.lotName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            item.source == 'reservation' ? l10n.historyTypeReservation : l10n.historyTypeSession,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
          ),
          const SizedBox(height: 14),
          _Row(label: l10n.receiptPaid, value: '${item.paidKwd.toStringAsFixed(2)} KWD'),
          _Row(label: l10n.receiptDuration, value: item.durationLabel),
          _Row(label: l10n.historyWhen, value: fmt.format(item.startedAt)),
          if (item.lotId != null) ...[
            const SizedBox(height: 16),
            GradientButton(
              label: l10n.historyShowOnMap,
              icon: Icons.map_rounded,
              onPressed: () {
                ref.read(mapFocusLotIdProvider.notifier).state = item.lotId;
                ref.read(selectedParkingLotIdProvider.notifier).state = item.lotId;
                Navigator.of(context).pop();
                context.go(AppRoute.home.path);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary)),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
