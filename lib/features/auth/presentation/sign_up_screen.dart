import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../application/auth_providers.dart';

/// Phone-first registration: saves profile draft, then OTP on auth screen.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController(text: '+965 ');
  final _email = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final first = _first.text.trim();
    final last = _last.text.trim();
    final phone = _phone.text.trim();
    final email = _email.text.trim();

    if (first.isEmpty || last.isEmpty || phone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.fillAllFields)));
      return;
    }

    await ref.read(authControllerProvider).savePendingSignup(
          displayName: '$first $last',
          phone: phone,
          email: email.isEmpty ? null : email,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.signUpContinueOtp)));
    context.go(AppRoute.auth.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
          color: context.parko.textPrimary,
        ),
        title: Text(l10n.signUpTitle, style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              l10n.signUpPhoneSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _first,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: l10n.firstNameHint),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _last,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: l10n.lastNameHint),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: l10n.phoneHint,
                prefixIcon: const Icon(Icons.phone_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: l10n.emailHintOptional,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(label: l10n.signUpVerifyPhone, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
