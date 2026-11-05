import 'package:drift/drift.dart';

/// Calendar events and important dates table schema.
class CalendarEvents extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  IntColumn get categoryColor =>
      integer().withDefault(const Constant(0xFF6366F1))();
  BoolColumn get isImportantDate =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hasAlarm => boolean().withDefault(const Constant(false))();
  TextColumn get reminderId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
