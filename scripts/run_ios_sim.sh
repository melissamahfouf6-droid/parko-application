#!/usr/bin/env bash
# Boot an iOS Simulator if needed, then run Parko on it.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="${HOME}/development/flutter/bin:${PATH}"

echo "==> Xcode developer dir"
xcode-select -p

echo "==> Available iOS simulators (first lines)"
xcrun simctl list devices available 2>/dev/null | head -25

# Pick first Booted iPhone UDID, else first Shutdown iPhone UDID under iOS
BOOTED_UDID=$(xcrun simctl list devices booted 2>/dev/null | grep "iPhone" | grep "Booted" | sed -E 's/.*\(([A-F0-9-]{36})\).*/\1/' | head -1 || true)
if [[ -n "${BOOTED_UDID}" ]]; then
  echo "==> Already booted: ${BOOTED_UDID}"
  UDID="${BOOTED_UDID}"
else
  UDID=$(xcrun simctl list devices available 2>/dev/null | grep "iPhone" | grep "Shutdown" | head -1 | grep -oE '\([A-F0-9-]{36}\)' | tr -d '()' | head -1 || true)
  if [[ -z "${UDID}" ]]; then
    echo "No iPhone simulator found. Install an iOS runtime in Xcode → Settings → Platforms."
    exit 1
  fi
  echo "==> Booting simulator ${UDID}"
  xcrun simctl boot "${UDID}" 2>/dev/null || true
  open -a Simulator
  echo "==> Waiting for Simulator..."
  sleep 5
fi

echo "==> flutter devices"
cd "${ROOT}"
flutter devices

echo "==> flutter run (this can take several minutes the first time)"
exec flutter run -d "${UDID}"
