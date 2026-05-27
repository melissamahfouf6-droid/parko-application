import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/notifications/parko_local_notifications.dart';
import 'core/storage/hive_bootstrap.dart';
import 'core/storage/preferences_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBootstrap.init();
  await PreferencesBootstrap.init();
  await ParkoLocalNotifications.instance.init();
  runApp(const ProviderScope(child: ParkoApp()));
}

