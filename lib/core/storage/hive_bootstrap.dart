import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBootstrap {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    // TODO: register adapters + open boxes
  }
}

