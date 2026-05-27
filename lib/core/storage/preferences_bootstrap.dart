import 'package:shared_preferences/shared_preferences.dart';

class PreferencesBootstrap {
  PreferencesBootstrap._();

  static SharedPreferences? _instance;

  static Future<SharedPreferences> init() async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static SharedPreferences get instance {
    final p = _instance;
    if (p == null) {
      throw StateError('Call PreferencesBootstrap.init() before runApp');
    }
    return p;
  }
}
