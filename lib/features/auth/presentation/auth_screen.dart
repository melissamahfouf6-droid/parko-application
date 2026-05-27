import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../onboarding/application/app_session_providers.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/storage/preferences_bootstrap.dart';
import '../application/auth_providers.dart';
import 'phone_otp_panel.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    final pending = PreferencesBootstrap.instance.getString(kPendingSignupPhone);
    _phoneCtrl.text = pending ?? '+965 ';
  }

  @override
  void dispose() {
    _tabs.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInAndEnter(BuildContext context) async {
    await ref.read(appSessionProvider).markSignedIn();
    if (!context.mounted) return;
    context.go(AppRoute.home.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      l10n.authTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.tagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.parko.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.parko.panel,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.parko.border),
                ),
                child: TabBar(
                  controller: _tabs,
                  labelColor: ParkoColors.sky,
                  unselectedLabelColor: context.parko.textSecondary,
                  indicatorColor: ParkoColors.sky,
                  tabs: [
                    Tab(text: l10n.phoneTab),
                    Tab(text: l10n.emailTab),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    PhoneOtpPanel(phoneController: _phoneCtrl),
                    _EmailTab(
                      emailController: _emailCtrl,
                      passController: _passCtrl,
                      obscure: _obscure,
                      onToggleObscure: () => setState(() => _obscure = !_obscure),
                      onSignIn: () => _signInAndEnter(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.signUpPrompt, style: Theme.of(context).textTheme.bodySmall),
                  TextButton(
                    onPressed: () => context.push(AppRoute.signUp.path),
                    child: Text(l10n.signUp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailTab extends StatelessWidget {
  const _EmailTab({
    required this.emailController,
    required this.passController,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  final TextEditingController emailController;
  final TextEditingController passController;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: l10n.emailHint,
            prefixIcon: const Icon(Icons.alternate_email_rounded),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passController,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: l10n.passwordHint,
            prefixIcon: const Icon(Icons.lock_rounded),
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.forgotPasswordComingSoon)),
              );
            },
            child: Text(l10n.forgotPassword),
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(label: l10n.signIn, onPressed: onSignIn),
      ],
    );
  }
}
