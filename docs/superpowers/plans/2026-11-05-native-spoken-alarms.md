# Native Android Spoken Alarms Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use systematic-debugging and flutter-expert to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the critical reminder bug where reminders only display notifications without speaking, by implementing a native Android AlarmManager, BroadcastReceiver, Foreground Service with native TextToSpeech, persistent storage, and boot receiver.

**Architecture:** 
- **Flutter Layer (`AlarmService`, `RemindersRepository`):** Updates Drift DB and calls `MethodChannel('taskly/native')` to schedule, cancel, or snooze alarms.
- **Native Android Layer (`com.example.taskly`):**
  - `NativeReminderStore`: SharedPreferences-backed JSON storage for native access even when Flutter is terminated.
  - `NativeAlarmScheduler`: Exact alarm scheduling via `AlarmManager.setExactAndAllowWhileIdle()` (with inexact fallback).
  - `NativeAlarmReceiver`: Dedicated `BroadcastReceiver` that captures alarm triggers, acquires a `WakeLock`, and starts `NativeSpeechService`.
  - `NativeSpeechService`: Android `ForegroundService` (type `mediaPlayback`) that posts high-priority lock-screen notification, requests AudioFocus (`USAGE_ALARM`), initializes `android.speech.tts.TextToSpeech`, speaks the message aloud, and stops after speech completion.
  - `NativeBootReceiver`: Restores pending alarms after device reboot.
  - `MainActivity`: Full-screen lock-screen flags and MethodChannel handling.

**Tech Stack:** Kotlin, Android SDK 34 (Foreground Service `mediaPlayback`), `android.speech.tts.TextToSpeech`, `android.app.AlarmManager`, Flutter MethodChannel, Drift, Riverpod.

---

### Task 1: Permissions and Manifest Configuration

**Files:**
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `android/app/build.gradle.kts` (if extra dependencies needed)

- [ ] **Step 1: Update AndroidManifest.xml permissions**
  Add required permissions:
  - `FOREGROUND_SERVICE`
  - `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
  - `SCHEDULE_EXACT_ALARM`
  - `USE_EXACT_ALARM`
  - `POST_NOTIFICATIONS`
  - `WAKE_LOCK`
  - `USE_FULL_SCREEN_INTENT`
  - `RECEIVE_BOOT_COMPLETED`
  - `VIBRATE`

- [ ] **Step 2: Register Native Components in AndroidManifest.xml**
  - Register `NativeSpeechService` with `android:foregroundServiceType="mediaPlayback"`.
  - Register `NativeAlarmReceiver` with actions `ACTION_FIRE_ALARM`, `ACTION_STOP`, `ACTION_SNOOZE`.
  - Register `NativeBootReceiver` with `BOOT_COMPLETED` and reboot actions.

---

### Task 2: Native Android Persistence and Models

**Files:**
- Create: `android/app/src/main/kotlin/com/example/taskly/NativeReminder.kt`
- Create: `android/app/src/main/kotlin/com/example/taskly/NativeReminderStore.kt`

- [ ] **Step 1: Implement NativeReminder data model**
  Include `id`, `title`, `spokenMessage`, `scheduledAtMillis`, `voicePersonality`, `speechRate`, `speechPitch`, `language`, `ttsVoiceName`, `isEnabled`. Include JSON serialization/deserialization.

- [ ] **Step 2: Implement NativeReminderStore**
  Provide SharedPreferences storage (`taskly_native_reminders`) with methods:
  - `saveReminder(reminder: NativeReminder)`
  - `getReminder(id: String): NativeReminder?`
  - `getAllReminders(): List<NativeReminder>`
  - `removeReminder(id: String)`
  - `clearExpired(currentTimeMillis: Long)`

---

### Task 3: Native Alarm Scheduling and BroadcastReceivers

**Files:**
- Create: `android/app/src/main/kotlin/com/example/taskly/NativeAlarmScheduler.kt`
- Create: `android/app/src/main/kotlin/com/example/taskly/NativeAlarmReceiver.kt`
- Create: `android/app/src/main/kotlin/com/example/taskly/NativeBootReceiver.kt`

- [ ] **Step 1: Implement NativeAlarmScheduler**
  - Calculate unique requestCode from `id.hashCode() and 0x7FFFFFFF`.
  - Check exact alarm permission via `alarmManager.canScheduleExactAlarms()` (SDK 31+).
  - Schedule with `setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, ...)` or fallback to `setAndAllowWhileIdle(...)`.
  - Implement `cancelAlarm(id: String)`.

- [ ] **Step 2: Implement NativeAlarmReceiver**
  - On `ACTION_FIRE_ALARM`: Acquire `WakeLock` (max 60 seconds) with `ACQUIRE_CAUSES_WAKEUP`.
  - Call `ContextCompat.startForegroundService()` with `NativeSpeechService`.
  - On `ACTION_STOP`: Stop speech service and dismiss notification.
  - On `ACTION_SNOOZE`: Stop speech service, reschedule for +10 minutes, show notification confirmation.

- [ ] **Step 3: Implement NativeBootReceiver**
  - On `ACTION_BOOT_COMPLETED`: Read all reminders from `NativeReminderStore`, reschedule future reminders via `NativeAlarmScheduler`.

---

### Task 4: Native Foreground Service and TextToSpeech Engine

**Files:**
- Create: `android/app/src/main/kotlin/com/example/taskly/NativeSpeechService.kt`

- [ ] **Step 1: Implement Foreground Notification with Actions**
  - Ensure notification channel `taskly_alarm_channel_v2` is configured with `IMPORTANCE_MAX` and `AudioAttributes.USAGE_ALARM`.
  - Build notification with title, spoken message, full-screen intent to `MainActivity`, Stop action, and Snooze action.
  - Call `ServiceCompat.startForeground(this, NOTIFICATION_ID, notification, FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)`.

- [ ] **Step 2: Implement Audio Focus Management**
  - Request audio focus via `AudioManager` using `USAGE_ALARM` or `USAGE_ASSISTANCE_ACCESSIBILITY`.
  - Handle audio focus granted/failed callbacks.

- [ ] **Step 3: Implement Native Android TextToSpeech**
  - Initialize `android.speech.tts.TextToSpeech`.
  - Wait for `onInit(status)`.
  - If failure: Log error, show fallback alert, call `stopSelf()`.
  - If success:
    - Apply language and personality voice traits (pitch & rate).
    - Match specific TTS voice if available.
    - Set `UtteranceProgressListener`.
    - Speak `spokenMessage` using `tts.speak(..., TextToSpeech.QUEUE_FLUSH, params, utteranceId)`.
  - In `onDone` / `onError`: Release audio focus, release wake lock, stop foreground, and call `stopSelf()`.

- [ ] **Step 4: Implement Service Resource Cleanup**
  - In `onDestroy()`: Shutdown TTS, release wake lock, abandon audio focus.

---

### Task 5: Platform Channel Integration in MainActivity

**Files:**
- Modify: `android/app/src/main/kotlin/com/example/taskly/MainActivity.kt`

- [ ] **Step 1: Configure Lock-Screen Display in MainActivity**
  - Implement `setShowWhenLocked(true)` and `setTurnScreenOn(true)` (or window flags for older APIs).

- [ ] **Step 2: Wire MethodChannel Handler**
  Expose methods:
  - `scheduleNativeAlarm(Map)`: saves to store and schedules with AlarmManager.
  - `cancelNativeAlarm(String id)`: removes from store and cancels in AlarmManager.
  - `snoozeNativeAlarm(String id, int minutes)`: reschedules.
  - `stopNativeSpeech()`: stops ongoing speech service.
  - `getLocalTimezone()`: existing timezone query.
  - `canScheduleExactAlarms()`: returns boolean.

---

### Task 6: Flutter AlarmService and UI Integration

**Files:**
- Modify: `lib/services/alarm_service.dart`
- Modify: `lib/services/permission_service.dart`
- Modify: `lib/features/settings/presentation/settings_screen.dart`
- Modify: `lib/features/alarms/presentation/alarm_screen.dart`

- [ ] **Step 1: Update AlarmService in Flutter**
  - Forward `scheduleReminder`, `cancelReminder`, `snoozeReminder` to `taskly/native` MethodChannel when on Android.
  - Gracefully preserve unit-test compatibility with `defaultTargetPlatform` check.

- [ ] **Step 2: Update Settings Demo Alarm**
  - Use native channel to schedule the 5s demo alarm so it exercises the real background receiver, wake lock, foreground service, and native TTS even when screen is locked or app closed.

- [ ] **Step 3: Verify and Update Permission Checks**
  - Check exact alarm permission and notification permission.

---

### Task 7: Verification and Quality Assurance

**Files:**
- Run test suite: `flutter test`
- Run static analysis: `flutter analyze`
- Build Android debug APK: `flutter build apk --debug`

- [ ] **Step 1: Verify static analysis**
  Ensure 0 errors, 0 warnings.

- [ ] **Step 2: Run all unit and widget tests**
  Ensure 64/64 tests pass.

- [ ] **Step 3: Build Android Debug APK**
  Ensure clean compilation.

- [ ] **Step 4: Device Acceptance Testing & Inspection**
  Verify background speech on locked screen, app closed, screen off, and reboot.

