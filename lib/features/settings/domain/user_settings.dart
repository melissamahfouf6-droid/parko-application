class UserSettings {
  const UserSettings({
    this.displayName = 'Abdullah',
    this.phone = '+965 5000 0000',
    this.email = 'demo@parko.kw',
    this.parkingReminders = true,
    this.marketingNotifications = false,
  });

  final String displayName;
  final String phone;
  final String email;
  final bool parkingReminders;
  final bool marketingNotifications;

  UserSettings copyWith({
    String? displayName,
    String? phone,
    String? email,
    bool? parkingReminders,
    bool? marketingNotifications,
  }) {
    return UserSettings(
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      parkingReminders: parkingReminders ?? this.parkingReminders,
      marketingNotifications: marketingNotifications ?? this.marketingNotifications,
    );
  }
}
