import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../services/alarm_service.dart';

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final alarmService = ref.watch(alarmServiceProvider);
  return RemindersRepository(db, alarmService);
});

final allRemindersStreamProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersRepositoryProvider).watchAllReminders();
});

final upcomingRemindersStreamProvider = StreamProvider<List<Reminder>>((ref) {
  return ref.watch(remindersRepositoryProvider).watchUpcomingReminders();
});

class RemindersRepository {
  final AppDatabase _db;
  final AlarmService _alarmService;

  RemindersRepository(this._db, this._alarmService);

  Stream<List<Reminder>> watchAllReminders() {
    return (_db.select(
      _db.reminders,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.scheduledAt)])).watch();
  }

  Stream<List<Reminder>> watchUpcomingReminders() {
    return (_db.select(_db.reminders)
          ..where((tbl) => tbl.isEnabled.equals(true))
          ..where(
            (tbl) => tbl.scheduledAt.isBiggerThan(Variable(DateTime.now())),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.scheduledAt)]))
        .watch();
  }

  Future<Reminder?> getReminderById(String id) {
    return (_db.select(
      _db.reminders,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> createReminder({
    required String id,
    required String title,
    String? description,
    required DateTime scheduledAt,
    int? relativeDurationMinutes,
    String voicePersonality = 'nova',
    String? ttsVoiceName,
    double speechRate = 0.5,
    double speechPitch = 1.0,
    String repeatFrequency = 'none',
    String? customSpokenMessage,
    bool isEnabled = true,
    bool isSpokenEnabled = true,
  }) async {
    await _db
        .into(_db.reminders)
        .insert(
          RemindersCompanion.insert(
            id: id,
            title: title,
            description: Value(description),
            scheduledAt: scheduledAt,
            relativeDurationMinutes: Value(relativeDurationMinutes),
            voicePersonality: Value(voicePersonality),
            ttsVoiceName: Value(ttsVoiceName),
            speechRate: Value(speechRate),
            speechPitch: Value(speechPitch),
            repeatFrequency: Value(repeatFrequency),
            customSpokenMessage: Value(customSpokenMessage),
            isEnabled: Value(isEnabled),
            isSpokenEnabled: Value(isSpokenEnabled),
          ),
        );

    if (isEnabled) {
      await _alarmService.scheduleReminder(
        id: id,
        title: title,
        scheduledAt: scheduledAt,
        customSpokenMessage: customSpokenMessage,
        voicePersonality: voicePersonality,
        speechRate: speechRate,
        speechPitch: speechPitch,
      );
    }
  }

  Future<void> updateReminder({
    required String id,
    required String title,
    String? description,
    required DateTime scheduledAt,
    int? relativeDurationMinutes,
    String voicePersonality = 'nova',
    String? ttsVoiceName,
    double speechRate = 0.5,
    double speechPitch = 1.0,
    String repeatFrequency = 'none',
    String? customSpokenMessage,
    bool isEnabled = true,
    bool isSpokenEnabled = true,
  }) async {
    await (_db.update(_db.reminders)..where((tbl) => tbl.id.equals(id))).write(
      RemindersCompanion(
        title: Value(title),
        description: Value(description),
        scheduledAt: Value(scheduledAt),
        relativeDurationMinutes: Value(relativeDurationMinutes),
        voicePersonality: Value(voicePersonality),
        ttsVoiceName: Value(ttsVoiceName),
        speechRate: Value(speechRate),
        speechPitch: Value(speechPitch),
        repeatFrequency: Value(repeatFrequency),
        customSpokenMessage: Value(customSpokenMessage),
        isEnabled: Value(isEnabled),
        isSpokenEnabled: Value(isSpokenEnabled),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _alarmService.cancelReminder(id);

    if (isEnabled) {
      await _alarmService.scheduleReminder(
        id: id,
        title: title,
        scheduledAt: scheduledAt,
        customSpokenMessage: customSpokenMessage,
        voicePersonality: voicePersonality,
        speechRate: speechRate,
        speechPitch: speechPitch,
      );
    }
  }

  Future<void> deleteReminder(String id) async {
    await _alarmService.cancelReminder(id);
    await (_db.delete(_db.reminders)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    await (_db.update(_db.reminders)..where((tbl) => tbl.id.equals(id))).write(
      RemindersCompanion(
        isEnabled: Value(isEnabled),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final reminder = await getReminderById(id);
    if (reminder != null) {
      if (isEnabled) {
        await _alarmService.scheduleReminder(
          id: id,
          title: reminder.title,
          scheduledAt: reminder.scheduledAt,
          customSpokenMessage: reminder.customSpokenMessage,
          voicePersonality: reminder.voicePersonality,
          speechRate: reminder.speechRate,
          speechPitch: reminder.speechPitch,
        );
      } else {
        await _alarmService.cancelReminder(id);
      }
    }
  }

  Future<void> rescheduleReminder({
    required String id,
    required DateTime newScheduledAt,
  }) async {
    final reminder = await getReminderById(id);
    if (reminder == null) return;

    await updateReminder(
      id: id,
      title: reminder.title,
      description: reminder.description,
      scheduledAt: newScheduledAt,
      relativeDurationMinutes: reminder.relativeDurationMinutes,
      voicePersonality: reminder.voicePersonality,
      ttsVoiceName: reminder.ttsVoiceName,
      speechRate: reminder.speechRate,
      speechPitch: reminder.speechPitch,
      repeatFrequency: reminder.repeatFrequency,
      customSpokenMessage: reminder.customSpokenMessage,
      isEnabled: true,
      isSpokenEnabled: reminder.isSpokenEnabled,
    );
  }
}
