import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/config/api_config.dart';
import '../../../core/i18n/app_locales.dart';
import '../../../core/theme/app_theme_mode_provider.dart';
import '../../../core/theme/parko_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/application/auth_providers.dart';
import '../../onboarding/application/app_session_providers.dart';
import '../application/settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  DateTime? _memberSince;

  @override
  void initState() {
    super.initState();
    final s = ref.read(userSettingsProvider);
    final storedPhone = ref.read(authControllerProvider).storedPhone;
    _name = TextEditingController(text: s.displayName);
    _phone = TextEditingController(text: storedPhone?.isNotEmpty == true ? storedPhone! : s.phone);
    _email = TextEditingController(text: s.email);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRemoteProfile());
  }

  Future<void> _loadRemoteProfile() async {
    if (ApiConfig.parkoApiBase.trim().isEmpty) return;
    final uid = ref.read(currentUserIdProvider);
    try {
      final profile = await ref.read(authRepositoryProvider).fetchProfile(userId: uid);
      if (!mounted) return;
      _name.text = profile.displayName ?? _name.text;
      _phone.text = profile.phone;
      _email.text = profile.email ?? _email.text;
      setState(() => _memberSince = profile.memberSince);
      await ref.read(userSettingsProvider.notifier).updateProfile(
            displayName: _name.text.trim(),
            phone: _phone.text.trim(),
            email: _email.text.trim(),
          );
    } catch (_) {}
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(userSettingsProvider);
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.settingsProfileSection, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: ParkoColors.sky.withOpacity(0.2),
                    child: Text(
                      settings.displayName.isNotEmpty ? settings.displayName[0] : '?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: ParkoColors.sky,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_memberSince != null)
                    Text(
                      l10n.settingsMemberSince(_formatDate(_memberSince!)),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.parko.textSecondary),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.settingsUserId(ref.watch(currentUserIdProvider)),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ParkoColors.gray),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.settingsCopyId,
                        icon: const Icon(Icons.copy_rounded, size: 18, color: ParkoColors.sky),
                        onPressed: () async {
                          final id = ref.read(currentUserIdProvider);
                          await Clipboard.setData(ClipboardData(text: id));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.settingsIdCopied)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l10n.settingsNameLabel),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phone,
                    decoration: InputDecoration(labelText: l10n.settingsPhoneLabel),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(labelText: l10n.settingsEmailLabel),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: () async {
                      final name = _name.text.trim();
                      final phone = _phone.text.trim();
                      final email = _email.text.trim();
                      await ref.read(userSettingsProvider.notifier).updateProfile(
                            displayName: name,
                            phone: phone,
                            email: email,
                          );
                      var synced = false;
                      if (ApiConfig.parkoApiBase.trim().isNotEmpty) {
                        try {
                          await ref.read(authRepositoryProvider).updateProfile(
                                userId: ref.read(currentUserIdProvider),
                                displayName: name,
                                email: email,
                              );
                          synced = true;
                        } catch (_) {}
                      }
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            synced ? l10n.settingsProfileSynced : l10n.settingsProfileSaved,
                          ),
                        ),
                      );
                    },
                    child: Text(l10n.settingsSaveProfile),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.settingsNotificationsSection, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(l10n.settingsParkingReminders),
            subtitle: Text(l10n.settingsParkingRemindersHint),
            value: settings.parkingReminders,
            activeColor: ParkoColors.sky,
            onChanged: (v) => ref.read(userSettingsProvider.notifier).setParkingReminders(v),
          ),
          SwitchListTile(
            title: Text(l10n.settingsMarketing),
            subtitle: Text(l10n.settingsMarketingHint),
            value: settings.marketingNotifications,
            activeColor: ParkoColors.sky,
            onChanged: (v) => ref.read(userSettingsProvider.notifier).setMarketingNotifications(v),
          ),
          const Divider(height: 28),
          Text(l10n.settingsAppSection, style: Theme.of(context).textTheme.titleSmall),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: ParkoColors.sky),
            title: Text(l10n.drawerLanguage),
            subtitle: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              final next = locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
              ref.read(appLocaleProvider.notifier).state = next;
            },
          ),
          ListTile(
            leading: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.dark_mode_rounded
                  : themeMode == ThemeMode.light
                      ? Icons.light_mode_rounded
                      : Icons.brightness_auto_rounded,
              color: ParkoColors.sky,
            ),
            title: Text(l10n.settingsTheme),
            subtitle: Text(_themeModeLabel(l10n, themeMode)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _pickThemeMode(context, ref, themeMode),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_rounded, color: ParkoColors.amber),
            title: Text(l10n.drawerWallet),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoute.wallet.path),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_rounded, color: ParkoColors.amber),
            title: Text(l10n.drawerLoyalty),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoute.loyalty.path),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded, color: ParkoColors.sky),
            title: Text(l10n.helpTitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(AppRoute.help.path),
          ),
          const Divider(height: 28),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: ParkoColors.red),
            title: Text(l10n.drawerSignOut, style: const TextStyle(color: ParkoColors.red)),
            onTap: () async {
              await ref.read(appSessionProvider).signOut();
              await ref.read(authControllerProvider).clearSession();
              if (!context.mounted) return;
              context.go(AppRoute.auth.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: ParkoColors.gray),
            title: Text(l10n.settingsAbout),
            subtitle: Text(l10n.settingsVersion('1.0.0')),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _themeModeLabel(AppLocalizations l10n, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => l10n.settingsThemeDark,
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.system => l10n.settingsThemeSystem,
    };
  }

  Future<void> _pickThemeMode(BuildContext context, WidgetRef ref, ThemeMode current) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto_rounded),
              title: Text(l10n.settingsThemeSystem),
              trailing: current == ThemeMode.system ? const Icon(Icons.check_rounded, color: ParkoColors.sky) : null,
              onTap: () => Navigator.pop(ctx, ThemeMode.system),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode_rounded),
              title: Text(l10n.settingsThemeLight),
              trailing: current == ThemeMode.light ? const Icon(Icons.check_rounded, color: ParkoColors.sky) : null,
              onTap: () => Navigator.pop(ctx, ThemeMode.light),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_rounded),
              title: Text(l10n.settingsThemeDark),
              trailing: current == ThemeMode.dark ? const Icon(Icons.check_rounded, color: ParkoColors.sky) : null,
              onTap: () => Navigator.pop(ctx, ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    await ref.read(appThemeModeProvider.notifier).setMode(picked);
  }
}
