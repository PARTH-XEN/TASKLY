package com.example.taskly

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

/**
 * Manages exact and fallback alarm scheduling using Android's native AlarmManager.
 * Schedules alarms that wake up the device from Doze Mode (RTC_WAKEUP).
 */
class NativeAlarmScheduler(private val context: Context) {
    private val alarmManager: AlarmManager =
        context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    companion object {
        const val TAG = "NativeAlarmScheduler"
        const val ACTION_FIRE_ALARM = "com.example.taskly.ACTION_FIRE_ALARM"
        const val EXTRA_REMINDER_ID = "com.example.taskly.EXTRA_REMINDER_ID"

        fun getRequestCode(id: String): Int {
            return id.hashCode() and 0x7FFFFFFF
        }
    }

    /**
     * Checks if exact alarm permission is granted.
     * On Android 12+ (API 31+), requires SCHEDULE_EXACT_ALARM or USE_EXACT_ALARM.
     */
    fun canScheduleExactAlarms(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            alarmManager.canScheduleExactAlarms()
        } else {
            true
        }
    }

    /**
     * Schedules a native alarm for the given reminder.
     */
    fun schedule(reminder: NativeReminder): Boolean {
        if (!reminder.isEnabled) {
            cancel(reminder.id)
            return false
        }

        val intent = Intent(context, NativeAlarmReceiver::class.java).apply {
            action = ACTION_FIRE_ALARM
            putExtra(EXTRA_REMINDER_ID, reminder.id)
        }

        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            getRequestCode(reminder.id),
            intent,
            flags
        )

        val triggerAtMillis = reminder.scheduledAtMillis

        try {
            if (canScheduleExactAlarms()) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent
                    )
                } else {
                    alarmManager.setExact(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent
                    )
                }
                Log.d(TAG, "Exact alarm scheduled for reminder ${reminder.id} at $triggerAtMillis")
                return true
            } else {
                // Fallback to inexact allow while idle on Android 12+ if exact permission restricted
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent
                    )
                } else {
                    alarmManager.set(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent
                    )
                }
                Log.w(TAG, "Exact alarm restricted. Fallback setAndAllowWhileIdle used for ${reminder.id}")
                return true
            }
        } catch (e: SecurityException) {
            Log.e(TAG, "SecurityException scheduling exact alarm: ${e.message}. Using inexact fallback.")
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent
                    )
                    return true
                }
            } catch (fallbackEx: Exception) {
                Log.e(TAG, "Fatal alarm scheduling failure: ${fallbackEx.message}")
            }
            return false
        } catch (e: Exception) {
            Log.e(TAG, "Failed to schedule alarm for ${reminder.id}: ${e.message}")
            return false
        }
    }

    /**
     * Cancels an existing scheduled alarm.
     */
    fun cancel(id: String) {
        val intent = Intent(context, NativeAlarmReceiver::class.java).apply {
            action = ACTION_FIRE_ALARM
            putExtra(EXTRA_REMINDER_ID, id)
        }

        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            getRequestCode(id),
            intent,
            flags
        )

        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()
        Log.d(TAG, "Cancelled alarm for reminder $id")
    }
}

