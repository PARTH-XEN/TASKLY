<USER_REQUEST>
# TASKLY — COMPLETE FLUTTER APP DEVELOPMENT MASTER PROMPT

## 1. YOUR ROLE

Act as an expert Flutter developer, senior Android developer, UI/UX designer, software architect, and QA engineer.

Your mission is to design, develop, test, and prepare a complete Android-first Flutter application named TASKLY.

You must work like a professional software development team.

Do not just generate attractive UI screens. Build a functional, maintainable, offline-first application with properly connected features, database operations, notification scheduling, and Android integration.

The application must be scalable and ready for future improvements.

IMPORTANT PRODUCT DECISION:

TASKLY DOES NOT REQUIRE ANY AI AGENT, AI CHATBOT, GENERATIVE AI, OR PAID AI API.

Do not integrate:
- OpenAI APIs.
- ChatGPT APIs.
- Gemini APIs.
- AI chatbot services.
- Paid AI voice APIs.
- Subscription-based AI services.
- Cloud AI assistants.

The voice personalities in TASKLY are predefined TTS configurations using available device voices.

The complete core application should work offline.

---

# 2. PRODUCT IDENTITY

Application name: TASKLY

Tagline:

"Don't just remind me when. Remind me what."

Product category:
Personal productivity, smart reminders, task management, and calendar.

Primary platform:
Android.

Development framework:
Flutter.

Programming language:
Dart.

Main objective:

Create an application that helps users organize their daily lives, remember important activities, manage tasks, and receive spoken reminders instead of ordinary generic alarm sounds.

Example:

A user wants to study Flutter after two hours.

They open TASKLY and create a reminder:

Task: Study Flutter
Time: After 2 hours
Voice: Nova
Repeat: Never

When the scheduled time arrives, TASKLY should notify the user and, where Android permits, speak:

"Hey! It's time to study Flutter. You scheduled this two hours ago. Let's get started!"

This spoken task reminder experience is the main USP of the application.

---

# 3. FREE AND OPEN-SOURCE RESOURCE POLICY

This is a mandatory requirement.

Use free resources from the internet wherever appropriate.

The application must not depend on paid assets, paid subscriptions, or paid APIs for its core functionality.

Use resources from reputable free and open-source platforms.

Recommended sources:

### Fonts
- Google Fonts.
- Fontsource.
- Other openly licensed font repositories.

### Icons
- Lucide.
- Material Symbols.
- Material Icons.
- Other free icon libraries.

### Illustrations
- unDraw.
- Open-source illustration repositories.
- Free-to-use SVG collections.

### Sounds
- Freesound, where individual asset licenses permit.
- Pixabay sound effects, subject to their license.
- Other reputable royalty-free sound repositories.
- Original simple notification sounds generated within the project.

### Flutter packages
- pub.dev.
- Official Flutter packages.
- Actively maintained open-source packages.

### Images
- Unsplash.
- Pexels.
- Pixabay.

Only use assets after checking their licensing terms.

IMPORTANT:
1. Prefer MIT, Apache 2.0, OFL, CC0, and similarly permissive licenses.
2. Check the individual license of every asset.
3. Do not use copyrighted images, icons, sounds, or fonts without permission.
4. Do not use pirated premium assets.
5. Do not download assets from suspicious websites.
6. Store essential assets locally in the application.
7. Do not make core application functionality dependent on remote image or sound URLs.
8. Maintain an ATTRIBUTIONS.md file listing third-party assets, their sources, and licenses.
9. Do not purchase anything.
10. Do not introduce paid API dependencies.

The application must remain fully functional when offline.

---

# 4. TECHNOLOGY STACK

Use the latest stable compatible versions.

- Flutter.
- Dart.
- Riverpod for state management.
- GoRouter for navigation.
- Drift and SQLite for local storage.
- flutter_local_notifications for notifications, if compatible with the selected Android architecture.
- flutter_tts for text-to-speech.
- timezone for scheduling.
- table_calendar for calendar functionality.
- shared_preferences for lightweight settings.
- uuid for unique identifiers.

Use native Kotlin Android integration wherever Flutter packages cannot provide reliable functionality.

Verify package versions and documentation before implementation.

Do not use deprecated APIs.

Do not invent package functions.

---

# 5. DESIGN AND BRANDING

Create a premium, elegant, modern productivity application.

Design must support:

- Dark mode.
- Light mode.
- System theme.
- Consistent typography.
- Modern navigation.
- Beautiful cards.
- Smooth transitions.
- Subtle animations.
- Proper spacing.
- Rounded components.
- High-quality empty states.
- Accessible contrast.

Use a sophisticated color palette.

Suggested direction:

Dark theme:
- Deep charcoal backgrounds.
- Dark navy surfaces.
- Soft white typography.
- Subtle blue or violet accents.

Light theme:
- Soft off-white backgrounds.
- Clean white cards.
- Dark readable typography.
- Subtle blue or violet accents.

Create a centralized theme system.

Use reusable components.

Avoid:
- Excessive gradients.
- Excessive glassmorphism.
- Unnecessary decorative elements.
- Crowded screens.
- Generic template designs.

The UI should look like a professionally designed commercial productivity application.

---

# 6. APPLICATION NAVIGATION

Create five primary navigation tabs:

1. Home.
2. Tasks.
3. Calendar.
4. Wishlist.
5. Profile.

Create a floating quick-action button for:

- New reminder.
- New task.
- New event.
- New wishlist item.

Navigation must work correctly.

Preserve appropriate navigation state.

---

# 7. HOME DASHBOARD

Create a beautiful dashboard.

Display:

- Personalized greeting.
- Current date.
- Today's overview.
- Pending tasks.
- Completed tasks.
- Upcoming reminders.
- Upcoming events.
- Productivity progress.
- Next scheduled reminder.
- Recent activities.

Add quick-action shortcuts.

Display upcoming reminders with:

- Task title.
- Time.
- Date.
- Voice personality.
- Repeat information.
- Status.

Make the dashboard useful without overcrowding it.

---

# 8. SMART REMINDER AND ALARM SYSTEM

This is the MOST IMPORTANT FEATURE.

Create a fully functional reminder system.

Users must be able to:

- Create reminders.
- Edit reminders.
- Delete reminders.
- Schedule reminders.
- Set reminders after a relative duration.
- Choose date and time.
- Select a voice personality.
- Customize spoken messages.
- Enable or disable spoken reminders.
- Select repeat schedules.
- Snooze reminders.
- Stop alarms.
- Mark tasks as completed.
- Reschedule alarms.

Reminder creation fields:

- Title.
- Description.
- Date.
- Time.
- Relative duration option.
- Voice personality.
- Installed TTS voice.
- Speech rate.
- Speech pitch.
- Repeat frequency.
- Custom spoken message.
- Enabled/disabled status.

### Example

Title: Complete Flutter project.

Time: After 2 hours.

Voice: Nova.

Spoken message:

"Hey! It's time to complete your Flutter project. Let's get started."

### Alarm screen

Create a dedicated alarm interface.

Display:

- Large reminder title.
- Current time.
- Scheduled time.
- Voice personality.
- Animated sound waveform.
- Stop button.
- Snooze button.
- Complete button.
- Reschedule action.

Use a visually distinctive alarm screen.

### Alarm history

Store:

- Triggered reminders.
- Completed reminders.
- Snoozed reminders.
- Missed reminders.
- Rescheduled reminders.

### Android alarm implementation

Reliability is essential.

Do not use Dart timers or periodic polling for background alarms.

Use an appropriate Android-native scheduling architecture.

Investigate:
- Android AlarmManager.
- Exact alarm permissions.
- Inexact alarm fallback.
- Notification channels.
- Android 13+ notification permissions.
- Android background execution limits.
- Device reboot recovery.
- Time-zone changes.
- Manual time changes.
- App updates.
- Alarm cancellation.
- PendingIntent identity.
- Battery restrictions.

Request only permissions that are genuinely required.

Handle permission denial gracefully.

Provide clear instructions when users need to enable special permissions in Android settings.

Do not claim that an alarm has been scheduled until scheduling succeeds.

### Background voice behavior

Investigate Android background TTS limitations carefully.

Do not assume flutter_tts will work automatically from a background notification callback.

Implement a reliable and policy-compliant approach.

If automatic spoken playback cannot be guaranteed:

- Show the notification.
- Include the reminder title.
- Provide a clear action to open the alarm screen.
- Start TTS when the alarm screen becomes active.
- Never silently pretend the spoken reminder played.

Where permitted, provide a full-screen alarm experience.

Respect Android full-screen intent and foreground-service restrictions.

The user must always have an accessible way to stop the alarm.

---

# 9. VOICE PERSONALITY SYSTEM

Do not use AI.

Create four predefined voice personalities using device Text-to-Speech.

### Nova
Friendly, calm, encouraging.

### Max
Energetic, enthusiastic, motivating.

### Atlas
Professional, clear, direct.

### Echo
Simple, minimal, straightforward.

Each personality should have:

- Name.
- Description.
- TTS configuration.
- Default speech rate.
- Default pitch.
- Voice preview.

Allow users to:

- Select a personality.
- Choose from available installed TTS voices.
- Select a language.
- Adjust speech rate.
- Adjust pitch.
- Preview voice output.
- Set a default voice.
- Choose a different voice for individual reminders.

Do not promise that every Android device supports identical voices.

Show available voices dynamically.

If a voice or language is unavailable, show a helpful message.

Allow users to install additional TTS language data through supported Android settings.

Keep this feature completely free using installed device TTS capabilities.

---

# 10. TO-DO LIST

Create a complete task manager.

Each task should contain:

- Title.
- Description.
- Category.
- Priority.
- Creation date.
- Due date.
- Optional due time.
- Completion status.
- Optional linked reminder.
- Notes.

Features:

- Add task.
- Edit task.
- Delete task.
- Complete task.
- Reopen task.
- Set priority.
- Search.
- Filter.
- Sort.

Task categories:

- Personal.
- Work.
- Study.
- Health.
- Projects.
- Other.

Task views:

- All.
- Today.
- Upcoming.
- Overdue.
- Completed.

Priority levels:

- Low.
- Medium.
- High.

Add visual progress indicators.

Keep task records even when associated reminders are deleted.

---

# 11. CALENDAR AND IMPORTANT DATES

Create a complete calendar experience.

Views:

- Monthly.
- Weekly.
- Daily agenda.

Features:

- Add events.
- Edit events.
- Delete events.
- Important dates.
- Event descriptions.
- Event categories.
- Multiple events per date.
- Upcoming events.

Every event must include:

- Title.
- Description.
- Date.
- Optional start time.
- Optional end time.
- Color category.
- Important-date status.
- Alarm ON/OFF.

### Important distinction

Users must explicitly decide whether an event should trigger an alarm.

Example A:

Title: College Examination.

Date: 15 December.

Alarm: OFF.

Expected result:
Save and highlight the important date. Do not schedule an alarm.

Example B:

Title: Project Submission.

Date: 20 December.

Time: 9 AM.

Alarm: ON.

Expected result:
Save the event, highlight its date, and schedule the reminder.

Use different calendar indicators for:

- Important dates.
- Events with alarms.
- Events without alarms.

Never schedule an alarm for an event with Alarm OFF.

---

# 12. WISHLIST

Create a personal wishlist.

Users can save:

- Products they want.
- Skills they want to learn.
- Projects they want to complete.
- Places they want to visit.
- Personal goals.

Fields:

- Title.
- Description.
- Category.
- Optional image.
- Priority.
- Target date.
- Creation date.
- Completion status.

Features:

- Add.
- Edit.
- Delete.
- Search.
- Filter.
- Mark completed.

Use beautiful cards and category filters.

No paid shopping integrations.

---

# 13. PRODUCTIVITY TRACKING

Create a productivity overview.

Track:

- Tasks completed.
- Tasks pending.
- Daily completion.
- Weekly progress.
- Focus sessions.

Add an optional focus timer.

Allow users to connect focus sessions to tasks.

Store productivity data locally.

---

# 14. PROFILE AND SETTINGS

Create settings for:

### Appearance
- Dark mode.
- Light mode.
- System mode.

### Voice
- Default personality.
- Installed voice.
- Language.
- Speech rate.
- Pitch.

### Alarm
- Default snooze duration.
- Notification preferences.
- Alarm permissions.
- Default spoken reminder settings.

### General
- Date format.
- Time format.
- First day of week.
- Haptic feedback.
- About.
- Privacy information.

Remember user preferences across application restarts.

---

# 15. DATABASE AND STORAGE

Use Drift with SQLite.

Create tables for:

- Tasks.
- Reminders.
- Calendar events.
- Wishlist.
- Voice preferences.
- Alarm history.
- Focus sessions.
- App settings.

Use appropriate relationships and indexes.

Use unique IDs.

Handle database migrations.

Keep the database as the source of truth for reminder and task records.

Keep alarm scheduling synchronized with database changes.

When a reminder changes, update its scheduled alarm.

When a reminder is deleted, cancel its scheduled alarm.

When scheduling fails, retain the record and clearly communicate the failure.

Support offline functionality.

Do not require Firebase.

Do not require a user account.

Do not require an internet connection for core features.

---

# 16. PROJECT STRUCTURE

Use feature-first architecture.

Recommended structure:

lib/
  main.dart
  app.dart

  core/
    constants/
    theme/
    router/
    database/
    utils/

  features/
    dashboard/
    reminders/
    alarms/
    voice/
    tasks/
    calendar/
    wishlist/
    productivity/
    settings/

  services/
    alarm_service.dart
    notification_service.dart
    tts_service.dart
    permission_service.dart

  shared/
    widgets/
    models/

android/
assets/
test/
integration_test/

Keep features modular.

Separate presentation, domain, and data responsibilities.

Avoid giant Dart files.

---

# 17. TESTING AND QUALITY ASSURANCE

Create unit tests for:

- Reminder creation.
- Reminder editing.
- Reminder deletion.
- Alarm time calculations.
- Recurrence rules.
- Task operations.
- Calendar events.
- Important dates with alarms.
- Important dates without alarms.
- Voice preference persistence.

Create widget tests for major screens.

Create integration tests for:

- Scheduling reminders.
- Rescheduling reminders.
- Canceling reminders.
- Notifications.
- Alarm actions.
- Theme switching.
- TTS preview.

Test background behavior on real Android devices wherever possible.

Test multiple Android API levels.

Run:

flutter pub get

dart format .

flutter analyze

flutter test

Fix errors before completing each development phase.

---

# 18. DEVELOPMENT PHASES

Do not attempt the entire application in one step.

Develop in the following order.

### PHASE 1 — PROJECT FOUNDATION

- Initialize Flutter project.
- Set up architecture.
- Install compatible dependencies.
- Build design system.
- Implement dark and light themes.
- Implement navigation.
- Create dashboard.
- Configure Drift.
- Create initial database.

### PHASE 2 — SMART REMINDERS

- Reminder creation.
- Local database integration.
- Android alarm scheduling.
- Notification permissions.
- Alarm screen.
- Snooze and stop.
- Reminder history.

### PHASE 3 — VOICE

- TTS integration.
- Four voice personalities.
- Installed voice discovery.
- Voice selection.
- Voice preview.
- Speech customization.

### PHASE 4 — PRODUCTIVITY

- To-do manager.
- Calendar.
- Important dates.
- Wishlist.

### PHASE 5 — ADVANCED FEATURES

- Productivity statistics.
- Focus timer.
- Recurring reminders.
- UI refinement.

### PHASE 6 — TESTING AND RELEASE

- Bug fixes.
- Android compatibility.
- Permission testing.
- Performance optimization.
- Release build.
- Documentation.

---

# 19. STRICT RULES FOR ANTIGRAVITY

1. Inspect the existing project before making changes.
2. Never overwrite existing work without permission.
3. Create a development plan first.
4. Build incrementally.
5. Use free resources and open-source packages.
6. Verify licenses for downloaded assets.
7. Do not purchase resources.
8. Do not add AI agents or AI APIs.
9. Do not create fake or nonfunctional buttons.
10. Do not use fake alarm scheduling.
11. Do not assume background TTS works without testing.
12. Do not make core features internet-dependent.
13. Do not hardcode API keys.
14. Do not ignore build errors.
15. Write maintainable code.
16. Test every major feature.
17. Document platform-specific limitations.
18. Do not declare a feature complete unless it actually works.

If a requested feature is technically restricted by Android, implement the best reliable alternative and document the limitation.

---

# 20. FIRST INSTRUCTION

START WITH PHASE 1 ONLY.

Your first actions:

1. Inspect the installed development environment.
2. Check Flutter and Dart versions.
3. Inspect the project directory.
4. Check Android SDK availability.
5. Prepare a detailed development plan.
6. Initialize the Flutter project if necessary.
7. Create the folder architecture.
8. Install verified free dependencies.
9. Create the theme system.
10. Create the five-tab navigation.
11. Build the initial dashboard.
12. Configure Drift and initial database tables.
13. Run formatting, analysis, and tests.

Do not proceed to Phase 2 until Phase 1 is complete and verified.

At the end of Phase 1, report:

- Files created.
- Packages installed.
- Features completed.
- Commands executed.
- Test results.
- Build status.
- Known issues.
- Next steps.

---

# FINAL PRODUCT VISION

TASKLY should become a premium, reliable, offline-first personal productivity application.

It should combine smart alarms, spoken reminders, tasks, calendar events, important dates, and wishlist management in one beautiful interface.

The most important experience is:

A user schedules a task.

TASKLY remembers it.

When the time arrives, TASKLY tells the user exactly what they planned to do.

No AI agent required.

No mandatory subscription.

No paid API dependency.

**TASKLY — Don't just remind me when. Remind me what.**



## CRITICAL REQUIREMENT: RELIABLE ANDROID BACKGROUND EXECUTION

TASKLY must reliably trigger scheduled reminders even when:
- The app is in the background.
- The user leaves the app.
- The app is removed from the recent-apps screen.
- The phone screen is locked or turned off.
- The phone has been restarted (restore eligible scheduled reminders).

### Technical implementation
1. Use Android native AlarmManager through a reliable Flutter plugin or a custom Kotlin platform integration where necessary.
2. Use exact alarms when permitted and appropriate. Handle Android exact-alarm permissions and restrictions.
3. Use BroadcastReceivers to receive scheduled alarm events independently of the Flutter UI.
4. Use notifications with appropriate alarm channels, sound, and full-screen alarm UI where Android permits.
5. Use boot receivers to restore scheduled reminders after device restart.
6. Handle device time changes, timezone changes, app updates, and permission changes.
7. Use unique PendingIntent identities so reminders do not overwrite one another.
8. Use WorkManager for suitable background maintenance tasks, not as a replacement for precise alarm scheduling.
9. Persist every reminder in the local database so scheduled alarms can be reconstructed.
10. Handle battery optimization and manufacturer-specific background restrictions gracefully.

### Spoken reminders
- When Android permits background speech, use the native Android TextToSpeech service to speak the reminder.
- Do not assume Flutter's TTS plugin will reliably speak after the app process is terminated.
- If background speech is restricted or unavailable, show a prominent alarm notification and open the alarm screen when the user interacts with it.
- Never silently lose a reminder because speech could not start.

### Important Android limitation
Do not claim that TASKLY works after a user force-stops the app from Android Settings. Android deliberately blocks background execution after a force-stop until the user manually launches the app again. Explain this limitation in the app if needed.

### Mandatory testing
Test on a physical Android device:
- App open.
- App in background.
- App removed from recent apps.
- Screen locked.
- Device restarted.
- Battery saver enabled.
- Exact-alarm permission denied.
- Notification permission denied.
- App force-stopped.

Do not mark background reminders complete until these tests have been performed and their results documented.
</USER_REQUEST>
<ADDITIONAL_METADATA>
The current local time is: 2026-11-05T10:40:53+05:30.
</ADDITIONAL_METADATA>
<USER_SETTINGS_CHANGE>
The user changed setting `Model Selection` from None to Gemini 3.8 Flash (High). No need to comment on this change if the user doesn't ask about it. If reporting what model you are, please use a human readable name instead of the exact string.
</USER_SETTINGS_CHANGE>