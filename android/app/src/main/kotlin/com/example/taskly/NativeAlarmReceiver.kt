package com.example.taskly

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

/**
 * BroadcastReceiver responsible for receiving AlarmManager wake-up alarms
 * and notification action clicks (Stop, Snooze).
 */
class NativeAlarmReceiver : BroadcastReceiver() {

    companion object {
        const val TAG = "NativeAlarmReceiver"
        const val ACTION_FIRE_ALARM = "com.example.taskly.ACTION_FIRE_ALARM"
        const val ACTION_STOP = "com.example.taskly.ACTION_STOP"
        const val ACTION_SNOOZE = "com.example.taskly.ACTION_SNOOZE"
        const val EXTRA_REMINDER_ID = "com.example.taskly.EXTRA_REMINDER_ID"

        @Volatile
        private var wakeLock: PowerManager.WakeLock? = null

        fun releaseWakeLock() {
            try {
                if (wakeLock?.isHeld == true) {
                    wakeLock?.release()
                    Log.d(TAG, "WakeLock released")
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error releasing WakeLock: ${e.message}")
            } finally {
                wakeLock = null
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val reminderId = intent.getStringExtra(EXTRA_REMINDER_ID) ?: ""

        Log.d(TAG, "onReceive action=$action, reminderId=$reminderId")

        when (action) {
            ACTION_FIRE_ALARM -> {
                if (reminderId.isEmpty()) {
                    Log.w(TAG, "Received ACTION_FIRE_ALARM with empty reminderId")
                    return
                }

                // Acquire WakeLock to keep CPU alive until Foreground Service is running
                try {
                    val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
                    wakeLock = powerManager.newWakeLock(
                        PowerManager.PARTIAL_WAKE_LOCK,
                        "taskly:alarm_speech_wakelock"
                    ).apply {
                        setReferenceCounted(false)
                        acquire(60000L) // Safe 60-second timeout
                    }
                    Log.d(TAG, "Acquired WakeLock for reminder $reminderId")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to acquire WakeLock: ${e.message}")
                }

                // Start Native Foreground Speech Service
                val serviceIntent = Intent(context, NativeSpeechService::class.java).apply {
                    this.action = NativeSpeechService.ACTION_SPEAK_REMINDER
                    putExtra(NativeSpeechService.EXTRA_REMINDER_ID, reminderId)
                }

                try {
                    ContextCompat.startForegroundService(context, serviceIntent)
                    Log.d(TAG, "Started NativeSpeechService for reminder $reminderId")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to start NativeSpeechService: ${e.message}")
                    releaseWakeLock()
                }
            }

            ACTION_STOP -> {
                Log.d(TAG, "User tapped Stop for reminder $reminderId")
                // Stop the speech service
                val stopIntent = Intent(context, NativeSpeechService::class.java).apply {
                    this.action = NativeSpeechService.ACTION_STOP_SERVICE
                }
                context.startService(stopIntent)

                // Dismiss notification
                val notificationId = NativeAlarmScheduler.getRequestCode(reminderId)
                NotificationManagerCompat.from(context).cancel(notificationId)
                releaseWakeLock()
            }

            ACTION_SNOOZE -> {
                Log.d(TAG, "User tapped Snooze for reminder $reminderId")
                // Stop active speech service
                val stopIntent = Intent(context, NativeSpeechService::class.java).apply {
                    this.action = NativeSpeechService.ACTION_STOP_SERVICE
                }
                context.startService(stopIntent)

                // Dismiss current notification
                val notificationId = NativeAlarmScheduler.getRequestCode(reminderId)
                NotificationManagerCompat.from(context).cancel(notificationId)
                releaseWakeLock()

                // Reschedule for +10 minutes
                val store = NativeReminderStore.getInstance(context)
                val existing = store.getReminder(reminderId)
                if (existing != null) {
                    val snoozedTime = System.currentTimeMillis() + (10 * 60 * 1000L)
                    val snoozedReminder = existing.copy(scheduledAtMillis = snoozedTime)
                    store.saveReminder(snoozedReminder)
                    NativeAlarmScheduler(context).schedule(snoozedReminder)
                    Log.d(TAG, "Snoozed reminder $reminderId for 10 minutes (at $snoozedTime)")
                }
            }
        }
    }
}

