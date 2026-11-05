import 'package:drift/drift.dart';

/// Productivity focus sessions table schema.
class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable()();
  IntColumn get durationMinutes => integer()();
  DateTimeColumn get completedAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
