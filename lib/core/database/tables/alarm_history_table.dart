import 'package:drift/drift.dart';

/// Alarm and reminder execution history.
class AlarmHistory extends Table {
  TextColumn get id => text()();
  TextColumn get reminderId => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get triggeredAt => dateTime()();
  TextColumn get actionTaken => text()(); // 'completed', 'snoozed', 'stopped', 'missed', 'rescheduled'
  TextColumn get spokenMessage => text().nullable()();
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

