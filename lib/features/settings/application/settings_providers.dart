import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/preferences_bootstrap.dart';
import '../domain/user_settings.dart';

const _kName = 'profile_display_name';
const _kPhone = 'profile_phone';
const _kEmail = 'profile_email';
const _kParkingReminders = 'pref_parking_reminders';
const _kMarketing = 'pref_marketing_notifications';

final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettings>((ref) {
  return UserSettingsNotifier();
});

class UserSettingsNotifier extends StateNotifier<UserSettings> {
  UserSettingsNotifier() : super(const UserSettings()) {
    _load();
  }

  void _load() {
    final p = PreferencesBootstrap.instance;
    state = UserSettings(
      displayName: p.getString(_kName) ?? state.displayName,
      phone: p.getString(_kPhone) ?? state.phone,
      email: p.getString(_kEmail) ?? state.email,
      parkingReminders: p.getBool(_kParkingReminders) ?? true,
      marketingNotifications: p.getBool(_kMarketing) ?? false,
    );
  }

  Future<void> updateProfile({String? displayName, String? phone, String? email}) async {
    final next = state.copyWith(
      displayName: displayName,
      phone: phone,
      email: email,
    );
    state = next;
    final p = PreferencesBootstrap.instance;
    await p.setString(_kName, next.displayName);
    await p.setString(_kPhone, next.phone);
    await p.setString(_kEmail, next.email);
  }

  Future<void> setParkingReminders(bool value) async {
    state = state.copyWith(parkingReminders: value);
    await PreferencesBootstrap.instance.setBool(_kParkingReminders, value);
  }

  Future<void> setMarketingNotifications(bool value) async {
    state = state.copyWith(marketingNotifications: value);
    await PreferencesBootstrap.instance.setBool(_kMarketing, value);
  }
}
