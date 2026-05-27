import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/application/app_session_providers.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../wallet/application/wallet_providers.dart';
import '../application/auth_providers.dart';
class PhoneOtpPanel extends ConsumerStatefulWidget {
  const PhoneOtpPanel({super.key, required this.phoneController});

  final TextEditingController phoneController;

  @override
  ConsumerState<PhoneOtpPanel> createState() => _PhoneOtpPanelState();
}

class _PhoneOtpPanelState extends ConsumerState<PhoneOtpPanel> {
  final _codeCtrl = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).sendOtp(widget.phoneController.text.trim());
      if (!mounted) return;
      setState(() => _codeSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.authOtpSent)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final result = await ref.read(authRepositoryProvider).verifyOtp(
            phone: widget.phoneController.text.trim(),
            code: _codeCtrl.text.trim(),
          );
      await ref.read(authControllerProvider).persistSession(result);
      await ref.read(authControllerProvider).applyPendingProfileIfAny();
      await ref.read(appSessionProvider).markSignedIn();
      if (result.welcomeBonus) {
        ref.invalidate(walletSummaryProvider);
        await ref.read(loyaltyControllerProvider.notifier).refresh();
      }
      if (!mounted) return;
      if (result.welcomeBonus) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.authWelcomeBonus(
                result.welcomeWalletKwd.toStringAsFixed(0),
                result.welcomePoints,
              ),
            ),
          ),
        );
      }
      context.go(AppRoute.home.path);
    } catch (e) {
      if (!mounted) return;
      final msg = _otpErrorMessage(e, l10n);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _otpErrorMessage(Object e, AppLocalizations l10n) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] is String) {
        final m = data['message'] as String;
        if (m.contains('otp_invalid')) return l10n.authOtpInvalid;
        if (m.contains('otp_expired')) return l10n.authOtpExpired;
      }
    }
    if (e.toString().contains('otp_invalid')) return l10n.authOtpInvalid;
    return l10n.authOtpInvalid;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: widget.phoneController,
          enabled: !_codeSent && !_busy,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: l10n.phoneHint,
            prefixIcon: Icon(Icons.phone_rounded),
          ),
        ),
        if (_codeSent) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _codeCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: l10n.authOtpHint,
              prefixIcon: const Icon(Icons.pin_rounded),
              counterText: '',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.authDemoCodeHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
          ),
        ],
        const SizedBox(height: 12),
        GradientButton(
          label: _codeSent ? l10n.authOtpVerify : l10n.sendCode,
          onPressed: _busy ? null : (_codeSent ? _verify : _sendCode),
          icon: _codeSent ? Icons.verified_rounded : Icons.sms_rounded,
          isLoading: _busy,
        ),
        if (_codeSent) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy
                ? null
                : () => setState(() {
                      _codeSent = false;
                      _codeCtrl.clear();
                    }),
            child: Text(l10n.authChangePhone),
          ),
        ],
      ],
    );
  }
}
