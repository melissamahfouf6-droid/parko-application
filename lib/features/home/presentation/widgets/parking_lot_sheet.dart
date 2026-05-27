import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/parko_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../loyalty/domain/loyalty_points_hint.dart';
import '../../../marketplace/application/marketplace_providers.dart';
import '../../../predictions/presentation/widgets/lot_prediction_section.dart';
import '../../../reservations/presentation/reserve_spot_sheet.dart';
import '../../../wallet/presentation/pay_parking_sheet.dart';
import '../../../../core/maps/open_maps.dart';
import '../../../../core/share/share_parking_lot.dart';
import '../../application/parking_filters.dart';
import 'lot_review_section.dart';
import '../../../favorites/presentation/widgets/favorite_lot_button.dart';

class ParkingLotSheet extends ConsumerWidget {
  const ParkingLotSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lot = ref.watch(selectedLotProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.18,
      maxChildSize: 0.92,
      builder: (context, controller) {
        if (lot == null) {
          return const _SheetContainer(child: Center(child: Text('No selection')));
        }

        final ratio = lot.availabilityRatio;
        final statusColor = ratio <= 0.1
            ? ParkoColors.red
            : ratio <= 0.3
                ? ParkoColors.amber
                : ParkoColors.green;

        return _SheetContainer(
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

              // Peek view essentials
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lot.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lot.distanceKm != null
                              ? l10n.lotDistanceKm(lot.distanceKm!.toStringAsFixed(1))
                              : l10n.distanceAwayWalk('850m', 11),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
                        ),
                        if (lot.hoursLabel != null && lot.hoursLabel!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.schedule_rounded, size: 16, color: ParkoColors.gray),
                              const SizedBox(width: 4),
                              Text(
                                l10n.lotHours(lot.hoursLabel!),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  FavoriteLotButton(lot: lot),
                  IconButton(
                    tooltip: l10n.shareLot,
                    onPressed: () => shareParkingLot(context, lot),
                    icon: const Icon(Icons.ios_share_rounded, color: ParkoColors.sky),
                  ),
                  const SizedBox(width: 4),
                  _CapacityRing(
                    ratio: ratio,
                    color: statusColor,
                    label: '${lot.availableSpots}/${lot.totalSpots}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Pill(
                    text: lot.priceKwdPerHour == 0 ? 'Free' : '${lot.priceKwdPerHour.toStringAsFixed(1)} KWD/hr',
                    icon: Icons.payments_rounded,
                  ),
                  const SizedBox(width: 10),
                  _Pill(
                    text: '${lot.rating.toStringAsFixed(1)} ★ (${lot.reviewCount})',
                    icon: Icons.star_rounded,
                  ),
                  if (lot.hasValet) ...[
                    const SizedBox(width: 10),
                    const _Pill(text: 'Valet', icon: Icons.key_rounded, color: ParkoColors.purple),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ParkoColors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ParkoColors.amber.withOpacity(0.35)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: ParkoColors.amber, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.loyaltyEarnAtLot(estimatedVisitPointsHint(lot.priceKwdPerHour)),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _MarketplaceNearLotHint(),
              if (ratio <= 0.25) ...[
                const SizedBox(height: 16),
                LotPredictionSection(lotId: lot.id),
              ],
              const SizedBox(height: 16),

              // Actions
              GradientButton(
                label: l10n.navigateToParking,
                onPressed: () async {
                  final ok = await openMapsNavigation(
                    lat: lot.lat,
                    lng: lot.lng,
                    label: lot.name,
                  );
                  if (!context.mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.mapsOpenFailed)),
                    );
                  }
                },
                icon: Icons.navigation_rounded,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ReserveSpotSheet.show(context, lot);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(l10n.reserveSpot),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        PayParkingSheet.show(context, lot);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(l10n.parkPayNow),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LotReviewSection(lot: lot),
              const SizedBox(height: 16),

              Text('Amenities', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Amenity(icon: Icons.roofing_rounded, label: 'Covered'),
                  _Amenity(icon: Icons.videocam_rounded, label: 'Security'),
                  _Amenity(icon: Icons.accessible_rounded, label: 'Accessible'),
                  _Amenity(icon: Icons.ev_station_rounded, label: 'EV'),
                  _Amenity(icon: Icons.schedule_rounded, label: '24/7'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SheetContainer extends StatelessWidget {
  const _SheetContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.parko.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.icon, this.color});

  final String text;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? ParkoColors.sky;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: c),
            const SizedBox(width: 6),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketplaceNearLotHint extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(marketplaceListingsProvider);
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        final minPrice = list.map((e) => e.priceKwdPerDay).reduce((a, b) => a < b ? a : b);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: ParkoColors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ParkoColors.green.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.garage_rounded, color: ParkoColors.green, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.marketplaceNearLot(list.length, minPrice.toStringAsFixed(1)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CapacityRing extends StatelessWidget {
  const _CapacityRing({
    required this.ratio,
    required this.color,
    required this.label,
  });

  final double ratio;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: ratio.clamp(0, 1),
            strokeWidth: 6,
            backgroundColor: context.parko.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _Amenity extends StatelessWidget {
  const _Amenity({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.parko.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.parko.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: ParkoColors.gray),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

