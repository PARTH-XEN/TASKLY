import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/alarms/data/alarm_history_repository.dart';
import 'package:taskly/features/reminders/data/reminders_repository.dart';
import 'package:taskly/services/alarm_service.dart';
import 'package:uuid/uuid.dart';

class FakeAlarmService extends AlarmService {
  final List<String> scheduledIds = [];
  final List<String> cancelledIds = [];

  @override
  Future<bool> scheduleReminder({
    required String id,
    required String title,
    required DateTime scheduledAt,
    String? customSpokenMessage,
    String voicePersonality = 'nova',
  }) async {
    scheduledIds.add(id);
    return true;
  }

  @override
  Future<void> cancelReminder(String id) async {
    cancelledIds.add(id);
  }
}

void main() {
  late AppDatabase database;
  late FakeAlarmService fakeAlarmService;
  late RemindersRepository remindersRepository;
  late AlarmHistoryRepository historyRepository;
  const uuid = Uuid();

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    fakeAlarmService = FakeAlarmService();
    remindersRepository = RemindersRepository(database, fakeAlarmService);
    historyRepository = AlarmHistoryRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('RemindersRepository & Alarm Sync Tests', () {
    test(
      'createReminder saves to Drift and schedules with AlarmService',
      () async {
        final id = uuid.v4();
        final scheduledAt = DateTime.now().add(const Duration(hours: 2));

        await remindersRepository.createReminder(
          id: id,
          title: 'Study Flutter',
          scheduledAt: scheduledAt,
          voicePersonality: 'nova',
          customSpokenMessage:
              "Hey! It's time to study Flutter. Let's get started!",
        );

        final reminder = await remindersRepository.getReminderById(id);
        expect(reminder, isNotNull);
        expect(reminder!.title, equals('Study Flutter'));
        expect(fakeAlarmService.scheduledIds, contains(id));
      },
    );

    test(
      'deleteReminder removes from Drift and cancels alarm in AlarmService',
      () async {
        final id = uuid.v4();
        final scheduledAt = DateTime.now().add(const Duration(hours: 1));

        await remindersRepository.createReminder(
          id: id,
          title: 'Call Doctor',
          scheduledAt: scheduledAt,
        );

        await remindersRepository.deleteReminder(id);

        final reminder = await remindersRepository.getReminderById(id);
        expect(reminder, isNull);
        expect(fakeAlarmService.cancelledIds, contains(id));
      },
    );

    test(
      'toggleReminder cancels alarm when disabled, reschedules when enabled',
      () async {
        final id = uuid.v4();
        final scheduledAt = DateTime.now().add(const Duration(hours: 3));

        await remindersRepository.createReminder(
          id: id,
          title: 'Gym Workout',
          scheduledAt: scheduledAt,
        );

        // Disable
        await remindersRepository.toggleReminder(id, false);
        expect(fakeAlarmService.cancelledIds, contains(id));

        // Re-enable
        await remindersRepository.toggleReminder(id, true);
        expect(
          fakeAlarmService.scheduledIds.where((i) => i == id).length,
          equals(2),
        );
      },
    );

    test(
      'AlarmHistoryRepository logs and retrieves triggered alarms',
      () async {
        final historyId = uuid.v4();
        final reminderId = uuid.v4();
        final triggerTime = DateTime.now();

        await historyRepository.logAlarmAction(
          id: historyId,
          reminderId: reminderId,
          title: 'Study Flutter',
          triggeredAt: triggerTime,
          actionTaken: 'completed',
          spokenMessage: "Hey! It's time to study Flutter.",
        );

        final historyList = await historyRepository.watchHistory().first;
        expect(historyList.length, equals(1));
        expect(historyList.first.actionTaken, equals('completed'));
        expect(historyList.first.title, equals('Study Flutter'));
      },
    );
  });
}
