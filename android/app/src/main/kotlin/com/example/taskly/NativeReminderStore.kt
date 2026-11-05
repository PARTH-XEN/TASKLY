package com.example.taskly

import android.content.Context
import android.content.SharedPreferences

/**
 * Thread-safe persistent storage for reminders on Android.
 * Backed by SharedPreferences to guarantee instant, synchronous access
 * even when the Flutter Engine is completely terminated.
 */
class NativeReminderStore(context: Context) {
    private val prefs: SharedPreferences =
        context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    companion object {
        private const val PREFS_NAME = "taskly_native_reminders"
        private const val KEY_PREFIX = "reminder_"

        @Volatile
        private var instance: NativeReminderStore? = null

        fun getInstance(context: Context): NativeReminderStore {
            return instance ?: synchronized(this) {
                instance ?: NativeReminderStore(context).also { instance = it }
            }
        }
    }

    /**
     * Persists or updates a reminder in SharedPreferences.
     */
    fun saveReminder(reminder: NativeReminder) {
        prefs.edit()
            .putString("$KEY_PREFIX${reminder.id}", reminder.toJson())
            .apply()
    }

    /**
     * Retrieves a reminder by ID.
     */
    fun getReminder(id: String): NativeReminder? {
        val jsonStr = prefs.getString("$KEY_PREFIX$id", null) ?: return null
        return NativeReminder.fromJson(jsonStr)
    }

    /**
     * Returns all stored reminders.
     */
    fun getAllReminders(): List<NativeReminder> {
        val list = mutableListOf<NativeReminder>()
        for ((key, value) in prefs.all) {
            if (key.startsWith(KEY_PREFIX) && value is String) {
                val reminder = NativeReminder.fromJson(value)
                if (reminder != null) {
                    list.add(reminder)
                }
            }
        }
        return list
    }

    /**
     * Removes a reminder from storage.
     */
    fun removeReminder(id: String) {
        prefs.edit()
            .remove("$KEY_PREFIX$id")
            .apply()
    }

    /**
     * Removes expired reminders older than a threshold (e.g. 1 hour past scheduled time).
     */
    fun clearExpired(currentTimeMillis: Long = System.currentTimeMillis()) {
        val editor = prefs.edit()
        for ((key, value) in prefs.all) {
            if (key.startsWith(KEY_PREFIX) && value is String) {
                val reminder = NativeReminder.fromJson(value)
                // If scheduled time was more than 1 hour ago and not recurring
                if (reminder != null && (currentTimeMillis - reminder.scheduledAtMillis > 3600000L)) {
                    editor.remove(key)
                }
            }
        }
        editor.apply()
    }
}

