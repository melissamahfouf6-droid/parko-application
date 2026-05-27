import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/maps/open_maps.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/parking_session.dart';

class SessionReceiptSheet extends StatelessWidget {
  const SessionReceiptSheet({super.key, required this.session});

  final ParkingSession session;

  static Future<void> show(BuildContext context, ParkingSession session) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SessionReceiptSheet(session: session),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final used = session.durationMinutes - session.remainingMinutes;
    final h = used ~/ 60;
    final m = used % 60;
    final points = session.paidKwd.round().clamp(0, 100000);

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
          Text(
            l10n.receiptTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(session.lotName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ParkoColors.sky)),
          const SizedBox(height: 16),
          _Row(label: l10n.receiptDuration, value: l10n.shareTimeLeft(h, m)),
          _Row(label: l10n.receiptPaid, value: '${session.paidKwd.toStringAsFixed(2)} KWD'),
          if (points > 0)
            _Row(label: l10n.receiptPoints, value: l10n.receiptPointsEarned(points)),
          const SizedBox(height: 20),
          GradientButton(
            label: l10n.navigateToParking,
            icon: Icons.navigation_rounded,
            onPressed: () async {
              await openMapsNavigation(lat: session.lat, lng: session.lng, label: session.lotName);
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(AppRoute.myParking.path);
            },
            child: Text(l10n.receiptViewHistory),
          ),
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
