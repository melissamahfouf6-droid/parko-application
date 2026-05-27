import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences_bootstrap.dart';

const _kOnboardingDone = 'onboarding_complete';
const _kSignedIn = 'demo_session_signed_in';

final appSessionProvider = Provider<AppSession>((ref) => AppSession());

class AppSession {
  bool get onboardingComplete =>
      PreferencesBootstrap.instance.getBool(_kOnboardingDone) ?? false;

  bool get isSignedIn => PreferencesBootstrap.instance.getBool(_kSignedIn) ?? false;

  Future<void> completeOnboarding() async {
    await PreferencesBootstrap.instance.setBool(_kOnboardingDone, true);
  }

  Future<void> markSignedIn() async {
    await PreferencesBootstrap.instance.setBool(_kSignedIn, true);
  }

  Future<void> signOut() async {
    await PreferencesBootstrap.instance.setBool(_kSignedIn, false);
  }
}
