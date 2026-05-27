import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_screen.dart';
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/home/presentation/home_map_screen.dart';
import '../features/loyalty/presentation/loyalty_hub_screen.dart';
import '../features/parking/presentation/my_parking_screen.dart';
import '../features/marketplace/presentation/list_my_spot_screen.dart';
import '../features/wallet/presentation/wallet_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/buddies/presentation/buddy_chat_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/help/presentation/help_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';

enum AppRoute {
  splash('/'),
  onboarding('/onboarding'),
  auth('/auth'),
  signUp('/sign-up'),
  myParking('/my-parking'),
  search('/search'),
  loyalty('/loyalty'),
  marketplaceList('/marketplace/list'),
  wallet('/wallet'),
  settings('/settings'),
  buddyChat('/buddies/chat'),
  notifications('/notifications'),
  help('/help'),
  favorites('/favorites'),
  home('/home');

  const AppRoute(this.path);
  final String path;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        pageBuilder: (context, state) => const MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.onboarding.path,
        pageBuilder: (context, state) => const MaterialPage(child: OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoute.auth.path,
        pageBuilder: (context, state) => const MaterialPage(child: AuthScreen()),
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        pageBuilder: (context, state) => const MaterialPage(child: SignUpScreen()),
      ),
      GoRoute(
        path: AppRoute.myParking.path,
        pageBuilder: (context, state) => const MaterialPage(child: MyParkingScreen()),
      ),
      GoRoute(
        path: AppRoute.search.path,
        pageBuilder: (context, state) => const MaterialPage(child: SearchScreen()),
      ),
      GoRoute(
        path: AppRoute.loyalty.path,
        pageBuilder: (context, state) => const MaterialPage(child: LoyaltyHubScreen()),
      ),
      GoRoute(
        path: AppRoute.marketplaceList.path,
        pageBuilder: (context, state) => const MaterialPage(child: ListMySpotScreen()),
      ),
      GoRoute(
        path: AppRoute.wallet.path,
        pageBuilder: (context, state) => const MaterialPage(child: WalletScreen()),
      ),
      GoRoute(
        path: AppRoute.settings.path,
        pageBuilder: (context, state) => const MaterialPage(child: SettingsScreen()),
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        pageBuilder: (context, state) => const MaterialPage(child: NotificationsScreen()),
      ),
      GoRoute(
        path: AppRoute.help.path,
        pageBuilder: (context, state) => const MaterialPage(child: HelpScreen()),
      ),
      GoRoute(
        path: AppRoute.favorites.path,
        pageBuilder: (context, state) => const MaterialPage(child: FavoritesScreen()),
      ),
      GoRoute(
        path: AppRoute.buddyChat.path,
        pageBuilder: (context, state) {
          final name = state.uri.queryParameters['name'] ?? 'Buddy';
          final id = state.uri.queryParameters['id'] ?? 'buddy-1';
          return MaterialPage(child: BuddyChatScreen(buddyId: id, buddyName: name));
        },
      ),
      GoRoute(
        path: AppRoute.home.path,
        pageBuilder: (context, state) => const MaterialPage(child: HomeMapScreen()),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Route error: ${state.error}'),
        ),
      ),
    ),
  );
});

