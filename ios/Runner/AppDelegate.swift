import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private static func resolvedMapsApiKey() -> String? {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String else {
      return nil
    }
    let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty || trimmed == "YOUR_IOS_MAPS_API_KEY" || trimmed.hasPrefix("$(") {
      return nil
    }
    return trimmed
  }

  private func registerMapsChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "parko/maps",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      if call.method == "apiKeyStatus" {
        result(AppDelegate.resolvedMapsApiKey() != nil ? "ok" : "missing")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let key = AppDelegate.resolvedMapsApiKey() {
      GMSServices.provideAPIKey(key)
      NSLog("[Parko] Google Maps SDK initialized.")
    } else {
      NSLog("[Parko] Google Maps: no valid GMSApiKey. Run: bash scripts/setup_google_maps_key.sh YOUR_KEY")
    }
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      registerMapsChannel(controller: controller)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
