import 'dart:io' show Platform;

/// True when running on the iOS Simulator (same GoogleMap path as a real device).
bool get runningOnAppleSimulator {
  if (!Platform.isIOS) return false;
  return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') ||
      Platform.environment.containsKey('SIMULATOR_UDID');
}
