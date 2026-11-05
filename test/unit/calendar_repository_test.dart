import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/calendar/data/calendar_repository.dart';
import 'package:taskly/services/alarm_service.dart';

class MockAlarmService implements AlarmService {
  final List<String> scheduledAlarms = [];
  final List<String> cancelledAlarms = [];

  @override
  Future<bool> scheduleReminder({
    required String id,
    required String title,
    required DateTime scheduledAt,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
  }) async {
    scheduledAlarms.add(id);
    return true;
  }

  @override
  Future<void> cancelReminder(String id) async {
    cancelledAlarms.add(id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AppDatabase db;
  late MockAlarmService mockAlarmService;
  late CalendarRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockAlarmService = MockAlarmService();
    repository = CalendarRepository(db, mockAlarmService);
  });

  tearDown(() async {
    await db.close();
  });

  group('CalendarRepository & hasAlarm Unit Tests', () {
    test('createEvent with hasAlarm == false saves event and NEVER schedules alarm',
        () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      await repository.createEvent(
        id: 'evt-silent',
        title: 'Project Milestone Review',
        description: 'Silent calendar milestone without alarm',
        eventDate: tomorrow,
        hasAlarm: false,
      );

      final events = await repository.watchAllEvents().first;
      expect(events.length, 1);
      expect(events.first.hasAlarm, isFalse);
      expect(events.first.title, 'Project Milestone Review');

      // Crucial: AlarmService must NOT have been called
      expect(mockAlarmService.scheduledAlarms, isEmpty);
    });

    test('createEvent with hasAlarm == true saves event AND schedules exact alarm',
        () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      await repository.createEvent(
        id: 'evt-alarm',
        title: 'Final Exam',
        description: 'Crucial exam reminder',
        eventDate: tomorrow,
        startTime: '10:00',
        hasAlarm: true,
      );

      final events = await repository.watchAllEvents().first;
      expect(events.length, 1);
      expect(events.first.hasAlarm, isTrue);

      // Crucial: AlarmService MUST have been called
      expect(mockAlarmService.scheduledAlarms, contains('evt-alarm'));
    });

    test('updateEvent toggling hasAlarm from true to false cancels the alarm',
        () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      await repository.createEvent(
        id: 'evt-toggle',
        title: 'Dentist Visit',
        eventDate: tomorrow,
        startTime: '14:00',
        hasAlarm: true,
      );
      expect(mockAlarmService.scheduledAlarms, contains('evt-toggle'));

      await repository.updateEvent(
        id: 'evt-toggle',
        title: 'Dentist Visit',
        eventDate: tomorrow,
        startTime: '14:00',
        hasAlarm: false, // Turned off alarm
      );

      expect(mockAlarmService.cancelledAlarms, contains('evt-toggle'));
    });

    test('deleteEvent on event with hasAlarm == true cancels the scheduled alarm',
        () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      await repository.createEvent(
        id: 'evt-del',
        title: 'Flight Departure',
        eventDate: tomorrow,
        startTime: '18:00',
        hasAlarm: true,
      );

      await repository.deleteEvent('evt-del');

      expect(mockAlarmService.cancelledAlarms, contains('evt-del'));
      final events = await repository.watchAllEvents().first;
      expect(events, isEmpty);
    });

    test('watchEventsForDate filters events matching the exact year, month, and day',
        () async {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));

      await repository.createEvent(
        id: 'e1',
        title: 'Today Event 1',
        eventDate: today,
        startTime: '11:00',
      );
      await repository.createEvent(
        id: 'e2',
        title: 'Today Event 2',
        eventDate: today,
        startTime: '09:00',
      );
      await repository.createEvent(
        id: 'e3',
        title: 'Tomorrow Event',
        eventDate: tomorrow,
      );

      final todayEvents = await repository.watchEventsForDate(today).first;
      expect(todayEvents.length, 2);
      // Check sorted order by startTime (09:00 before 11:00)
      expect(todayEvents[0].title, 'Today Event 2');
      expect(todayEvents[1].title, 'Today Event 1');
    });
  });
}
