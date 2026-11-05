# TASKLY Phase 2: Smart Reminders & Android Alarm System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement reliable Android exact alarm scheduling, notification channels, background wakeup, spoken reminder configuration, dedicated full-screen alarm interface with sound waveform, snooze/stop actions, and complete Drift database synchronization.

**Architecture:** Service-oriented alarm and notification architecture integrated with Drift local SQLite and Riverpod state management. Exact alarms scheduled through native `AlarmManager` via `flutter_local_notifications` with timezone awareness and boot receiver restoration.

**Tech Stack:** Flutter 3.47+, Dart 3.13+, Flutter Local Notifications 18+, Timezone 0.10+, Drift 2.26+, Flutter Riverpod 2.6+, Android AlarmManager & Notification Channels.

---

### Task 1: Android Native Permissions & Notification Service

**Files:**
- Modify: `android/app/src/main/AndroidManifest.xml`
- Create: `lib/services/permission_service.dart`
- Create: `lib/services/notification_service.dart`
- Create: `lib/services/alarm_service.dart`
- Create: `test/unit/alarm_calculation_test.dart`

- [ ] **Step 1: Write unit tests for alarm time & relative duration calculations**

Create `test/unit/alarm_calculation_test.dart` testing relative durations (+15m, +1h, +2h), unique integer notification ID generation from UUIDs, and overdue detection.

- [ ] **Step 2: Update `AndroidManifest.xml` with required background permissions**

Add `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `POST_NOTIFICATIONS`, `WAKE_LOCK`, `RECEIVE_BOOT_COMPLETED`, `USE_FULL_SCREEN_INTENT`, and `VIBRATE`.

- [ ] **Step 3: Implement `notification_service.dart`**

Initialize `FlutterLocalNotificationsPlugin`, configure Android alarm channel with `Importance.max` and `Priority.high`, configure default reminder channel, and handle notification launch payloads.

- [ ] **Step 4: Implement `alarm_service.dart`**

Implement exact scheduling via `zonedSchedule(AndroidScheduleMode.exactAllowWhileIdle)`, alarm cancellation, snooze calculation, and notification ID hashing.

- [ ] **Step 5: Run unit tests**

Run: `flutter test test/unit/alarm_calculation_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit Task 1**

```bash
git add android/app/src/main/AndroidManifest.xml lib/services/ test/unit/alarm_calculation_test.dart
git commit -m "feat: implement Android alarm permissions, notification channels, and AlarmService"
```

---

### Task 2: Reminders Repository & Database Alarm Synchronization

**Files:**
- Create: `lib/features/reminders/data/reminders_repository.dart`
- Create: `lib/features/alarms/data/alarm_history_repository.dart`
- Create: `test/unit/reminders_repository_test.dart`

- [ ] **Step 1: Write repository unit test**

Create `test/unit/reminders_repository_test.dart` using in-memory Drift SQLite verifying CRUD operations and mock alarm synchronization.

- [ ] **Step 2: Implement `reminders_repository.dart`**

Implement methods for `getAllReminders()`, `getUpcomingReminders()`, `createReminder()`, `updateReminder()`, `deleteReminder()`, and `toggleReminder()`. Ensure database mutations directly invoke `AlarmService.scheduleReminder()` or `AlarmService.cancelReminder()`.

- [ ] **Step 3: Implement `alarm_history_repository.dart`**

Implement methods for `logAlarmAction()`, `getHistory()`, and `clearHistory()`.

- [ ] **Step 4: Run repository tests**

Run: `flutter test test/unit/reminders_repository_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit Task 2**

```bash
git add lib/features/reminders/data/ lib/features/alarms/data/ test/unit/reminders_repository_test.dart
git commit -m "feat: implement reminders repository with database alarm synchronization"
```

---

### Task 3: Create & Edit Reminder Bottom Sheet

**Files:**
- Create: `lib/features/reminders/presentation/widgets/relative_duration_chips.dart`
- Create: `lib/features/reminders/presentation/widgets/voice_personality_selector.dart`
- Create: `lib/features/reminders/presentation/create_reminder_sheet.dart`
- Create: `test/widget/create_reminder_test.dart`

- [ ] **Step 1: Build `relative_duration_chips.dart`**

Allows one-tap quick scheduling: `+15m`, `+30m`, `+1h`, `+2h`, `+3h`, or Custom Date/Time.

- [ ] **Step 2: Build `voice_personality_selector.dart`**

Visual chips for Nova (friendly indigo), Max (energetic orange), Atlas (professional blue), and Echo (simple emerald) with preview audio trigger.

- [ ] **Step 3: Build `create_reminder_sheet.dart`**

Combines Title, Description, Relative/Custom Schedule, Voice Personality, Dynamic Spoken Text Preview, Speech Rate & Pitch sliders, and Save action.

- [ ] **Step 4: Write widget test for Create Reminder Sheet**

Create `test/widget/create_reminder_test.dart` verifying all form fields, relative time chips, voice selection, and save trigger.

- [ ] **Step 5: Run widget test**

Run: `flutter test test/widget/create_reminder_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit Task 3**

```bash
git add lib/features/reminders/presentation/ test/widget/create_reminder_test.dart
git commit -m "feat: implement create reminder sheet with relative duration and voice personality"
```

---

### Task 4: Dedicated Full-Screen Alarm Screen with Animated Waveform

**Files:**
- Create: `lib/features/alarms/presentation/widgets/waveform_visualizer.dart`
- Create: `lib/features/alarms/presentation/alarm_screen.dart`
- Create: `test/widget/alarm_screen_test.dart`

- [ ] **Step 1: Build `waveform_visualizer.dart`**

Custom painter animated with `AnimationController` generating dynamic audio waveform bars pulsing in sync with voice personality color.

- [ ] **Step 2: Build `alarm_screen.dart`**

Full-screen dedicated alarm interface displaying large reminder title, current time, voice personality tag, waveform animation, spoken reminder text, Stop button, Snooze button (10m), Complete button, and Reschedule action.

- [ ] **Step 3: Write widget test for Alarm Screen**

Create `test/widget/alarm_screen_test.dart` verifying waveform rendering, title presentation, and Stop/Snooze/Complete callbacks.

- [ ] **Step 4: Run alarm screen widget tests**

Run: `flutter test test/widget/alarm_screen_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit Task 4**

```bash
git add lib/features/alarms/presentation/ test/widget/alarm_screen_test.dart
git commit -m "feat: implement dedicated alarm screen with animated waveform visualizer"
```

---

### Task 5: Alarm History Screen & Dashboard Integration

**Files:**
- Create: `lib/features/alarms/presentation/alarm_history_screen.dart`
- Modify: `lib/features/dashboard/presentation/dashboard_screen.dart`
- Modify: `lib/shared/widgets/quick_action_sheet.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Build `alarm_history_screen.dart`**

Displays historical log of triggered alarms, actions taken (Completed, Snoozed, Stopped), timestamps, and spoken messages.

- [ ] **Step 2: Connect Create Reminder sheet to QuickActionSheet and Dashboard shortcuts**

Clicking "Spoken Reminder" in QuickActionSheet or "New Reminder" opens `CreateReminderSheet`.

- [ ] **Step 3: Add routes for `/alarm` and `/alarm-history` in `app_router.dart`**

Register routes so notifications and dashboard can navigate directly to the Alarm Screen or History.

- [ ] **Step 4: Commit Task 5**

```bash
git add lib/features/alarms/ lib/features/dashboard/ lib/shared/ lib/core/router/
git commit -m "feat: integrate alarm history and wire reminder creation flows"
```

---

### Task 6: Formatting, Analysis, Full Test Suite & Verification

- [ ] **Step 1: Format codebase**
Run: `dart format .`
Expected: 0 errors.

- [ ] **Step 2: Run static analysis**
Run: `flutter analyze`
Expected: 0 issues found.

- [ ] **Step 3: Run full test suite**
Run: `flutter test`
Expected: 100% tests passing.

- [ ] **Step 4: Commit Phase 2 Completion**
```bash
git commit -m "feat: finalize Phase 2 smart reminders and alarm system"
```

