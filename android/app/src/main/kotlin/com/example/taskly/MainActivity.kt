package com.example.taskly

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.time.ZoneId
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private val CHANNEL = "taskly/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalTimezone") {
                val tzId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    ZoneId.systemDefault().id
                } else {
                    TimeZone.getDefault().id
                }
                result.success(tzId)
            } else {
                result.notImplemented()
            }
        }
    }
}
