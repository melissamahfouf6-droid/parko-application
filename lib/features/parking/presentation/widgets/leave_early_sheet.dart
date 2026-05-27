import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_session_providers.dart';
import '../../domain/parking_session.dart';

class LeaveEarlySheet extends ConsumerWidget {
  const LeaveEarlySheet({super.key, required this.session});

  final ParkingSession session;

  static Future<void> show(BuildContext context, ParkingSession session) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LeaveEarlySheet(session: session),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final salePrice = (session.paidKwd * 0.8 * 100).round() / 100;
    final refund = (session.paidKwd * 0.7 * 100).round() / 100;
    final h = session.remainingMinutes ~/ 60;
    final m = session.remainingMinutes % 60;

    return Container(
      decoration: BoxDecoration(
        color: context.parko.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(color: context.parko.border, borderRadius: BorderRadius.circular(99)),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.shareLeaveEarlyTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(l10n.shareLeaveEarlyBody, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          _Row(label: l10n.shareActiveSession(session.lotName), value: l10n.shareTimeLeft(h, m)),
          _Row(label: 'Buyer pays', value: '$salePrice KWD'),
          _Row(label: 'Your refund (70%)', value: '$refund KWD', highlight: true),
          const SizedBox(height: 20),
          GradientButton(
            label: l10n.shareConfirmList,
            icon: Icons.sell_rounded,
            onPressed: () async {
              try {
                final r = await ref.read(shareParkingControllerProvider).leaveEarly();
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.shareListedSuccess(r.sellerRefundKwd.toStringAsFixed(2)))),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.highlight = false});
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: highlight ? ParkoColors.green : context.parko.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
