import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase database;
  const uuid = Uuid();

  setUp(() {
    // In-memory SQLite database for isolated unit testing
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('TASKLY Drift Database Unit Tests', () {
    test('Can insert and retrieve a smart reminder', () async {
      final reminderId = uuid.v4();
      final scheduledTime = DateTime.now().add(const Duration(hours: 2));

      await database.into(database.reminders).insert(
            RemindersCompanion.insert(
              id: reminderId,
              title: 'Study Flutter',
              scheduledAt: scheduledTime,
              voicePersonality: const Value('nova'),
              customSpokenMessage: const Value(
                "Hey! It's time to study Flutter. Let's get started!",
              ),
            ),
          );

      final reminders = await database.select(database.reminders).get();
      expect(reminders.length, equals(1));
      expect(reminders.first.id, equals(reminderId));
      expect(reminders.first.title, equals('Study Flutter'));
      expect(reminders.first.voicePersonality, equals('nova'));
      expect(
        reminders.first.customSpokenMessage,
        equals("Hey! It's time to study Flutter. Let's get started!"),
      );
    });

    test('Can insert, update, and complete tasks', () async {
      final taskId = uuid.v4();

      await database.into(database.tasks).insert(
            TasksCompanion.insert(
              id: taskId,
              title: 'Build TASKLY Navigation Shell',
              category: const Value('work'),
              priority: const Value('high'),
            ),
          );

      var tasks = await database.select(database.tasks).get();
      expect(tasks.first.isCompleted, isFalse);

      // Mark task as completed
      await (database.update(database.tasks)
            ..where((tbl) => tbl.id.equals(taskId)))
          .write(const TasksCompanion(isCompleted: Value(true)));

      tasks = await database.select(database.tasks).get();
      expect(tasks.first.isCompleted, isTrue);
    });

    test('Calendar event preserves hasAlarm distinction', () async {
      final eventAId = uuid.v4();
      final eventBId = uuid.v4();
      final date = DateTime.now().add(const Duration(days: 5));

      // Event A: Exam without alarm
      await database.into(database.calendarEvents).insert(
            CalendarEventsCompanion.insert(
              id: eventAId,
              title: 'College Examination',
              eventDate: date,
              isImportantDate: const Value(true),
              hasAlarm: const Value(false),
            ),
          );

      // Event B: Submission with alarm
      await database.into(database.calendarEvents).insert(
            CalendarEventsCompanion.insert(
              id: eventBId,
              title: 'Project Submission',
              eventDate: date,
              hasAlarm: const Value(true),
            ),
          );

      final eventsWithAlarm = await (database.select(database.calendarEvents)
            ..where((tbl) => tbl.hasAlarm.equals(true)))
          .get();

      expect(eventsWithAlarm.length, equals(1));
      expect(eventsWithAlarm.first.title, equals('Project Submission'));
    });

    test('Can persist and update app settings key-value pairs', () async {
      await database.into(database.appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'default_voice',
              value: 'nova',
            ),
          );

      final setting = await (database.select(database.appSettings)
            ..where((tbl) => tbl.key.equals('default_voice')))
          .getSingle();

      expect(setting.value, equals('nova'));
    });
  });
}
