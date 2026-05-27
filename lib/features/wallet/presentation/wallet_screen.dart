import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../application/wallet_providers.dart';
import '../domain/wallet_models.dart';
import 'widgets/wallet_custom_top_up_dialog.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(walletSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: context.parko.textPrimary,
        ),
        title: Text(l10n.walletTitle),
      ),
      body: RefreshIndicator(
        color: ParkoColors.sky,
        onRefresh: () async {
          ref.invalidate(walletSummaryProvider);
          await ref.read(walletSummaryProvider.future);
        },
        child: async.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 120),
              Center(child: CircularProgressIndicator()),
            ],
          ),
          error: (e, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 120),
              Center(child: Text('$e')),
            ],
          ),
          data: (summary) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
            _BalanceCard(balance: summary.balanceKwd),
            const SizedBox(height: 16),
            Text(l10n.walletTopUpTitle, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                _TopUpChip(amount: 5, onTap: () => _topUp(context, ref, 5)),
                const SizedBox(width: 8),
                _TopUpChip(amount: 10, onTap: () => _topUp(context, ref, 10)),
                const SizedBox(width: 8),
                _TopUpChip(amount: 20, onTap: () => _topUp(context, ref, 20)),
                const SizedBox(width: 8),
                _TopUpChip(
                  label: '···',
                  onTap: () async {
                    final amount = await showWalletCustomTopUpDialog(context);
                    if (amount == null || !context.mounted) return;
                    await _topUp(context, ref, amount);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.walletTopUpHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.credit_card_rounded, size: 18, color: ParkoColors.sky),
                  label: Text(l10n.walletKnet),
                ),
                Chip(
                  avatar: const Icon(Icons.payment_rounded, size: 18, color: ParkoColors.green),
                  label: Text(l10n.walletTap),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(l10n.walletHistory, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            if (summary.transactions.isEmpty)
              Text(l10n.walletEmptyHistory)
            else
              ...summary.transactions.map((t) => _TxTile(tx: t)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _topUp(BuildContext context, WidgetRef ref, double amount) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(walletControllerProvider).topUp(amount);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.walletTopUpSuccess(amount.toStringAsFixed(0)))),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ParkoColors.gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.walletBalanceLabel, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            l10n.walletBalanceAmount(balance.toStringAsFixed(3)),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: context.parko.panel,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _TopUpChip extends StatelessWidget {
  const _TopUpChip({this.amount, this.label, required this.onTap});

  final double? amount;
  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = label ?? l10n.walletTopUpAmount(amount!.toStringAsFixed(0));
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
        child: Text(text),
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  const _TxTile({required this.tx});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final fmt = DateFormat.MMMd(locale).add_Hm();
    final sign = tx.isCredit ? '+' : '';
    final color = tx.isCredit ? ParkoColors.green : ParkoColors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          tx.isCredit ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
          color: color,
        ),
        title: Text(tx.description ?? tx.type),
        subtitle: Text(fmt.format(tx.createdAt)),
        trailing: Text(
          '$sign${tx.amountKwd.abs().toStringAsFixed(3)} KWD',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
