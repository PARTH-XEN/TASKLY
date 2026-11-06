package com.example.taskly

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.time.ZoneId
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    private val CHANNEL = "taskly/native"
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        checkAndApplyLockScreenFlags(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        checkAndApplyLockScreenFlags(intent)
        handleAlarmLaunchIntent(intent)
    }

    private fun checkAndApplyLockScreenFlags(intent: Intent?) {
        val fromAlarm = intent?.getBooleanExtra("fromAlarm", false) == true
        val showOverLock = intent?.getBooleanExtra("showOverLockScreen", false) == true
        turnScreenOnAndShowWhenLocked(fromAlarm && showOverLock)
    }

    private fun turnScreenOnAndShowWhenLocked(enable: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(enable)
            setTurnScreenOn(enable)
        } else {
            if (enable) {
                @Suppress("DEPRECATION")
                window.addFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                )
            } else {
                @Suppress("DEPRECATION")
                window.clearFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                )
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getLocalTimezone" -> {
                    val tzId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        ZoneId.systemDefault().id
                    } else {
                        TimeZone.getDefault().id
                    }
                    result.success(tzId)
                }

                "scheduleNativeAlarm" -> {
                    try {
                        val args = call.arguments as? Map<*, *>
                        if (args != null) {
                            val reminder = NativeReminder.fromMap(args)
                            val store = NativeReminderStore.getInstance(this)
                            store.saveReminder(reminder)
                            val scheduler = NativeAlarmScheduler(this)
                            val success = scheduler.schedule(reminder)
                            result.success(success)
                        } else {
                            result.error("INVALID_ARGS", "Expected reminder map", null)
                        }
                    } catch (e: Exception) {
                        result.error("SCHEDULE_FAILED", e.message, null)
                    }
                }

                "cancelNativeAlarm" -> {
                    try {
                        val id = call.argument<String>("id") ?: ""
                        if (id.isNotEmpty()) {
                            val scheduler = NativeAlarmScheduler(this)
                            scheduler.cancel(id)
                            val store = NativeReminderStore.getInstance(this)
                            store.removeReminder(id)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        result.error("CANCEL_FAILED", e.message, null)
                    }
                }

                "snoozeNativeAlarm" -> {
                    try {
                        val id = call.argument<String>("id") ?: ""
                        val minutes = call.argument<Int>("minutes") ?: 10
                        if (id.isNotEmpty()) {
                            val store = NativeReminderStore.getInstance(this)
                            val existing = store.getReminder(id)
                            if (existing != null) {
                                val snoozedTime = System.currentTimeMillis() + (minutes * 60 * 1000L)
                                val snoozedReminder = existing.copy(scheduledAtMillis = snoozedTime)
                                store.saveReminder(snoozedReminder)
                                NativeAlarmScheduler(this).schedule(snoozedReminder)
                                result.success(snoozedTime)
                            } else {
                                result.error("NOT_FOUND", "Reminder not found in store", null)
                            }
                        } else {
                            result.error("INVALID_ID", "ID is required", null)
                        }
                    } catch (e: Exception) {
                        result.error("SNOOZE_FAILED", e.message, null)
                    }
                }

                "stopNativeSpeech" -> {
                    try {
                        val stopIntent = Intent(this, NativeSpeechService::class.java).apply {
                            action = NativeSpeechService.ACTION_STOP_SERVICE
                        }
                        startService(stopIntent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("STOP_FAILED", e.message, null)
                    }
                }

                "dismissAlarmActivity" -> {
                    try {
                        moveTaskToBack(true)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("DISMISS_FAILED", e.message, null)
                    }
                }

                "canScheduleExactAlarms" -> {
                    val scheduler = NativeAlarmScheduler(this)
                    result.success(scheduler.canScheduleExactAlarms())
                }

                "requestExactAlarmPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        try {
                            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                                data = Uri.parse("package:$packageName")
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("PERMISSION_INTENT_FAILED", e.message, null)
                        }
                    } else {
                        result.success(true)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        // Check if app launched from full-screen alarm notification
        handleAlarmLaunchIntent(intent)
    }

    private fun handleAlarmLaunchIntent(intent: Intent?) {
        if (intent?.getBooleanExtra("fromAlarm", false) == true) {
            val reminderId = intent.getStringExtra("reminderId") ?: ""
            val title = intent.getStringExtra("title") ?: "Reminder"
            val spokenMessage = intent.getStringExtra("spokenMessage") ?: ""
            val voicePersonality = intent.getStringExtra("voicePersonality") ?: "nova"

            val alarmData = mapOf(
                "reminderId" to reminderId,
                "title" to title,
                "spokenMessage" to spokenMessage,
                "voicePersonality" to voicePersonality
            )

            methodChannel?.invokeMethod("onAlarmTriggeredFromNative", alarmData)
        }
    }
}
