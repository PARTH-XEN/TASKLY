# TASKLY — Phase 1: Project Foundation & Core Architecture Specification

## 1. Executive Summary

TASKLY is an Android-first, offline-first personal productivity and smart reminder application built with Flutter and Dart. Its key USP is:
> *"Don't just remind me when. Remind me what."* Spoken task reminders using predefined device TTS voice personalities (Nova, Max, Atlas, Echo), with zero reliance on paid APIs, cloud services, or external AI models.

This specification covers **Phase 1: Project Foundation**, establishing the architecture, dependencies, theme system, 5-tab navigation shell, initial dashboard, and Drift SQLite database schema.

---

## 2. Project Context & Environment

- **Framework**: Flutter 3.47.9 (channel stable)
- **Language**: Dart 3.13.7
- **Android Target**: Android SDK 36.0.0 (API 34/35/36 compatible, minSdk 26 for modern notification channels & exact alarms)
- **Operating System**: Windows (host development machine)
- **License Compliance**: 100% Free and Open Source (MIT, Apache 2.0, OFL, BSD). Documented in `ATTRIBUTIONS.md`.

---

## 3. Architecture & Modular Structure

We follow **Feature-First Architecture** with strict layer separation:
- Presentation (UI, widgets, controllers)
- Domain (entities, use cases, business logic)
- Data (Drift DAOs, repositories, local storage models)

```
taskly/
├── android/                         # Android native configurations & manifests
├── assets/
│   ├── icons/                       # Material & Lucide open-source SVG/PNG icons
│   ├── audio/                       # Notification chime sounds (CC0 / permissive)
│   └── fonts/                       # Local fallback fonts (OFL)
├── ATTRIBUTIONS.md                  # Comprehensive open-source attribution log
├── lib/
│   ├── main.dart                    # App entrypoint, dependency overrides, initialization
│   ├── app.dart                     # ProviderScope, MaterialApp.router, theme bindings
│   ├── core/
│   │   ├── constants/               # AppStrings, AssetConstants, StorageKeys
│   │   ├── theme/                   # AppTheme, AppColors, AppTypography, AppSpacing, AppRadius
│   │   ├── router/                  # GoRouter configuration with StatefulShellRoute
│   │   ├── database/                # Drift AppDatabase, DAOs, schema definition
│   │   └── utils/                   # DateTimeFormatters, HapticFeedbackHelper, Logger
│   ├── features/
│   │   ├── dashboard/               # Today overview, next reminder banner, quick actions
│   │   ├── reminders/               # Smart reminders list, creation form, recurrence logic
│   │   ├── alarms/                  # Fullscreen alarm UI, snooze/stop, waveform animation
│   │   ├── voice/                   # Voice personalities (Nova, Max, Atlas, Echo), TTS service
│   │   ├── tasks/                   # To-do lists, categories, priority, completion
│   │   ├── calendar/                # TableCalendar integration, agenda, alarm toggle logic
│   │   ├── wishlist/                # Visual goal & bucket list items, cards
│   │   ├── productivity/            # Completion rings, focus timer, streaks
│   │   └── settings/                # Appearance, voice settings, alarm permissions, about
│   ├── services/
│   │   ├── alarm_service.dart       # Exact alarm scheduling interface
│   │   ├── notification_service.dart# Android notification channels & callbacks
│   │   ├── tts_service.dart         # FlutterTTS device voice synthesizer
│   │   └── permission_service.dart  # POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM helpers
│   └── shared/
│       ├── widgets/                 # TasklyCard, TasklyButton, AppEmptyState, Badge
│       └── models/                  # Shared enums (VoicePersonality, PriorityLevel, TaskCategory)
└── test/
    ├── unit/                        # Database, router, and utility unit tests
    └── widget/                      # Dashboard, navigation, and theme widget tests
```

---

## 4. UI/UX Design System (mobile-uiux-promax compliant)

### Ergonomics & Thumb Zone
- Primary navigation and floating action triggers are within the bottom 60% of the screen.
- Minimum touch target: 48dp on all interactive elements.
- Accessible contrast ratios: WCAG AA/AAA compliant (contrast ≥ 4.5:1 for body text, ≥ 3:1 for large headers).
- Safe Area insets and edge-to-edge support.
- Haptic feedback integration on button taps, tab switches, and quick actions.

### Color Palette

#### Dark Mode (Primary Focus)
- Background: `#0F111A` (Deep Obsidian Charcoal)
- Surface/Card: `#181B28` (Dark Navy Slate)
- Surface Elevated: `#212538`
- Primary Accent: `#818CF8` (Soft Indigo)
- Secondary Accent: `#38BDF8` (Sky Blue)
- Success / Complete: `#34D399` (Emerald)
- Warning / Due Soon: `#FBBF24` (Amber)
- Danger / Overdue: `#F87171` (Coral Red)
- Text Primary: `#F8FAFC`
- Text Secondary: `#94A3B8`
- Text Tertiary: `#64748B`
- Border / Divider: `#272B3F`

#### Light Mode
- Background: `#F8F9FC` (Clean Crisp Canvas)
- Surface/Card: `#FFFFFF` (Pure White)
- Surface Elevated: `#F1F3F9`
- Primary Accent: `#4F46E5` (Vibrant Indigo)
- Secondary Accent: `#0284C7` (Vibrant Cyan)
- Success: `#059669`
- Warning: `#D97706`
- Danger: `#DC2626`
- Text Primary: `#0F172A`
- Text Secondary: `#475569`
- Text Tertiary: `#94A3B8`
- Border / Divider: `#E2E8F0`

---

## 5. Drift Database Schema (SQLite)

All entities persist locally with unique UUID v4 primary keys:

1. **`reminders`**:
   - `id`: Text (UUID, PK)
   - `title`: Text
   - `description`: Text (nullable)
   - `scheduled_at`: DateTime
   - `relative_duration_minutes`: Int (nullable)
   - `voice_personality`: Text ('nova', 'max', 'atlas', 'echo')
   - `tts_voice_name`: Text (nullable)
   - `speech_rate`: Real (default 0.5)
   - `speech_pitch`: Real (default 1.0)
   - `repeat_frequency`: Text ('none', 'daily', 'weekdays', 'weekly', 'monthly')
   - `custom_spoken_message`: Text (nullable)
   - `is_enabled`: Bool (default true)
   - `is_spoken_enabled`: Bool (default true)
   - `created_at`: DateTime
   - `updated_at`: DateTime

2. **`tasks`**:
   - `id`: Text (UUID, PK)
   - `title`: Text
   - `description`: Text (nullable)
   - `category`: Text ('personal', 'work', 'study', 'health', 'projects', 'other')
   - `priority`: Text ('low', 'medium', 'high')
   - `due_date`: DateTime (nullable)
   - `due_time`: Text (nullable)
   - `is_completed`: Bool (default false)
   - `reminder_id`: Text (nullable, FK -> reminders.id)
   - `notes`: Text (nullable)
   - `created_at`: DateTime
   - `updated_at`: DateTime

3. **`calendar_events`**:
   - `id`: Text (UUID, PK)
   - `title`: Text
   - `description`: Text (nullable)
   - `event_date`: DateTime
   - `start_time`: Text (nullable)
   - `end_time`: Text (nullable)
   - `category_color`: Int (ARGB)
   - `is_important_date`: Bool (default false)
   - `has_alarm`: Bool (default false) — *Critical: alarms ONLY scheduled if true*
   - `reminder_id`: Text (nullable, FK -> reminders.id)
   - `created_at`: DateTime

4. **`wishlist_items`**:
   - `id`: Text (UUID, PK)
   - `title`: Text
   - `description`: Text (nullable)
   - `category`: Text ('product', 'skill', 'project', 'travel', 'goal')
   - `priority`: Text ('low', 'medium', 'high')
   - `target_date`: DateTime (nullable)
   - `is_completed`: Bool (default false)
   - `image_path`: Text (nullable)
   - `created_at`: DateTime

5. **`alarm_history`**:
   - `id`: Text (UUID, PK)
   - `reminder_id`: Text
   - `title`: Text
   - `triggered_at`: DateTime
   - `action_taken`: Text ('completed', 'snoozed', 'stopped', 'missed', 'rescheduled')
   - `spoken_message`: Text (nullable)
   - `logged_at`: DateTime

6. **`focus_sessions`**:
   - `id`: Text (UUID, PK)
   - `task_id`: Text (nullable)
   - `duration_minutes`: Int
   - `completed_at`: DateTime
   - `notes`: Text (nullable)

7. **`app_settings`**:
   - `key`: Text (PK)
   - `value`: Text

---

## 6. Navigation System (GoRouter + StatefulShellRoute)

Tabs:
1. `/dashboard` — Today's Overview, USP Spoken Reminder Card, Quick Actions
2. `/tasks` — Task Manager, Filters (All, Today, Upcoming, Overdue, Completed)
3. `/calendar` — Monthly & Weekly View, Important Dates
4. `/wishlist` — Visual Goals & Wishlist
5. `/profile` — Settings, Voice Personality Config, Alarm Defaults

Floating Action Button (Speed Dial):
- Create Spoken Reminder
- Create Task
- Add Calendar Event
- Add Wishlist Item

---

## 7. Quality Assurance Gates for Phase 1

1. `flutter pub get`: clean dependency install.
2. `dart run build_runner build --delete-conflicting-outputs`: Drift generation succeeds.
3. `dart format .`: zero formatting discrepancies.
4. `flutter analyze`: 0 warnings, 0 errors.
5. `flutter test`: 100% passing tests for Theme, Database, DAOs, and Dashboard navigation.

