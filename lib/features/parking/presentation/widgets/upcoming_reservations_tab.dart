import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../../../core/maps/open_maps.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/application/home_providers.dart';
import '../../../reservations/application/reservation_providers.dart';
import '../../../reservations/domain/parking_reservation.dart';

class UpcomingReservationsTab extends ConsumerWidget {
  const UpcomingReservationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(upcomingReservationsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy_rounded, size: 64, color: context.parko.border),
                  const SizedBox(height: 16),
                  Text(l10n.emptyUpcoming, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 260,
                    child: GradientButton(
                      label: l10n.reserveSpot,
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final locale = Localizations.localeOf(context).languageCode;
        final fmt = DateFormat.MMMd(locale).add_jm();
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _ReservationCard(reservation: list[i], dateFmt: fmt),
        );
      },
    );
  }
}

class _ReservationCard extends ConsumerWidget {
  const _ReservationCard({required this.reservation, required this.dateFmt});

  final ParkingReservation reservation;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hours = reservation.duration.inHours;
    final mins = reservation.duration.inMinutes % 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_available_rounded, color: ParkoColors.sky, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.lotName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${dateFmt.format(reservation.startAt)} • ${hours}h ${mins}m',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (reservation.zoneLabel != null)
                        Text(
                          reservation.zoneLabel!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ParkoColors.sky),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${reservation.priceKwd.toStringAsFixed(2)} KWD',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: ParkoColors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map_rounded, size: 18),
                    label: Text(l10n.historyShowOnMap),
                    onPressed: () {
                      ref.read(mapFocusLotIdProvider.notifier).state = reservation.lotId;
                      ref.read(selectedParkingLotIdProvider.notifier).state = reservation.lotId;
                      context.go(AppRoute.home.path);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.navigation_rounded, size: 18),
                    label: Text(l10n.navigateToParking),
                    onPressed: () async {
                      final lat = reservation.lat;
                      final lng = reservation.lng;
                      if (lat == null || lng == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.reserveNavigateHint(reservation.lotName))),
                        );
                        return;
                      }
                      final ok = await openMapsNavigation(
                        lat: lat,
                        lng: lng,
                        label: reservation.lotName,
                      );
                      if (!context.mounted || ok) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.mapsOpenFailed)),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                    onPressed: () async {
                      final willRefund = reservation.eligibleForWalletRefund;
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.reserveCancel),
                          content: Text(
                            willRefund
                                ? l10n.reserveCancelConfirmRefund(reservation.priceKwd.toStringAsFixed(2))
                                : l10n.reserveCancelConfirmNoRefund,
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.back)),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(l10n.reserveCancel, style: const TextStyle(color: ParkoColors.red)),
                            ),
                          ],
                        ),
                      );
                      if (ok != true || !context.mounted) return;
                      final refund = await ref.read(reservationControllerProvider).cancel(reservation.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            refund > 0
                                ? l10n.reserveCancelledRefund(refund.toStringAsFixed(2))
                                : willRefund
                                    ? l10n.reserveCancelled
                                    : l10n.reserveCancelledNoRefund,
                          ),
                        ),
                      );
                    },
                child: Text(l10n.reserveCancel, style: const TextStyle(color: ParkoColors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
