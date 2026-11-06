package com.example.taskly

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import java.util.Locale

/**
 * Foreground Service responsible for:
 * 1. Showing a high-priority, full-screen lock-screen alarm notification with Stop/Snooze.
 * 2. Requesting AudioFocus (STREAM_ALARM / USAGE_ALARM).
 * 3. Initializing Android native TextToSpeech and speaking the reminder aloud.
 * 4. Cleaning up resources and shutting down when speech finishes.
 */
class NativeSpeechService : Service(), TextToSpeech.OnInitListener {

    private var tts: TextToSpeech? = null
    private var isTtsInitialized = false
    private var pendingReminder: NativeReminder? = null
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: AudioFocusRequest? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var safetyTimeoutRunnable: Runnable? = null
    private var repeatRunnable: Runnable? = null
    private var currentNotificationId = 1001

    private var currentRepeatIndex = 0
    private var targetRepeatCount = 1
    private var isStopped = false

    companion object {
        const val TAG = "NativeSpeechService"
        const val ACTION_SPEAK_REMINDER = "com.example.taskly.ACTION_SPEAK_REMINDER"
        const val ACTION_STOP_SERVICE = "com.example.taskly.ACTION_STOP_SERVICE"
        const val EXTRA_REMINDER_ID = "com.example.taskly.EXTRA_REMINDER_ID"
        const val CHANNEL_ID = "taskly_alarm_channel_v2"
        const val CHANNEL_NAME = "TASKLY Spoken Alarms"
        private const val BASE_TIMEOUT_MILLIS = 45000L
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        createNotificationChannelIfNeeded()
        Log.d(TAG, "NativeSpeechService created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        Log.d(TAG, "onStartCommand action=$action")

        if (action == ACTION_STOP_SERVICE) {
            Log.d(TAG, "Received ACTION_STOP_SERVICE. Terminating speech.")
            cleanupAndStop()
            return START_NOT_STICKY
        }

        if (action == ACTION_SPEAK_REMINDER) {
            val reminderId = intent.getStringExtra(EXTRA_REMINDER_ID) ?: ""
            if (reminderId.isEmpty()) {
                Log.w(TAG, "No reminder ID provided. Stopping.")
                stopSelf()
                return START_NOT_STICKY
            }

            val store = NativeReminderStore.getInstance(this)
            val reminder = store.getReminder(reminderId)
            if (reminder == null) {
                Log.w(TAG, "Reminder $reminderId not found in NativeReminderStore. Stopping.")
                stopSelf()
                return START_NOT_STICKY
            }

            pendingReminder = reminder
            currentNotificationId = NativeAlarmScheduler.getRequestCode(reminder.id)

            // Reset repeat state and determine target repetitions
            isStopped = false
            currentRepeatIndex = 0
            targetRepeatCount = if (reminder.speechRepeatCount <= 0) 1 else reminder.speechRepeatCount
            Log.d(TAG, "Configured speech: targetRepeatCount=$targetRepeatCount, showOverLockScreen=${reminder.showOverLockScreen}")

            // 1. Post Foreground Notification immediately
            val notification = buildAlarmNotification(reminder)
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    ServiceCompat.startForeground(
                        this,
                        currentNotificationId,
                        notification,
                        ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
                    )
                } else {
                    startForeground(currentNotificationId, notification)
                }
                Log.d(TAG, "Foreground notification posted for reminder ${reminder.id}")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start foreground service: ${e.message}")
            }

            // 2. Set safety timeout so service never runs indefinitely
            // Scales with repeat count (up to 5 minutes maximum for continuous/high repeats)
            safetyTimeoutRunnable?.let { mainHandler.removeCallbacks(it) }
            val totalTimeoutMillis = if (targetRepeatCount > 1) {
                (targetRepeatCount * 25000L + 20000L).coerceAtMost(300000L)
            } else {
                BASE_TIMEOUT_MILLIS
            }
            val timeout = Runnable {
                Log.w(TAG, "Safety timeout reached ($totalTimeoutMillis ms). Shutting down.")
                cleanupAndStop()
            }
            safetyTimeoutRunnable = timeout
            mainHandler.postDelayed(timeout, totalTimeoutMillis)

            // 3. Request Audio Focus
            requestAlarmAudioFocus()

            // 4. Initialize TTS
            initTextToSpeech()
        }

        return START_NOT_STICKY
    }

    private fun createNotificationChannelIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "High-priority full-screen alarms with spoken task reminders"
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500, 1000)
                setSound(
                    android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI,
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setBypassDnd(true)
            }
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    private fun buildAlarmNotification(reminder: NativeReminder): Notification {
        // Full screen intent to MainActivity
        val fullScreenIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("reminderId", reminder.id)
            putExtra("title", reminder.title)
            putExtra("spokenMessage", reminder.spokenMessage)
            putExtra("voicePersonality", reminder.voicePersonality)
            putExtra("fromAlarm", true)
            putExtra("showOverLockScreen", reminder.showOverLockScreen)
        }
        val fullScreenPendingIntent = PendingIntent.getActivity(
            this,
            NativeAlarmScheduler.getRequestCode(reminder.id),
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Stop Action PendingIntent
        val stopIntent = Intent(this, NativeAlarmReceiver::class.java).apply {
            action = NativeAlarmReceiver.ACTION_STOP
            putExtra(NativeAlarmReceiver.EXTRA_REMINDER_ID, reminder.id)
        }
        val stopPendingIntent = PendingIntent.getBroadcast(
            this,
            NativeAlarmScheduler.getRequestCode(reminder.id) + 1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Snooze Action PendingIntent
        val snoozeIntent = Intent(this, NativeAlarmReceiver::class.java).apply {
            action = NativeAlarmReceiver.ACTION_SNOOZE
            putExtra(NativeAlarmReceiver.EXTRA_REMINDER_ID, reminder.id)
        }
        val snoozePendingIntent = PendingIntent.getBroadcast(
            this,
            NativeAlarmScheduler.getRequestCode(reminder.id) + 2,
            snoozeIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("⏰ " + reminder.title)
            .setContentText(reminder.spokenMessage)
            .setStyle(NotificationCompat.BigTextStyle().bigText("\"${reminder.spokenMessage}\"\nVoice: ${reminder.voicePersonality.uppercase()}"))
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(fullScreenPendingIntent)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopPendingIntent)
            .addAction(android.R.drawable.ic_popup_reminder, "Snooze (10m)", snoozePendingIntent)

        // Only launch the full-screen activity over the lock screen if user preference permits it
        if (reminder.showOverLockScreen) {
            builder.setFullScreenIntent(fullScreenPendingIntent, true)
        }

        return builder.build()
    }

    private fun requestAlarmAudioFocus() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val playbackAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()

                val request = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                    .setAudioAttributes(playbackAttributes)
                    .setAcceptsDelayedFocusGain(false)
                    .setOnAudioFocusChangeListener { focusChange ->
                        Log.d(TAG, "Audio focus changed: $focusChange")
                    }
                    .build()

                audioFocusRequest = request
                val result = audioManager?.requestAudioFocus(request)
                Log.d(TAG, "Audio focus request result: $result")
            } else {
                @Suppress("DEPRECATION")
                val result = audioManager?.requestAudioFocus(
                    { focusChange -> Log.d(TAG, "Audio focus changed: $focusChange") },
                    AudioManager.STREAM_ALARM,
                    AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK
                )
                Log.d(TAG, "Legacy audio focus request result: $result")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting audio focus: ${e.message}")
        }
    }

    private fun releaseAlarmAudioFocus() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                audioFocusRequest?.let { audioManager?.abandonAudioFocusRequest(it) }
            } else {
                @Suppress("DEPRECATION")
                audioManager?.abandonAudioFocus(null)
            }
            Log.d(TAG, "Audio focus released")
        } catch (e: Exception) {
            Log.e(TAG, "Error releasing audio focus: ${e.message}")
        } finally {
            audioFocusRequest = null
        }
    }

    private fun initTextToSpeech() {
        Log.d(TAG, "Initializing native Android TextToSpeech...")
        tts = TextToSpeech(applicationContext, this)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            isTtsInitialized = true
            Log.d(TAG, "TextToSpeech initialized successfully")
            speakPendingReminder()
        } else {
            Log.e(TAG, "TextToSpeech initialization failed with status $status")
            // Fallback notification already visible, stop after brief grace period
            mainHandler.postDelayed({ cleanupAndStop() }, 5000L)
        }
    }

    private fun speakPendingReminder() {
        val reminder = pendingReminder ?: run {
            Log.w(TAG, "speakPendingReminder called with null reminder")
            cleanupAndStop()
            return
        }

        val speech = tts ?: run {
            Log.w(TAG, "TTS instance is null")
            cleanupAndStop()
            return
        }

        try {
            // Configure language
            val locale = try {
                Locale.forLanguageTag(reminder.language)
            } catch (e: Exception) {
                Locale.US
            }
            val langResult = speech.setLanguage(locale)
            if (langResult == TextToSpeech.LANG_MISSING_DATA || langResult == TextToSpeech.LANG_NOT_SUPPORTED) {
                Log.w(TAG, "Language ${reminder.language} not supported. Falling back to default Locale.")
                speech.language = Locale.getDefault()
            }

            // Configure Pitch according to Personality
            val pitch = when (reminder.voicePersonality.lowercase()) {
                "max" -> 0.85f
                "atlas" -> 0.95f
                "echo" -> 1.15f
                "nova" -> 1.05f
                else -> reminder.speechPitch
            }
            speech.setPitch(pitch)

            // Configure Speech Rate
            val rate = when (reminder.voicePersonality.lowercase()) {
                "max" -> 0.95f
                "atlas" -> 1.0f
                "echo" -> 0.90f
                "nova" -> 1.0f
                else -> reminder.speechRate
            }
            speech.setSpeechRate(rate)

            // Configure AudioAttributes on TTS
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                speech.setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                        .build()
                )
            }

            // Set UtteranceProgressListener to detect speech completion and handle repetitions
            val utteranceId = "taskly_utterance_${reminder.id}_${currentRepeatIndex}"
            speech.setOnUtteranceProgressListener(object : UtteranceProgressListener() {
                override fun onStart(id: String?) {
                    Log.i(TAG, "Native speech playback started (pass ${currentRepeatIndex + 1} of $targetRepeatCount): \"${reminder.spokenMessage}\"")
                }

                override fun onDone(id: String?) {
                    Log.i(TAG, "Native speech playback completed for $id (pass ${currentRepeatIndex + 1} of $targetRepeatCount)")
                    mainHandler.post {
                        if (isStopped) return@post

                        currentRepeatIndex++
                        if (currentRepeatIndex < targetRepeatCount) {
                            Log.d(TAG, "Scheduling speech repeat ${currentRepeatIndex + 1} of $targetRepeatCount in 2500ms...")
                            val nextRepeat = Runnable {
                                if (!isStopped) {
                                    speakPendingReminder()
                                }
                            }
                            repeatRunnable = nextRepeat
                            mainHandler.postDelayed(nextRepeat, 2500L)
                        } else {
                            Log.i(TAG, "All $targetRepeatCount speech repetitions complete. Shutting down.")
                            cleanupAndStop()
                        }
                    }
                }

                @Deprecated("Deprecated in Java")
                override fun onError(id: String?) {
                    Log.e(TAG, "Native speech playback error for $id")
                    mainHandler.post {
                        cleanupAndStop()
                    }
                }

                override fun onError(id: String?, errorCode: Int) {
                    Log.e(TAG, "Native speech playback error for $id (code $errorCode)")
                    mainHandler.post {
                        cleanupAndStop()
                    }
                }
            })

            // Queue the speech utterance over STREAM_ALARM
            val params = Bundle().apply {
                putInt(TextToSpeech.Engine.KEY_PARAM_STREAM, AudioManager.STREAM_ALARM)
                putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, 1.0f)
            }

            Log.i(TAG, "Speaking reminder aloud (pass ${currentRepeatIndex + 1}/$targetRepeatCount): \"${reminder.spokenMessage}\"")
            speech.speak(reminder.spokenMessage, TextToSpeech.QUEUE_FLUSH, params, utteranceId)

        } catch (e: Exception) {
            Log.e(TAG, "Exception during TTS playback: ${e.message}")
            cleanupAndStop()
        }
    }

    private fun cleanupAndStop() {
        Log.d(TAG, "cleanupAndStop called")
        isStopped = true

        repeatRunnable?.let {
            mainHandler.removeCallbacks(it)
            repeatRunnable = null
        }

        safetyTimeoutRunnable?.let {
            mainHandler.removeCallbacks(it)
            safetyTimeoutRunnable = null
        }

        try {
            tts?.stop()
            tts?.shutdown()
            tts = null
            isTtsInitialized = false
        } catch (e: Exception) {
            Log.e(TAG, "Error shutting down TTS: ${e.message}")
        }

        releaseAlarmAudioFocus()
        NativeAlarmReceiver.releaseWakeLock()

        // Stop foreground and remove notification
        try {
            stopForeground(STOP_FOREGROUND_REMOVE)
            val manager = NotificationManagerCompat.from(this)
            manager.cancel(currentNotificationId)
        } catch (e: Exception) {
            Log.e(TAG, "Error removing foreground notification: ${e.message}")
        }

        stopSelf()
        Log.i(TAG, "NativeSpeechService fully terminated.")
    }

    override fun onDestroy() {
        super.onDestroy()
        cleanupAndStop()
        Log.d(TAG, "NativeSpeechService destroyed")
    }
}

