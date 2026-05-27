import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules device reminders for reservations (when user enables parking reminders).
class ParkoLocalNotifications {
  ParkoLocalNotifications._();

  static final ParkoLocalNotifications instance = ParkoLocalNotifications._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tz_data.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
    _ready = true;
  }

  int _idFor(String reservationId) => reservationId.hashCode & 0x7fffffff;

  Future<void> scheduleReservationReminder({
    required String reservationId,
    required String lotName,
    required DateTime startAt,
    int minutesBefore = 15,
  }) async {
    if (!_ready) await init();
    final fireAt = startAt.subtract(Duration(minutes: minutesBefore));
    if (!fireAt.isAfter(DateTime.now())) return;

    const android = AndroidNotificationDetails(
      'parko_reservations',
      'Parking reminders',
      channelDescription: 'Reminders before your reserved parking starts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);

    await _plugin.zonedSchedule(
      _idFor(reservationId),
      'Parking starts soon',
      '$lotName in $minutesBefore minutes — head over with Parko',
      tz.TZDateTime.from(fireAt, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReservationReminder(String reservationId) async {
    if (!_ready) return;
    await _plugin.cancel(_idFor(reservationId));
  }
}
