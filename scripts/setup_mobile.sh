#!/usr/bin/env bash
# Run mobile setup from the repo root (or: bash scripts/setup_mobile.sh)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="${HOME}/development/flutter/bin:${PATH}"

cd "$ROOT"
echo "==> flutter pub get"
flutter pub get

echo "==> Flutter iOS engine (needed for pod install)"
flutter precache --ios

echo "==> CocoaPods"
(cd ios && pod install)

echo "==> Android SDK path (if SDK exists)"
ANDROID_CONFIGURED=""
for SDK in "${HOME}/Library/Android/sdk" "${HOME}/Android/Sdk"; do
  if [[ -d "${SDK}/platform-tools" ]]; then
    flutter config --android-sdk "${SDK}"
    echo "    Using ANDROID_SDK: ${SDK}"
    ANDROID_CONFIGURED="1"
    break
  fi
done
if [[ -z "${ANDROID_CONFIGURED}" ]]; then
  echo "    No SDK found at ~/Library/Android/sdk or ~/Android/Sdk."
  echo "    Open Android Studio → Settings → Android SDK → note path, then:"
  echo "    flutter config --android-sdk <that-path>"
  echo "    flutter doctor --android-licenses"
fi

echo ""
echo "==> flutter doctor"
flutter doctor -v

echo ""
echo "Next:"
echo "  1. Put Google Maps API keys in android/app/src/main/AndroidManifest.xml and ios/Runner/AppDelegate.swift"
echo "  2. Start Simulator or emulator (or plug in phone), then:"
echo "       flutter devices"
echo "       flutter run -d ios"
echo "       flutter run -d android"
