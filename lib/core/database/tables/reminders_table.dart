import 'package:drift/drift.dart';

/// Reminders table schema for smart spoken alarms.
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get relativeDurationMinutes => integer().nullable()();
  TextColumn get voicePersonality => text().withDefault(const Constant('nova'))();
  TextColumn get ttsVoiceName => text().nullable()();
  RealColumn get speechRate => real().withDefault(const Constant(0.5))();
  RealColumn get speechPitch => real().withDefault(const Constant(1.0))();
  TextColumn get repeatFrequency => text().withDefault(const Constant('none'))();
  TextColumn get customSpokenMessage => text().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isSpokenEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

