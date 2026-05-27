import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Whether the native Google Maps SDK was configured with a real API key.
enum MapsKeyStatus { ok, missing, unsupported }

const _channel = MethodChannel('parko/maps');

Future<MapsKeyStatus> fetchMapsKeyStatus() async {
  if (kIsWeb) return MapsKeyStatus.unsupported;
  if (!Platform.isIOS && !Platform.isAndroid) return MapsKeyStatus.unsupported;
  try {
    final status = await _channel.invokeMethod<String>('apiKeyStatus');
    return status == 'ok' ? MapsKeyStatus.ok : MapsKeyStatus.missing;
  } catch (_) {
    return MapsKeyStatus.missing;
  }
}
