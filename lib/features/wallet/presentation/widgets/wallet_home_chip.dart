import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/wallet_providers.dart';

class WalletHomeChip extends ConsumerWidget {
  const WalletHomeChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final balance = ref.watch(walletBalanceProvider);

    return balance.when(
      loading: () => const SizedBox(width: 44, height: 44),
      error: (_, __) => const SizedBox.shrink(),
      data: (b) => Material(
        color: ParkoColors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push(AppRoute.wallet.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: ParkoColors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  l10n.walletHomeChip(b.toStringAsFixed(1)),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
