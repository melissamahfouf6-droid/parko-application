import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/domain/parking_lot.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../parking/application/parking_history_providers.dart';
import '../../parking/application/parking_session_providers.dart';
import '../application/wallet_providers.dart';

class PayParkingSheet extends ConsumerStatefulWidget {
  const PayParkingSheet({super.key, required this.lot, required this.amountKwd});

  final ParkingLot lot;
  final double amountKwd;

  static Future<void> show(BuildContext context, ParkingLot lot) {
    final amount = lot.priceKwdPerHour <= 0
        ? 0.0
        : ((lot.priceKwdPerHour * 100).round() / 100);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PayParkingSheet(lot: lot, amountKwd: amount),
    );
  }

  @override
  ConsumerState<PayParkingSheet> createState() => _PayParkingSheetState();
}

class _PayParkingSheetState extends ConsumerState<PayParkingSheet> {
  bool _paying = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final balance = ref.watch(walletBalanceProvider);
    final canPay = widget.amountKwd <= 0 ||
        balance.when(
          data: (b) => b >= widget.amountKwd,
          loading: () => false,
          error: (_, __) => true,
        );

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
          Text(l10n.walletPayTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(widget.lot.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ParkoColors.sky)),
          const SizedBox(height: 16),
          balance.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Text(l10n.walletBalanceUnknown),
            data: (b) => Text(
              l10n.walletPayBalance(b.toStringAsFixed(3)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.walletPayAmount(widget.amountKwd.toStringAsFixed(2)),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ParkoColors.green,
                ),
          ),
          if (widget.amountKwd <= 0) ...[
            const SizedBox(height: 8),
            Text(l10n.walletPayFree, style: Theme.of(context).textTheme.bodySmall),
          ],
          if (!canPay && widget.amountKwd > 0) ...[
            const SizedBox(height: 10),
            Text(
              l10n.walletInsufficient,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ParkoColors.red),
            ),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoute.wallet.path);
              },
              child: Text(l10n.walletTopUpTitle),
            ),
          ],
          const SizedBox(height: 20),
          GradientButton(
            label: l10n.walletPayConfirm,
            icon: Icons.account_balance_wallet_rounded,
            isLoading: _paying,
            onPressed: _paying || !canPay
                ? null
                : () async {
                    if (widget.amountKwd <= 0) {
                      _startSession();
                      return;
                    }
                    setState(() => _paying = true);
                    try {
                      await ref.read(walletControllerProvider).payParking(
                            amountKwd: widget.amountKwd,
                            lotId: widget.lot.id,
                            lotName: widget.lot.name,
                          );
                      if (!context.mounted) return;
                      _startSession();
                    } catch (e) {
                      if (!context.mounted) return;
                      final msg = walletErrorMessage(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            msg == 'insufficient_balance'
                                ? l10n.walletInsufficient
                                : '$e',
                          ),
                        ),
                      );
                    } finally {
                      if (mounted) setState(() => _paying = false);
                    }
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _startSession() async {
    final l10n = AppLocalizations.of(context);
    ref.read(shareParkingControllerProvider).startDemoSession(
          lotId: widget.lot.id,
          lotName: widget.lot.name,
          lat: widget.lot.lat,
          lng: widget.lot.lng,
          paidKwd: widget.amountKwd > 0 ? widget.amountKwd : 3.5,
        );
    ref.invalidate(parkingHistoryProvider);
    if (widget.amountKwd > 0) {
      try {
        final earn = await ref.read(loyaltyControllerProvider.notifier).earnParking(
              widget.amountKwd,
              reference: widget.lot.id,
            );
        if (!context.mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.walletPaySuccess} · +${earn.pointsAwarded} pts'),
          ),
        );
        return;
      } catch (_) {}
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.walletPaySuccess)),
    );
  }
}
