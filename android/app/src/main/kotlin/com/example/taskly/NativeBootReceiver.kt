package com.example.taskly

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Restores pending reminders after device reboot or app upgrade.
 */
class NativeBootReceiver : BroadcastReceiver() {

    companion object {
        const val TAG = "NativeBootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "onReceive action=$action")

        if (action == Intent.ACTION_BOOT_COMPLETED ||
            action == Intent.ACTION_MY_PACKAGE_REPLACED ||
            action == "android.intent.action.QUICKBOOT_POWERON" ||
            action == "com.htc.intent.action.QUICKBOOT_POWERON"
        ) {
            val store = NativeReminderStore.getInstance(context)
            val scheduler = NativeAlarmScheduler(context)
            val now = System.currentTimeMillis()

            // Clean up stale reminders
            store.clearExpired(now)

            val reminders = store.getAllReminders()
            var restoredCount = 0

            for (reminder in reminders) {
                if (reminder.isEnabled && reminder.scheduledAtMillis > now) {
                    val success = scheduler.schedule(reminder)
                    if (success) {
                        restoredCount++
                    }
                }
            }

            Log.i(TAG, "Device reboot recovery completed. Restored $restoredCount / ${reminders.size} reminders.")
        }
    }
}

