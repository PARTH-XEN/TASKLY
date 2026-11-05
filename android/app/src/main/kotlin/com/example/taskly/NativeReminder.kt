package com.example.taskly

import org.json.JSONObject

/**
 * Data model for native reminders scheduled on Android.
 * Serializable to/from JSON for persistence in SharedPreferences.
 */
data class NativeReminder(
    val id: String,
    val title: String,
    val spokenMessage: String,
    val scheduledAtMillis: Long,
    val voicePersonality: String = "nova",
    val speechRate: Float = 1.0f,
    val speechPitch: Float = 1.0f,
    val language: String = "en-US",
    val ttsVoiceName: String? = null,
    val isEnabled: Boolean = true
) {
    fun toJson(): String {
        val json = JSONObject()
        json.put("id", id)
        json.put("title", title)
        json.put("spokenMessage", spokenMessage)
        json.put("scheduledAtMillis", scheduledAtMillis)
        json.put("voicePersonality", voicePersonality)
        json.put("speechRate", speechRate.toDouble())
        json.put("speechPitch", speechPitch.toDouble())
        json.put("language", language)
        if (ttsVoiceName != null) {
            json.put("ttsVoiceName", ttsVoiceName)
        }
        json.put("isEnabled", isEnabled)
        return json.toString()
    }

    companion object {
        fun fromJson(jsonStr: String): NativeReminder? {
            return try {
                val json = JSONObject(jsonStr)
                NativeReminder(
                    id = json.getString("id"),
                    title = json.getString("title"),
                    spokenMessage = json.optString("spokenMessage", "Hey! It's time for your reminder."),
                    scheduledAtMillis = json.getLong("scheduledAtMillis"),
                    voicePersonality = json.optString("voicePersonality", "nova"),
                    speechRate = json.optDouble("speechRate", 1.0).toFloat(),
                    speechPitch = json.optDouble("speechPitch", 1.0).toFloat(),
                    language = json.optString("language", "en-US"),
                    ttsVoiceName = if (json.has("ttsVoiceName") && !json.isNull("ttsVoiceName")) json.getString("ttsVoiceName") else null,
                    isEnabled = json.optBoolean("isEnabled", true)
                )
            } catch (e: Exception) {
                null
            }
        }

        fun fromMap(map: Map<*, *>): NativeReminder {
            val id = (map["id"] as? String) ?: ""
            val title = (map["title"] as? String) ?: "Task Reminder"
            val spokenMessage = (map["spokenMessage"] as? String)
                ?: (map["customSpokenMessage"] as? String)
                ?: "Hey! It's time for $title. Let's get started!"
            val scheduledAtMillis = when (val timeVal = map["scheduledAtMillis"]) {
                is Number -> timeVal.toLong()
                is String -> timeVal.toLongOrNull() ?: System.currentTimeMillis()
                else -> System.currentTimeMillis()
            }
            val voicePersonality = (map["voicePersonality"] as? String) ?: "nova"
            val speechRate = when (val rateVal = map["speechRate"]) {
                is Number -> rateVal.toFloat()
                else -> 1.0f
            }
            val speechPitch = when (val pitchVal = map["speechPitch"]) {
                is Number -> pitchVal.toFloat()
                else -> 1.0f
            }
            val language = (map["language"] as? String) ?: "en-US"
            val ttsVoiceName = map["ttsVoiceName"] as? String
            val isEnabled = (map["isEnabled"] as? Boolean) ?: true

            return NativeReminder(
                id = id,
                title = title,
                spokenMessage = spokenMessage,
                scheduledAtMillis = scheduledAtMillis,
                voicePersonality = voicePersonality,
                speechRate = speechRate,
                speechPitch = speechPitch,
                language = language,
                ttsVoiceName = ttsVoiceName,
                isEnabled = isEnabled
            )
        }
    }
}

