import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Returns chosen KWD amount or null if cancelled.
Future<double?> showWalletCustomTopUpDialog(BuildContext context) {
  return showDialog<double>(
    context: context,
    builder: (ctx) => const _WalletCustomTopUpDialog(),
  );
}

class _WalletCustomTopUpDialog extends StatefulWidget {
  const _WalletCustomTopUpDialog();

  @override
  State<_WalletCustomTopUpDialog> createState() => _WalletCustomTopUpDialogState();
}

class _WalletCustomTopUpDialogState extends State<_WalletCustomTopUpDialog> {
  final _amount = TextEditingController(text: '15');

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    final v = double.tryParse(_amount.text.replaceAll(',', '.').trim());
    if (v == null || v < 1 || v > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).walletTopUpInvalid)),
      );
      return;
    }
    Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.walletTopUpCustomTitle),
      content: TextField(
        controller: _amount,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.walletTopUpCustomLabel,
          suffixText: 'KWD',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.back)),
        FilledButton(onPressed: _submit, child: Text(l10n.walletTopUpConfirm)),
      ],
    );
  }
}
