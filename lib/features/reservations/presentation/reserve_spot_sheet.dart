import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/domain/parking_lot.dart';
import '../../settings/application/settings_providers.dart';
import '../../wallet/application/wallet_providers.dart';
import '../application/reservation_providers.dart';

enum _ReserveWhen { today, tomorrow }

enum _ReserveDuration { h1, h2, h3, allDay }

class ReserveSpotSheet extends ConsumerStatefulWidget {
  const ReserveSpotSheet({super.key, required this.lot});

  final ParkingLot lot;

  static Future<void> show(BuildContext context, ParkingLot lot) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReserveSpotSheet(lot: lot),
    );
  }

  @override
  ConsumerState<ReserveSpotSheet> createState() => _ReserveSpotSheetState();
}

class _ReserveSpotSheetState extends ConsumerState<ReserveSpotSheet> {
  _ReserveWhen _when = _ReserveWhen.today;
  _ReserveDuration _duration = _ReserveDuration.h2;
  final _zoneController = TextEditingController();
  bool _submitting = false;
  bool _payFromWallet = true;

  @override
  void dispose() {
    _zoneController.dispose();
    super.dispose();
  }

  int _hours() {
    switch (_duration) {
      case _ReserveDuration.h1:
        return 1;
      case _ReserveDuration.h2:
        return 2;
      case _ReserveDuration.h3:
        return 3;
      case _ReserveDuration.allDay:
        return 8;
    }
  }

  DateTime _startAt() {
    final now = DateTime.now();
    final base = _when == _ReserveWhen.today
        ? DateTime(now.year, now.month, now.day, now.hour + 1)
        : DateTime(now.year, now.month, now.day + 1, 10);
    return base;
  }

  double _priceKwd() {
    final rate = widget.lot.priceKwdPerHour;
    if (rate <= 0) return 0;
    return ((_hours() * rate) * 100).round() / 100;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final start = _startAt();
    final end = start.add(Duration(hours: _hours()));
    final dateFmt = DateFormat.MMMd(locale).add_jm();
    final price = _priceKwd();
    final balance = ref.watch(walletBalanceProvider);
    final canPayFromWallet = price <= 0 ||
        balance.when(
          data: (b) => !_payFromWallet || b >= price,
          loading: () => false,
          error: (_, __) => true,
        );

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scroll) {
        return Container(
          decoration: BoxDecoration(
            color: context.parko.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: context.parko.border, borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.reserveTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(widget.lot.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ParkoColors.sky)),
              const SizedBox(height: 20),
              Text(l10n.reserveWhen, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              SegmentedButton<_ReserveWhen>(
                segments: [
                  ButtonSegment(value: _ReserveWhen.today, label: Text(l10n.reserveToday)),
                  ButtonSegment(value: _ReserveWhen.tomorrow, label: Text(l10n.reserveTomorrow)),
                ],
                selected: {_when},
                onSelectionChanged: (s) => setState(() => _when = s.first),
              ),
              const SizedBox(height: 16),
              Text(l10n.reserveDuration, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _DurationChip(
                    label: l10n.reserveDuration1h,
                    selected: _duration == _ReserveDuration.h1,
                    onTap: () => setState(() => _duration = _ReserveDuration.h1),
                  ),
                  _DurationChip(
                    label: l10n.reserveDuration2h,
                    selected: _duration == _ReserveDuration.h2,
                    onTap: () => setState(() => _duration = _ReserveDuration.h2),
                  ),
                  _DurationChip(
                    label: l10n.reserveDuration3h,
                    selected: _duration == _ReserveDuration.h3,
                    onTap: () => setState(() => _duration = _ReserveDuration.h3),
                  ),
                  _DurationChip(
                    label: l10n.reserveDurationAllDay,
                    selected: _duration == _ReserveDuration.allDay,
                    onTap: () => setState(() => _duration = _ReserveDuration.allDay),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _zoneController,
                decoration: InputDecoration(
                  labelText: l10n.reserveZoneHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: ParkoColors.sky.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ParkoColors.sky.withOpacity(0.25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateFmt.format(start), style: Theme.of(context).textTheme.bodyMedium),
                      Text('→ ${dateFmt.format(end)}', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Text(
                        l10n.reserveTotal(price.toStringAsFixed(2)),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: ParkoColors.green,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              if (price > 0) ...[
                const SizedBox(height: 12),
                balance.when(
                  data: (b) => Text(
                    l10n.reserveWalletBalance(b.toStringAsFixed(2)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.reservePayFromWallet),
                  subtitle: Text(l10n.reservePayFromWalletHint),
                  value: _payFromWallet,
                  activeColor: ParkoColors.sky,
                  onChanged: (v) => setState(() => _payFromWallet = v),
                ),
                if (_payFromWallet && !canPayFromWallet)
                  Text(
                    l10n.walletInsufficient,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ParkoColors.red),
                  ),
              ],
              const SizedBox(height: 20),
              GradientButton(
                label: l10n.reserveConfirm,
                icon: Icons.event_available_rounded,
                isLoading: _submitting,
                onPressed: _submitting || !canPayFromWallet
                    ? null
                    : () async {
                        setState(() => _submitting = true);
                        try {
                          await ref.read(reservationControllerProvider).reserve(
                                lotId: widget.lot.id,
                                lotName: widget.lot.name,
                                lat: widget.lot.lat,
                                lng: widget.lot.lng,
                                startAt: start,
                                endAt: end,
                                priceKwd: price,
                                zoneLabel: _zoneController.text.trim().isEmpty
                                    ? null
                                    : _zoneController.text.trim(),
                                payFromWallet: price > 0 && _payFromWallet,
                              );
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          final reminders = ref.read(userSettingsProvider).parkingReminders;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                reminders ? '${l10n.reserveSuccess} · ${l10n.reminderScheduled}' : l10n.reserveSuccess,
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$e')),
                          );
                        } finally {
                          if (mounted) setState(() => _submitting = false);
                        }
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: ParkoColors.sky.withOpacity(0.2),
      checkmarkColor: ParkoColors.sky,
    );
  }
}
