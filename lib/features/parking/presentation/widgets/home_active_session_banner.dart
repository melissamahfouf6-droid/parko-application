import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/parking_session_providers.dart';
import 'session_receipt_sheet.dart';

/// Ticks every 30s so remaining time on the home banner stays fresh.
final activeSessionClockProvider = StreamProvider.autoDispose<int>((ref) {
  ref.watch(activeParkingSessionProvider);
  return Stream.periodic(const Duration(seconds: 30), (i) => i);
});

class HomeActiveSessionBanner extends ConsumerStatefulWidget {
  const HomeActiveSessionBanner({super.key});

  @override
  ConsumerState<HomeActiveSessionBanner> createState() => _HomeActiveSessionBannerState();
}

class _HomeActiveSessionBannerState extends ConsumerState<HomeActiveSessionBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(activeSessionClockProvider);
    final session = ref.watch(activeParkingSessionProvider);
    if (session == null || session.isExpired) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final h = session.remainingMinutes ~/ 60;
    final m = session.remainingMinutes % 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: ParkoColors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push(AppRoute.myParking.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.local_parking_rounded, color: ParkoColors.green, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeActiveSession(session.lotName),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        l10n.shareTimeLeft(h, m),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  tooltip: l10n.sessionExtend30,
                  icon: const Icon(Icons.more_time_rounded, color: ParkoColors.green, size: 22),
                  onPressed: () {
                    ref.read(shareParkingControllerProvider).extendSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.sessionExtended(30))),
                    );
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  tooltip: l10n.shareEndSession,
                  icon: Icon(Icons.close_rounded, color: context.parko.textSecondary, size: 22),
                  onPressed: () async {
                    final ended = await ref.read(shareParkingControllerProvider).endSession();
                    if (!context.mounted || ended == null) return;
                    await SessionReceiptSheet.show(context, ended);
                  },
                ),
                Icon(Icons.chevron_right_rounded, color: context.parko.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
