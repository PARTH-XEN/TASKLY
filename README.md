# TASKLY 🎯

> **"Don't just remind me when. Remind me what."**

An Android-first, 100% offline-first personal productivity and smart reminder application built with Flutter & Dart. Spoken task reminders speak your activities aloud at the exact scheduled moment using offline device Text-To-Speech (TTS) voice personalities.

---

## 🌟 Key Features

### 1. Spoken Task Reminders (Core USP)
- **Voice Personalities**: 4 predefined offline device TTS configurations:
  - **Nova**: Friendly, calm, and encouraging.
  - **Max**: Energetic, enthusiastic, and motivating.
  - **Atlas**: Professional, clear, and direct.
  - **Echo**: Simple, minimal, and straightforward.
- **Dynamic Voice Discovery**: Detects all installed system TTS engines, locales, and voices without remote dependencies.
- **Speech Tuning**: Real-time rate (0.2x–1.0x) and pitch (0.5x–1.5x) adjustment with live audio preview cards.
- **Dedicated Alarm Screen**: Custom animated audio waveform visualizer, live digital clock, Stop, Snooze (10m), Complete, and Reschedule actions.
- **Android AlarmManager**: Full background wake-up using exact alarms (`exactAllowWhileIdle`), high-priority notification channels, and boot recovery receivers.

### 2. Task Management & To-Do List
- **Reactive Drift & SQLite Storage**: High-performance local database with Riverpod stream providers.
- **Multi-Filter System**: Filter by `All`, `Today`, `Upcoming`, `Overdue`, and `Completed`.
- **Category & Priority Tagging**: High (Red), Medium (Amber), Low (Blue) with WCAG accessible contrast.
- **Live Search**: Instant keyword filtering across task titles and descriptions.
- **Interactive Gestures**: Animated checkmarks, strikethrough typography, and swipe-to-delete.

### 3. Calendar & Important Dates
- **TableCalendar Integration**: Month and Week views with event dots and date selection.
- **Strict Alarm Distinction (`hasAlarm`)**:
  - `hasAlarm == true`: Schedules exact spoken voice alarm with a prominent **Spoken Alarm** badge.
  - `hasAlarm == false`: Saved as a silent calendar date/milestone with a **Silent Marker** badge (no notifications/alarms).
- **Daily Agenda**: Chronological event schedule for the selected day.

### 4. Wishlist & Personal Goals
- **Categories**: Goals, Products, Skills, Projects, and Travel.
- **Target Date Countdown**: Real-time remaining days indicator (e.g. `45 days left`).
- **Goal Completion**: One-tap completion toggle with priority pills.

### 5. Pomodoro Focus Timer
- **Preset Durations**: 15 min, 25 min (standard Pomodoro), and 45 min deep work.
- **Circular Progress Countdown**: Clean visual countdown ring with Play, Pause, Reset, and Finish Early controls.
- **Session Logging**: Persists focus minutes into SQLite to track daily productivity.

### 6. Dynamic Dashboard & Quick Action Launcher
- **Live Productive Overview**: Real-time pending vs. completed task counters and completion percentage.
- **Upcoming Reminders**: Next reminder USP card and chronological reminder list.
- **Quick Action FAB**: One-tap modal to immediately create reminders, tasks, calendar events, wishlist goals, or start focus sessions.

---

## 🛡️ Free & Open-Source Policy (Zero Paid APIs)

TASKLY operates strictly under free, open-source, and offline principles:
- **Zero Paid AI APIs**: No OpenAI, Anthropic, Gemini, ElevenLabs, or cloud chatbot subscriptions.
- **100% Offline-First**: All data is persisted locally in SQLite via Drift; all voice synthesis uses device TTS.
- **Attributions**: All packages and licenses are cataloged in [`ATTRIBUTIONS.md`](ATTRIBUTIONS.md).

---

## 🏗️ Architecture & Technology Stack

```
lib/
├── core/
│   ├── database/        # Drift SQLite database, tables, schema & providers
│   ├── router/          # GoRouter 5-tab indexed navigation shell
│   └── theme/           # AppColors, AppSpacing, AppTypography, AppTheme
├── features/
│   ├── alarms/          # Alarm screen, animated waveform, history logging
│   ├── calendar/        # TableCalendar, daily agenda, hasAlarm distinction
│   ├── dashboard/       # Home screen, live task counters, next reminder card
│   ├── productivity/    # Focus timer sheet, session repository & statistics
│   ├── reminders/       # Spoken reminder creation sheet, duration pills
│   ├── settings/        # Theme switcher, exact alarm permissions, app info
│   ├── tasks/           # Task list, search, filter chips, item tile, dialog
│   ├── voice/           # Nova/Max/Atlas/Echo personalities, TTS tuning
│   └── wishlist/        # Category cards, target dates, wishlist repository
├── services/            # AlarmService, NotificationService, TtsService, PermissionService
└── shared/              # QuickActionSheet, main navigation shell
```

- **Framework**: Flutter 3.x / Dart 3.x
- **State Management**: Flutter Riverpod 2.6.x
- **Navigation**: GoRouter 14.8.x
- **Local Database**: Drift 2.26.x + SQLite 3 (`drift_flutter`)
- **Android Notifications & Alarms**: `flutter_local_notifications` 18.0.x + Android AlarmManager
- **Text-to-Speech**: `flutter_tts` 4.2.x (device offline engines)
- **Calendar**: `table_calendar` 3.1.x
- **Date & Formatting**: `intl` 0.20.x + `timezone` 0.10.x

---

## 🧪 Testing & Verification

TASKLY is built with Test-Driven Development (TDD) and verified through automated test suites:

```bash
# Run all unit and widget tests (58 passing tests)
flutter test

# Verify static analysis (0 issues found)
flutter analyze

# Verify code formatting
dart format --set-exit-if-changed .

# Build Android Debug APK
flutter build apk --debug
```

---

## 📄 License

This project is licensed under the MIT License - see the [`ATTRIBUTIONS.md`](ATTRIBUTIONS.md) file for details.
