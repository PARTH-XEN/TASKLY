# TASKLY Phase 1: Project Foundation & Architecture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish the complete offline-first architectural foundation for TASKLY, including feature-first directory layout, verified open-source dependencies, centralized dark/light theme system, 5-tab navigation shell with GoRouter, responsive home dashboard, and Drift SQLite local database.

**Architecture:** Feature-first modular architecture separating presentation, domain, and data layers, with Riverpod for dependency injection and state management, GoRouter `StatefulShellRoute` for state-preserving navigation, and Drift for type-safe offline SQLite operations.

**Tech Stack:** Flutter 3.47+, Dart 3.13+, Flutter Riverpod 2.6+, GoRouter 14+, Drift 2.26+, SQLite3, TableCalendar, Google Fonts, UUID, Intl.

---

### Task 1: Environment Setup & Dependency Configuration

**Files:**
- Modify: `pubspec.yaml`
- Create: `ATTRIBUTIONS.md`
- Test: Run `flutter pub get` and verify dependency lockfile

- [ ] **Step 1: Update `pubspec.yaml` with verified production dependencies**

Add the required packages to `pubspec.yaml`:
```yaml
name: taskly
description: "TASKLY — Don't just remind me when. Remind me what. Spoken smart reminder & productivity app."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.13.7

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State Management & Navigation
  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1

  # Local Database & Storage
  drift: ^2.26.0
  drift_flutter: ^0.2.4
  sqlite3_flutter_libs: ^0.5.28
  path_provider: ^2.1.5
  path: ^1.9.1
  shared_preferences: ^2.5.2

  # Core Utilities & UI
  uuid: ^4.5.1
  intl: ^0.20.2
  google_fonts: ^6.2.1
  table_calendar: ^3.1.3

  # Audio & Notifications (Preparation for Phase 2 & 3)
  flutter_tts: ^4.2.2
  flutter_local_notifications: ^18.0.1
  timezone: ^0.10.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  drift_dev: ^2.26.0
  build_runner: ^2.4.15

flutter:
  uses-material-design: true
  assets:
    - assets/icons/
    - assets/audio/
```

- [ ] **Step 2: Create open-source `ATTRIBUTIONS.md`**

Create `ATTRIBUTIONS.md` at root listing licenses of all packages and assets (MIT, Apache 2.0, BSD-3, OFL).

- [ ] **Step 3: Run `flutter pub get`**

Run: `flutter pub get`
Expected: Process exits with code 0.

- [ ] **Step 4: Initialize Git repository and commit Task 1**

Run:
```bash
git init
git add pubspec.yaml ATTRIBUTIONS.md
git commit -m "chore: setup dependencies and open-source attributions"
```

---

### Task 2: Core Theme & Design System

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_typography.dart`
- Create: `lib/core/theme/app_spacing.dart`
- Create: `lib/core/theme/app_theme.dart`
- Create: `test/unit/theme_test.dart`

- [ ] **Step 1: Write unit tests for theme definitions**

Create `test/unit/theme_test.dart` verifying contrast ratios, color schemes, and theme data generation.

- [ ] **Step 2: Implement `app_colors.dart`**

Define Dark (`#0F111A` background, `#181B28` surface, `#818CF8` indigo accent) and Light (`#F8F9FC` background, `#FFFFFF` surface, `#4F46E5` indigo accent) palettes.

- [ ] **Step 3: Implement `app_typography.dart` & `app_spacing.dart`**

Define text styles using GoogleFonts Inter/Plus Jakarta Sans with proper WCAG font weights, dynamic type support, and 48dp minimum touch target spacing.

- [ ] **Step 4: Implement `app_theme.dart`**

Configure Material 3 `ThemeData` for light and dark modes with customized CardTheme, AppBarTheme, NavigationBarTheme, and FloatingActionButtonTheme.

- [ ] **Step 5: Run tests and verify theme passes**

Run: `flutter test test/unit/theme_test.dart`
Expected: All tests pass.

- [ ] **Step 6: Commit Task 2**

```bash
git add lib/core/theme/ test/unit/theme_test.dart
git commit -m "feat: implement centralized design system and theme tokens"
```

---

### Task 3: Drift Local Database Configuration

**Files:**
- Create: `lib/core/database/tables/reminders_table.dart`
- Create: `lib/core/database/tables/tasks_table.dart`
- Create: `lib/core/database/tables/calendar_events_table.dart`
- Create: `lib/core/database/tables/wishlist_table.dart`
- Create: `lib/core/database/tables/alarm_history_table.dart`
- Create: `lib/core/database/tables/focus_sessions_table.dart`
- Create: `lib/core/database/tables/app_settings_table.dart`
- Create: `lib/core/database/app_database.dart`
- Create: `test/unit/database_test.dart`

- [ ] **Step 1: Define Drift table schemas**

Implement modular Drift tables according to the design specification with proper primary keys, indices, and type converters.

- [ ] **Step 2: Configure `AppDatabase` class**

Set up `@DriftDatabase` with tables, schemaVersion, and native drift_flutter database opener.

- [ ] **Step 3: Run `build_runner` code generation**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `lib/core/database/app_database.g.dart` generated without errors.

- [ ] **Step 4: Write database unit test using in-memory SQLite**

Create `test/unit/database_test.dart` to test CRUD operations on Reminders, Tasks, and Settings.

- [ ] **Step 5: Run database tests**

Run: `flutter test test/unit/database_test.dart`
Expected: All database operations pass.

- [ ] **Step 6: Commit Task 3**

```bash
git add lib/core/database/ test/unit/database_test.dart
git commit -m "feat: implement Drift SQLite database schema and tables"
```

---

### Task 4: Navigation Shell with GoRouter & 5 Primary Tabs

**Files:**
- Create: `lib/core/router/app_router.dart`
- Create: `lib/features/dashboard/presentation/dashboard_screen.dart`
- Create: `lib/features/tasks/presentation/tasks_screen.dart`
- Create: `lib/features/calendar/presentation/calendar_screen.dart`
- Create: `lib/features/wishlist/presentation/wishlist_screen.dart`
- Create: `lib/features/settings/presentation/settings_screen.dart`
- Create: `lib/shared/widgets/main_scaffold_shell.dart`
- Create: `lib/shared/widgets/quick_action_sheet.dart`
- Create: `test/widget/navigation_test.dart`

- [ ] **Step 1: Implement `MainScaffoldShell`**

Build custom bottom NavigationBar with 5 tabs (Home, Tasks, Calendar, Wishlist, Profile) and central Thumb-Zone friendly Quick Action Floating Action Button.

- [ ] **Step 2: Implement placeholder screens for all 5 tabs**

Create clean scaffold screens for Dashboard, Tasks, Calendar, Wishlist, and Profile.

- [ ] **Step 3: Configure `app_router.dart` with `StatefulShellRoute.indexedStack`**

Preserve tab state across switches and enable deep-linking routing.

- [ ] **Step 4: Write widget test for navigation shell**

Create `test/widget/navigation_test.dart` to verify tab switching, label rendering, and FAB trigger.

- [ ] **Step 5: Run navigation tests**

Run: `flutter test test/widget/navigation_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit Task 4**

```bash
git add lib/core/router/ lib/features/ lib/shared/ test/widget/navigation_test.dart
git commit -m "feat: implement GoRouter 5-tab navigation shell and quick actions"
```

---

### Task 5: Dashboard Screen Implementation

**Files:**
- Create: `lib/features/dashboard/presentation/widgets/greeting_header.dart`
- Create: `lib/features/dashboard/presentation/widgets/today_summary_card.dart`
- Create: `lib/features/dashboard/presentation/widgets/next_reminder_card.dart`
- Create: `lib/features/dashboard/presentation/widgets/quick_action_grid.dart`
- Create: `lib/features/dashboard/presentation/widgets/upcoming_reminders_list.dart`
- Modify: `lib/features/dashboard/presentation/dashboard_screen.dart`
- Create: `test/widget/dashboard_test.dart`

- [ ] **Step 1: Build `greeting_header.dart`**

Shows personalized greeting ("Good morning / afternoon / evening"), current formatted date, and productivity badge.

- [ ] **Step 2: Build `next_reminder_card.dart` highlighting Spoken Reminders USP**

Displays the next scheduled reminder with countdown, task title, time, and Voice Personality badge (Nova, Max, Atlas, Echo) with spoken task preview ("Hey! It's time to...").

- [ ] **Step 3: Build `today_summary_card.dart`**

Displays pending tasks count, completed tasks count, and visual progress ring.

- [ ] **Step 4: Build `quick_action_grid.dart` & `upcoming_reminders_list.dart`**

Direct shortcuts to "New Reminder", "New Task", "Focus Session", and "Calendar Event" plus upcoming scheduled items with graceful empty states.

- [ ] **Step 5: Assemble `dashboard_screen.dart` with pull-to-refresh & responsive layout**

Assemble all components inside a clean CustomScrollView with Slivers for smooth 60fps/120fps scrolling.

- [ ] **Step 6: Write widget test for Dashboard**

Create `test/widget/dashboard_test.dart` verifying all cards, headings, and empty state rendering.

- [ ] **Step 7: Run dashboard tests**

Run: `flutter test test/widget/dashboard_test.dart`
Expected: PASS.

- [ ] **Step 8: Commit Task 5**

```bash
git add lib/features/dashboard/ test/widget/dashboard_test.dart
git commit -m "feat: complete initial dashboard with USP spoken reminder highlight"
```

---

### Task 6: App Wiring, Verification & Phase 1 Sign-off

**Files:**
- Modify: `lib/app.dart`
- Modify: `lib/main.dart`
- Test: All unit & widget tests

- [ ] **Step 1: Wire Riverpod `ProviderScope` and `MaterialApp.router` in `lib/app.dart` and `lib/main.dart`**

Connect DatabaseProvider, ThemeModeProvider, and AppRouter.

- [ ] **Step 2: Format codebase**

Run: `dart format .`
Expected: Clean formatting.

- [ ] **Step 3: Run static analysis**

Run: `flutter analyze`
Expected: 0 errors, 0 warnings, 0 issues.

- [ ] **Step 4: Run full test suite**

Run: `flutter test`
Expected: 100% tests passing.

- [ ] **Step 5: Commit Phase 1 Completion**

```bash
git add lib/ test/
git commit -m "feat: finalize Phase 1 foundation, wiring, and verification"
```

