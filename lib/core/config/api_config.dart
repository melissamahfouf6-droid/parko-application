/// Backend base URL **without** trailing slash.
///
/// When empty, the app uses in-memory mock loyalty data (no server).
/// Examples:
/// - iOS Simulator / desktop: `--dart-define=PARKO_API_BASE=http://127.0.0.1:3000`
/// - Android emulator: `--dart-define=PARKO_API_BASE=http://10.0.2.2:3000`
/// - Physical device: your machine LAN IP, e.g. `http://192.168.1.10:3000`
class ApiConfig {
  ApiConfig._();

  static const String parkoApiBase = String.fromEnvironment(
    'PARKO_API_BASE',
    defaultValue: '',
  );
}
