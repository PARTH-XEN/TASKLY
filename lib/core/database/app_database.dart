import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/alarm_history_table.dart';
import 'tables/app_settings_table.dart';
import 'tables/calendar_events_table.dart';
import 'tables/focus_sessions_table.dart';
import 'tables/reminders_table.dart';
import 'tables/tasks_table.dart';
import 'tables/wishlist_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Reminders,
    Tasks,
    CalendarEvents,
    WishlistItems,
    AlarmHistory,
    FocusSessions,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'taskly_db');
  }
}
