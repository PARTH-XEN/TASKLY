# Phase 4 & 5: Productivity Suite & Dashboard Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a complete, offline-first productivity suite in TASKLY comprising Tasks (with priority, categories, and filters), Calendar (with `table_calendar`, agenda list, and strict `hasAlarm` toggle distinction), Wishlist (with category cards and target dates), Focus Session Timer (Pomodoro logging), and dynamic Home Dashboard counters.

**Architecture:** Feature-first modular architecture (`lib/features/tasks/`, `lib/features/calendar/`, `lib/features/wishlist/`, `lib/features/productivity/`). Drift SQLite local database as single source of truth with reactive Riverpod streams. Strict isolation of alarms: only calendar events with `hasAlarm == true` trigger `AlarmService`.

**Tech Stack:** Flutter 3.x, Dart 3, Flutter Riverpod 2.6, Drift 2.26, SQLite, table_calendar 3.1, flutter_local_notifications 18.0, intl.

---

## File Structure & Responsibilities

```
lib/
├── features/
│   ├── tasks/
│   │   ├── data/
│   │   │   └── tasks_repository.dart           # Drift SQLite CRUD & reactive Streams for Tasks
│   │   ├── presentation/
│   │   │   ├── tasks_screen.dart               # Task manager screen with search, filters, list
│   │   │   ├── widgets/
│   │   │   │   ├── task_item_tile.dart         # Animated swipeable task tile with priority stripe
│   │   │   │   ├── task_filter_bar.dart        # Filter chips (All, Today, Upcoming, Overdue, Done)
│   │   │   │   └── create_edit_task_sheet.dart # Task creation/editing bottom sheet modal
│   ├── calendar/
│   │   ├── data/
│   │   │   └── calendar_repository.dart        # Drift SQLite CRUD & AlarmService sync based on hasAlarm
│   │   ├── presentation/
│   │   │   ├── calendar_screen.dart            # Month/Week calendar + day agenda timeline
│   │   │   ├── widgets/
│   │   │   │   ├── event_item_tile.dart        # Event card with hasAlarm badge vs silent badge
│   │   │   │   └── create_edit_event_sheet.dart# Event modal with explicit hasAlarm toggle & time pickers
│   ├── wishlist/
│   │   ├── data/
│   │   │   └── wishlist_repository.dart        # Drift SQLite CRUD & reactive Streams for Wishlist
│   │   ├── presentation/
│   │   │   ├── wishlist_screen.dart            # Wishlist screen with category tabs & status toggle
│   │   │   └── widgets/
│   │   │       ├── wishlist_item_card.dart     # Wishlist card with priority & target date
│   │   │       └── create_edit_wishlist_sheet.dart # Wishlist item creation modal
│   ├── productivity/
│   │   ├── data/
│   │   │   └── focus_repository.dart           # Focus sessions CRUD & stats calculation
│   │   └── presentation/
│   │       ├── focus_timer_sheet.dart          # 25-minute Pomodoro timer with start/pause/complete
│   │       └── widgets/
│   │           └── productivity_stats_card.dart# Real-time completion rate & focus stats
│   ├── dashboard/
│   │   └── presentation/
│   │       └── dashboard_screen.dart           # Connected dynamically to live tasks, events & stats
test/
├── unit/
│   ├── tasks_repository_test.dart              # Task filtering, CRUD, completion toggle
│   ├── calendar_repository_test.dart           # Calendar event CRUD & strict hasAlarm alarm sync
│   ├── wishlist_repository_test.dart           # Wishlist CRUD & categories
│   └── focus_repository_test.dart              # Focus sessions logging & productivity metrics
└── widget/
    ├── tasks_screen_test.dart                  # Task list, search, filter chips, item tile
    ├── calendar_screen_test.dart               # Calendar view, event tiles, hasAlarm badge
    └── wishlist_screen_test.dart               # Wishlist cards, category switching
```

---

## Bite-Sized Implementation Tasks

### Task 1: Task Management Repository & Business Logic
- [ ] Create `lib/features/tasks/data/tasks_repository.dart` with Drift SQLite CRUD:
  - `watchTasks(filter, category, searchQuery)`
  - `createTask(TasksCompanion)`
  - `updateTask(Task)`
  - `toggleTask(id, isCompleted)`
  - `deleteTask(id)`
- [ ] Write unit tests in `test/unit/tasks_repository_test.dart` verifying filtering (All, Today, Overdue, Completed) and completion toggling.
- [ ] Run `flutter test test/unit/tasks_repository_test.dart`.

### Task 2: Task Management UI & Interaction
- [ ] Create `lib/features/tasks/presentation/widgets/task_item_tile.dart` with WCAG contrast, priority indicators (High: red, Medium: amber, Low: blue), strikethrough animated text on completion, and swipe-to-delete.
- [ ] Create `lib/features/tasks/presentation/widgets/task_filter_bar.dart` with horizontal scrollable chips.
- [ ] Create `lib/features/tasks/presentation/widgets/create_edit_task_sheet.dart` with title, description, category selector, priority segmented button, due date/time pickers.
- [ ] Upgrade `lib/features/tasks/presentation/tasks_screen.dart` with live search, filter tabs, reactive list, and FAB to add tasks.
- [ ] Write widget tests in `test/widget/tasks_screen_test.dart`.

### Task 3: Calendar & Important Dates with Strict `hasAlarm` Distinction
- [ ] Create `lib/features/calendar/data/calendar_repository.dart`:
  - `watchEventsForDate(DateTime date)`
  - `watchAllEvents()`
  - `createEvent(CalendarEventsCompanion, hasAlarm)`: If `hasAlarm == true`, schedules exact alarm with `AlarmService`. If `hasAlarm == false`, explicitly cancels or skips alarm scheduling.
  - `deleteEvent(id)`: Cancels alarm if `hasAlarm == true`.
- [ ] Write unit tests in `test/unit/calendar_repository_test.dart` proving `hasAlarm == false` NEVER calls `alarmService.scheduleAlarm` and `hasAlarm == true` DOES schedule exact alarm.
- [ ] Create `lib/features/calendar/presentation/widgets/event_item_tile.dart` showing event time, category color pill, and prominent `Alarm Scheduled` vs `Silent Event` icon badge.
- [ ] Create `lib/features/calendar/presentation/widgets/create_edit_event_sheet.dart` with explicit switch: "Spoken Alarm Reminder (USP)" with helper text explaining the difference.
- [ ] Upgrade `lib/features/calendar/presentation/calendar_screen.dart` integrating `table_calendar`, date selection, agenda list, and month/week toggle.
- [ ] Write widget tests in `test/widget/calendar_screen_test.dart`.

### Task 4: Wishlist & Personal Goals
- [ ] Create `lib/features/wishlist/data/wishlist_repository.dart` with Drift SQLite CRUD.
- [ ] Write unit tests in `test/unit/wishlist_repository_test.dart`.
- [ ] Create `lib/features/wishlist/presentation/widgets/wishlist_item_card.dart` displaying category pill (Product, Skill, Project, Travel, Goal), priority badge, target date, and completion checkbox.
- [ ] Create `lib/features/wishlist/presentation/widgets/create_edit_wishlist_sheet.dart`.
- [ ] Upgrade `lib/features/wishlist/presentation/wishlist_screen.dart` with responsive grid/list and category tabs.
- [ ] Write widget tests in `test/widget/wishlist_screen_test.dart`.

### Task 5: Focus Session Timer & Productivity Tracking
- [ ] Create `lib/features/productivity/data/focus_repository.dart` for logging completed sessions and calculating today's focus minutes & task completion percentage.
- [ ] Create `lib/features/productivity/presentation/focus_timer_sheet.dart` with circular countdown timer (25 min standard / 5 min break), play/pause/reset controls, and completion dialog.
- [ ] Write unit tests in `test/unit/focus_repository_test.dart`.

### Task 6: Dynamic Home Dashboard & Quick Actions Integration
- [ ] Update `lib/features/dashboard/presentation/dashboard_screen.dart` to connect to real-time streams:
  - Live pending vs completed task counters.
  - Live upcoming calendar events with alarm status.
  - Productivity score & today's focus minutes.
- [ ] Connect the main Floating Action Button modal to offer 4 instant actions:
  - New Spoken Reminder (opens `CreateReminderSheet`)
  - New Task (opens `CreateEditTaskSheet`)
  - New Calendar Event (opens `CreateEditEventSheet`)
  - New Wishlist Item (opens `CreateEditWishlistSheet`)
  - Start Focus Session (opens `FocusTimerSheet`)

### Task 7: Comprehensive Verification & Polishing
- [ ] Run `dart format .` across all files.
- [ ] Run `flutter analyze` and ensure 0 errors, 0 warnings.
- [ ] Run full test suite with `flutter test`.
- [ ] Verify Android compilation with `flutter build apk --debug`.
- [ ] Update `ATTRIBUTIONS.md` for any additional asset or package notes.
