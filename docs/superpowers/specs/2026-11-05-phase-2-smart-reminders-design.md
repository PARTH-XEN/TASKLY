# TASKLY — Phase 2: Smart Reminder & Android Alarm System Specification

## 1. Executive Summary

Phase 2 builds the core USP of TASKLY:
> **Smart Reminders with Spoken Tasks and Reliable Android Alarm Execution.**

Users can create, edit, schedule, snooze, and complete reminders with relative or absolute timestamps, customizable spoken reminder prompts, voice personality tags (Nova, Max, Atlas, Echo), and dedicated full-screen alarm interfaces with audio waveforms.

---

## 2. Android Reliability Architecture

### 2.1 Native Permissions & Declarations
To ensure alarms fire when the app is in the background, screen locked, or after device reboot:
- `android.permission.RECEIVE_BOOT_COMPLETED`: Automatically reschedule active reminders after phone reboot.
- `android.permission.SCHEDULE_EXACT_ALARM`: Android 12+ exact alarm scheduling.
- `android.permission.USE_EXACT_ALARM`: For alarm apps on Android 13+.
- `android.permission.POST_NOTIFICATIONS`: Android 13+ runtime notification permission.
- `android.permission.WAKE_LOCK`: Temporarily wake CPU to trigger alarm notification and sound.
- `android.permission.USE_FULL_SCREEN_INTENT`: Display full-screen alarm screen over keyguard when device is locked.
- `android.permission.VIBRATE`: Haptic alarm vibration pattern.

### 2.2 Notification Channels
1. **`taskly_alarm_channel`**:
   - Importance: `Importance.max`
   - Priority: `Priority.high`
   - FullScreenIntent: `true`
   - Category: `AndroidNotificationCategory.alarm`
   - Audio attributes: `AudioAttributesUsage.alarm`
2. **`taskly_reminder_channel`**:
   - Importance: `Importance.default`
   - Priority: `Priority.default`

### 2.3 Rescheduling & Background Speech Strategy
- Exact alarms are scheduled using `flutter_local_notifications` with `AndroidScheduleMode.exactAllowWhileIdle` and `timezone.TZDateTime`.
- BootReceiver: On device reboot, `flutter_local_notifications` invokes scheduled item persistence. We also provide a verification check on app launch that re-syncs database reminders with active schedules.
- Background TTS: When the alarm fires, the notification launches the dedicated `AlarmScreen` via full-screen intent or notification tap, triggering immediate TTS voice playback. If background audio is restricted by OEM power management, the alarm notification prominently displays the reminder title and spoken message text, ensuring zero reminders are silently dropped.

---

## 3. Data Models & Operations

### 3.1 Reminder CRUD with Synchronization
- **Create**: Inserts record into Drift `reminders` table and computes unique integer ID from UUID hash for Android PendingIntent. Calls `AlarmService.scheduleReminder()`.
- **Update**: Updates Drift record, cancels previous scheduled alarm ID, and reschedules with new timestamp.
- **Delete**: Removes record from Drift and calls `AlarmService.cancelReminder()`.
- **Toggle Active**: When toggled off, cancels alarm. When toggled on, checks if scheduledAt is in the future and schedules.

### 3.2 Spoken Message Generation
If user does not provide custom spoken text, TASKLY dynamically generates:
> *"Hey! It's time to [Title]. Let's get started!"*

### 3.3 Snooze & Reschedule
- Snooze: Reschedules alarm for `DateTime.now().add(Duration(minutes: snoozeDurationMinutes))` (default 10 min), logs action in `alarm_history`.
- Stop: Cancels ringing sound/TTS, logs `actionTaken: 'stopped'`.
- Complete: Marks linked task (if any) as completed, logs `actionTaken: 'completed'`.

---

## 4. UI/UX Design (Thumb-Zone & Accessibility)

1. **Create Reminder Bottom Sheet**:
   - Relative duration quick pills: `+15 min`, `+30 min`, `+1 hour`, `+2 hours`, `+3 hours`.
   - Date & Time pickers with formatted previews.
   - Voice personality chips (Nova, Max, Atlas, Echo).
   - Dynamic spoken text quote preview bubble.
   - Speech rate & pitch sliders.
   - Recurrence selector (Never, Daily, Weekdays, Weekly).
2. **Dedicated Alarm Screen**:
   - Large prominent typography for reminder title.
   - Live time display and scheduled time banner.
   - Custom-painted animated sound waveform visualizing speech.
   - High-contrast, 48dp+ thumb-zone action buttons:
     - **Stop** (Outlined danger button)
     - **Snooze** (Secondary elevated button with duration pill)
     - **Complete Task** (Primary prominent button)
3. **Alarm History Screen**:
   - Timeline of triggered, snoozed, stopped, and completed alarms.
