package com.parko.kw.parko

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "parko/maps")
            .setMethodCallHandler { call, result ->
                if (call.method == "apiKeyStatus") {
                    result.success(if (resolvedMapsApiKey() != null) "ok" else "missing")
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun resolvedMapsApiKey(): String? {
        val appInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
        val key = appInfo.metaData?.getString("com.google.android.geo.API_KEY")?.trim()
        if (key.isNullOrEmpty() || key == "YOUR_ANDROID_MAPS_API_KEY" || key.startsWith("\${")) {
            return null
        }
        return key
    }
}
