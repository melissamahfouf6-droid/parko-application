import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/i18n/app_locales.dart';
import '../../../buddies/application/buddies_providers.dart';
import '../../../buddies/presentation/widgets/parking_buddies_sheet.dart';
import '../../../auth/application/auth_providers.dart';
import '../../../onboarding/application/app_session_providers.dart';
import '../../../settings/application/settings_providers.dart';
import '../../application/map_location_providers.dart';
import '../../../loyalty/application/loyalty_providers.dart';
import '../../../wallet/application/wallet_providers.dart';
import '../../../../core/theme/parko_colors.dart';
import '../../../../l10n/app_localizations.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(appLocaleProvider);
    final profile = ref.watch(userSettingsProvider);
    final wallet = ref.watch(walletBalanceProvider);
    final loyalty = ref.watch(loyaltyControllerProvider);

    return Drawer(
      backgroundColor: context.parko.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(AppRoute.settings.path);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(gradient: ParkoColors.gradient),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.appName, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        profile.displayName.isNotEmpty ? profile.displayName : l10n.authTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _DrawerStatChip(
                            icon: Icons.account_balance_wallet_rounded,
                            label: wallet.when(
                              data: (b) => l10n.drawerWalletBalance(b.toStringAsFixed(1)),
                              loading: () => '…',
                              error: (_, __) => '—',
                            ),
                          ),
                          const SizedBox(width: 8),
                          _DrawerStatChip(
                            icon: Icons.stars_rounded,
                            label: loyalty.when(
                              data: (s) => l10n.drawerPointsBalance(s.balancePoints),
                              loading: () => '…',
                              error: (_, __) => '—',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(Icons.local_parking_rounded, color: ParkoColors.sky),
                    title: Text(l10n.drawerFindParking),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final ok = await ref.read(mapLocationControllerProvider).centerOnUser();
                      if (!context.mounted) return;
                      if (!ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.locationUnavailable)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.locationFound)),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_rounded, color: ParkoColors.amber),
                    title: Text(l10n.favoritesTitle),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.favorites.path);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_rounded, color: ParkoColors.green),
                    title: Text(l10n.drawerMyParking),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.myParking.path);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.workspace_premium_rounded, color: ParkoColors.amber),
                    title: Text(l10n.drawerLoyalty),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.loyalty.path);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.groups_rounded, color: ParkoColors.sky),
                    title: Text(l10n.drawerBuddies),
                    onTap: () {
                      Navigator.of(context).pop();
                      final dest = ref.read(selectedDestinationProvider);
                      if (dest != null) {
                        // ignore: use_build_context_synchronously
                        ParkingBuddiesSheet.show(context, dest);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_work_rounded, color: ParkoColors.green),
                    title: Text(l10n.drawerMarketplace),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.marketplaceList.path);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_rounded, color: ParkoColors.amber),
                    title: Text(l10n.drawerWallet),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.wallet.path);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_rounded, color: ParkoColors.gray),
                    title: Text(l10n.drawerSettings),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoute.settings.path);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.language_rounded, color: context.parko.textSecondary),
                    title: Text(l10n.drawerLanguage),
                    subtitle: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
                    onTap: () {
                      final next = locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
                      ref.read(appLocaleProvider.notifier).state = next;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref.read(appSessionProvider).signOut();
                  await ref.read(authControllerProvider).clearSession();
                  if (!context.mounted) return;
                  context.go(AppRoute.auth.path);
                },
                icon: const Icon(Icons.logout_rounded, color: ParkoColors.red),
                label: Text(l10n.drawerSignOut, style: const TextStyle(color: ParkoColors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerStatChip extends StatelessWidget {
  const _DrawerStatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
