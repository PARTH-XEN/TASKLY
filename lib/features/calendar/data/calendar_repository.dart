import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../services/alarm_service.dart';
import '../../reminders/data/reminders_repository.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final alarmService = ref.watch(alarmServiceProvider);
  return CalendarRepository(db, alarmService);
});

final selectedCalendarDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final eventsForSelectedDateStreamProvider = StreamProvider<List<CalendarEvent>>(
  (ref) {
    final repo = ref.watch(calendarRepositoryProvider);
    final selectedDate = ref.watch(selectedCalendarDateProvider);
    return repo.watchEventsForDate(selectedDate);
  },
);

final allCalendarEventsStreamProvider = StreamProvider<List<CalendarEvent>>((
  ref,
) {
  final repo = ref.watch(calendarRepositoryProvider);
  return repo.watchAllEvents();
});

class CalendarRepository {
  final AppDatabase _db;
  final AlarmService _alarmService;

  CalendarRepository(this._db, this._alarmService);

  Stream<List<CalendarEvent>> watchAllEvents() {
    return (_db.select(
      _db.calendarEvents,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.eventDate)])).watch();
  }

  Stream<List<CalendarEvent>> watchEventsForDate(DateTime date) {
    return _db.select(_db.calendarEvents).watch().map((events) {
      return events.where((e) {
        return e.eventDate.year == date.year &&
            e.eventDate.month == date.month &&
            e.eventDate.day == date.day;
      }).toList()..sort((a, b) {
        // Sort by startTime if available, otherwise by title
        if (a.startTime != null && b.startTime != null) {
          return a.startTime!.compareTo(b.startTime!);
        }
        if (a.startTime != null) return -1;
        if (b.startTime != null) return 1;
        return a.title.compareTo(b.title);
      });
    });
  }

  Future<void> createEvent({
    required String id,
    required String title,
    String? description,
    required DateTime eventDate,
    String? startTime,
    String? endTime,
    int categoryColor = 0xFF6366F1,
    bool isImportantDate = false,
    bool hasAlarm = false,
    String? reminderId,
  }) async {
    await _db
        .into(_db.calendarEvents)
        .insert(
          CalendarEventsCompanion.insert(
            id: id,
            title: title,
            description: Value(description),
            eventDate: eventDate,
            startTime: Value(startTime),
            endTime: Value(endTime),
            categoryColor: Value(categoryColor),
            isImportantDate: Value(isImportantDate),
            hasAlarm: Value(hasAlarm),
            reminderId: Value(reminderId),
            createdAt: Value(DateTime.now()),
          ),
        );

    // CRUCIAL: Only schedule an exact alarm if hasAlarm is explicitly true
    if (hasAlarm) {
      final scheduledTime = _calculateEventAlarmDateTime(eventDate, startTime);
      if (scheduledTime.isAfter(DateTime.now())) {
        await _alarmService.scheduleReminder(
          id: id,
          title: title,
          scheduledAt: scheduledTime,
          voicePersonality: 'nova',
          customSpokenMessage:
              'Reminder for your calendar event: $title. It is scheduled now.',
        );
      }
    }
  }

  Future<void> updateEvent({
    required String id,
    required String title,
    String? description,
    required DateTime eventDate,
    String? startTime,
    String? endTime,
    int categoryColor = 0xFF6366F1,
    bool isImportantDate = false,
    required bool hasAlarm,
  }) async {
    await (_db.update(
      _db.calendarEvents,
    )..where((tbl) => tbl.id.equals(id))).write(
      CalendarEventsCompanion(
        title: Value(title),
        description: Value(description),
        eventDate: Value(eventDate),
        startTime: Value(startTime),
        endTime: Value(endTime),
        categoryColor: Value(categoryColor),
        isImportantDate: Value(isImportantDate),
        hasAlarm: Value(hasAlarm),
      ),
    );

    if (hasAlarm) {
      final scheduledTime = _calculateEventAlarmDateTime(eventDate, startTime);
      if (scheduledTime.isAfter(DateTime.now())) {
        await _alarmService.scheduleReminder(
          id: id,
          title: title,
          scheduledAt: scheduledTime,
          voicePersonality: 'nova',
          customSpokenMessage:
              'Reminder for your calendar event: $title. It is scheduled now.',
        );
      }
    } else {
      // If alarm was turned off, cancel any scheduled alarm
      await _alarmService.cancelReminder(id);
    }
  }

  Future<void> deleteEvent(String id) async {
    final existing = await (_db.select(
      _db.calendarEvents,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (existing != null && existing.hasAlarm) {
      await _alarmService.cancelReminder(id);
    }

    await (_db.delete(
      _db.calendarEvents,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  DateTime _calculateEventAlarmDateTime(DateTime eventDate, String? startTime) {
    int hour = 9;
    int minute = 0;

    if (startTime != null && startTime.contains(':')) {
      try {
        final parts = startTime.split(':');
        hour = int.parse(parts[0].trim());
        minute = int.parse(parts[1].trim().split(' ')[0]);
      } catch (_) {}
    }

    return DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      hour,
      minute,
    );
  }
}
