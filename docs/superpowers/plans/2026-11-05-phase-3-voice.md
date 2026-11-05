# TASKLY Phase 3: Voice Personality System & Device TTS Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the complete offline Text-to-Speech (TTS) engine, four voice personalities (Nova, Max, Atlas, Echo), dynamic installed device voice discovery, interactive voice preview player, speech customization (rate & pitch), and alarm screen speech synthesis.

**Architecture:** Service-driven speech synthesis using `flutter_tts` integrated with Riverpod state management and Drift SQLite settings persistence.

**Tech Stack:** Flutter 3.47+, Dart 3.13+, Flutter TTS 4.2+, Drift SQLite, Riverpod 2.6+.

---

### Task 1: TTS Service & Voice Personality Domain Models

**Files:**
- Create: `lib/features/voice/domain/voice_personality.dart`
- Create: `lib/services/tts_service.dart`
- Create: `test/unit/voice_personality_test.dart`

- [ ] **Step 1: Write unit tests for Voice Personality models and parameters**

Create `test/unit/voice_personality_test.dart` testing personality lookup by ID, default rate/pitch parameters, and sample prompt retrieval.

- [ ] **Step 2: Implement `voice_personality.dart`**

Define `VoicePersonality` enum/class with Nova, Max, Atlas, Echo properties, traits, signature colors, default pitch, default rate, and sample quotes.

- [ ] **Step 3: Implement `tts_service.dart`**

Wrap `FlutterTts` with methods for `speak()`, `stop()`, `setPersonality()`, `getInstalledVoices()`, `getLanguages()`, and `previewPersonality()`.

- [ ] **Step 4: Run unit tests**

Run: `flutter test test/unit/voice_personality_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit Task 1**

```bash
git add lib/features/voice/domain/ lib/services/tts_service.dart test/unit/voice_personality_test.dart
git commit -m "feat: implement TTS service and voice personality models"
```

---

### Task 2: Voice Preferences Repository & Drift SQLite Persistence

**Files:**
- Create: `lib/features/voice/data/voice_preference_repository.dart`
- Create: `test/unit/voice_preference_test.dart`

- [ ] **Step 1: Write unit tests for voice preferences persistence**

Create `test/unit/voice_preference_test.dart` testing default voice saving, rate/pitch adjustments, and retrieval from Drift `app_settings` table.

- [ ] **Step 2: Implement `voice_preference_repository.dart`**

Implement methods to save and retrieve `default_voice_personality`, `speech_rate`, `speech_pitch`, and `selected_language`.

- [ ] **Step 3: Run repository tests**

Run: `flutter test test/unit/voice_preference_test.dart`
Expected: PASS.

- [ ] **Step 4: Commit Task 2**

```bash
git add lib/features/voice/data/ test/unit/voice_preference_test.dart
git commit -m "feat: implement voice preference repository with Drift persistence"
```

---

### Task 3: Voice Preview Card & Voice Settings Screen

**Files:**
- Create: `lib/features/voice/presentation/widgets/voice_preview_card.dart`
- Create: `lib/features/voice/presentation/voice_settings_screen.dart`
- Create: `test/widget/voice_settings_test.dart`

- [ ] **Step 1: Build `voice_preview_card.dart`**

Interactive card for each personality with Play/Stop preview button, animated audio icon, trait badge, and prompt quote.

- [ ] **Step 2: Build `voice_settings_screen.dart`**

Shows personalities list, installed device voices dropdown, speech rate slider, speech pitch slider, and Android TTS system settings button.

- [ ] **Step 3: Write widget test for Voice Settings**

Create `test/widget/voice_settings_test.dart` verifying all 4 personality cards, preview buttons, and sliders.

- [ ] **Step 4: Run widget tests**

Run: `flutter test test/widget/voice_settings_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit Task 3**

```bash
git add lib/features/voice/presentation/ test/widget/voice_settings_test.dart
git commit -m "feat: implement voice settings screen with live preview player"
```

---

### Task 4: Alarm Screen & Create Reminder Integration

**Files:**
- Modify: `lib/features/alarms/presentation/alarm_screen.dart`
- Modify: `lib/features/reminders/presentation/create_reminder_sheet.dart`
- Modify: `lib/features/settings/presentation/settings_screen.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Connect `TtsService` to `AlarmScreen`**

Automatically speak the reminder title and spoken message using the selected voice personality when the alarm triggers.

- [ ] **Step 2: Add voice audition buttons in `CreateReminderSheet`**

Allow users to tap a speaker icon next to each voice personality to preview it before saving.

- [ ] **Step 3: Wire Voice Settings screen into Profile/Settings and Router**

Add route `/voice-settings` and link "TTS Voice Engines" in `SettingsScreen`.

- [ ] **Step 4: Commit Task 4**

```bash
git add lib/features/alarms/ lib/features/reminders/ lib/features/settings/ lib/core/router/
git commit -m "feat: wire TTS speech synthesis into AlarmScreen and CreateReminderSheet"
```

---

### Task 5: Formatting, Analysis, Full Test Suite Verification

- [ ] **Step 1: Format codebase**
Run: `dart format .`
Expected: Clean.

- [ ] **Step 2: Run static analysis**
Run: `flutter analyze`
Expected: 0 issues found.

- [ ] **Step 3: Run full test suite**
Run: `flutter test`
Expected: 100% tests passing.

- [ ] **Step 4: Commit Phase 3 Completion**
```bash
git commit -m "feat: finalize Phase 3 voice personality system"
```
