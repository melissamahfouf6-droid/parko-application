import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/reservation_providers.dart';

class HomeReservationBanner extends ConsumerWidget {
  const HomeReservationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = ref.watch(nextReservationProvider);
    if (next == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final until = next.startAt.difference(DateTime.now());
    final hours = until.inHours;
    final mins = until.inMinutes % 60;
    final timeLabel = hours > 0 ? l10n.reserveStartsInHours(hours, mins) : l10n.reserveStartsInMins(mins);
    final timeFmt = DateFormat.jm(locale).format(next.startAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: ParkoColors.sky.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push(AppRoute.myParking.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.event_available_rounded, color: ParkoColors.sky, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeNextReservation(next.lotName),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$timeLabel • $timeFmt',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
                      ),
                    ],
                  ),
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
