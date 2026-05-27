import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/preferences_bootstrap.dart';
import '../data/auth_repository.dart';

const kParkoUserId = 'parko_user_id';
const kParkoUserPhone = 'parko_user_phone';
const kPendingDisplayName = 'parko_pending_display_name';
const kPendingEmail = 'parko_pending_email';
const kPendingSignupPhone = 'parko_pending_signup_phone';
const kDemoUserId = 'demo-user-1';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) return MockAuthRepository();
  return ApiAuthRepository(dio: ref.watch(dioProvider), baseUrl: base);
});

final currentUserIdProvider = StateProvider<String>((ref) {
  return PreferencesBootstrap.instance.getString(kParkoUserId) ?? kDemoUserId;
});

final authControllerProvider = Provider<AuthController>((ref) => AuthController(ref));

class AuthController {
  AuthController(this._ref);

  final Ref _ref;

  Future<void> persistSession(AuthVerifyResult result) async {
    final prefs = PreferencesBootstrap.instance;
    await prefs.setString(kParkoUserId, result.userId);
    await prefs.setString(kParkoUserPhone, result.phone);
    _ref.read(currentUserIdProvider.notifier).state = result.userId;
  }

  Future<void> clearSession() async {
    final prefs = PreferencesBootstrap.instance;
    await prefs.remove(kParkoUserId);
    await prefs.remove(kParkoUserPhone);
    _ref.read(currentUserIdProvider.notifier).state = kDemoUserId;
  }

  String? get storedPhone => PreferencesBootstrap.instance.getString(kParkoUserPhone);

  Future<void> savePendingSignup({
    required String displayName,
    required String phone,
    String? email,
  }) async {
    final prefs = PreferencesBootstrap.instance;
    await prefs.setString(kPendingDisplayName, displayName.trim());
    await prefs.setString(kPendingSignupPhone, phone.trim());
    if (email != null && email.trim().isNotEmpty) {
      await prefs.setString(kPendingEmail, email.trim());
    } else {
      await prefs.remove(kPendingEmail);
    }
  }

  String? get pendingSignupPhone =>
      PreferencesBootstrap.instance.getString(kPendingSignupPhone);

  Future<void> applyPendingProfileIfAny() async {
    final prefs = PreferencesBootstrap.instance;
    final name = prefs.getString(kPendingDisplayName);
    final email = prefs.getString(kPendingEmail);
    if (name == null && email == null) return;
    final userId = _ref.read(currentUserIdProvider);
    try {
      await _ref.read(authRepositoryProvider).updateProfile(
            userId: userId,
            displayName: name,
            email: email,
          );
    } finally {
      await prefs.remove(kPendingDisplayName);
      await prefs.remove(kPendingEmail);
      await prefs.remove(kPendingSignupPhone);
    }
  }
}
