import 'package:drift/drift.dart';

/// To-do tasks table schema.
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('personal'))();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get dueTime => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get reminderId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

