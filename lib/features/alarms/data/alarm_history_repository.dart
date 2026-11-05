import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final alarmHistoryRepositoryProvider = Provider<AlarmHistoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AlarmHistoryRepository(db);
});

class AlarmHistoryRepository {
  final AppDatabase _db;

  AlarmHistoryRepository(this._db);

  Stream<List<AlarmHistoryData>> watchHistory() {
    return (_db.select(
      _db.alarmHistory,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.triggeredAt)])).watch();
  }

  Future<void> logAlarmAction({
    required String id,
    required String reminderId,
    required String title,
    required DateTime triggeredAt,
    required String
    actionTaken, // 'completed', 'snoozed', 'stopped', 'missed', 'rescheduled'
    String? spokenMessage,
  }) async {
    await _db
        .into(_db.alarmHistory)
        .insert(
          AlarmHistoryCompanion.insert(
            id: id,
            reminderId: reminderId,
            title: title,
            triggeredAt: triggeredAt,
            actionTaken: actionTaken,
            spokenMessage: Value(spokenMessage),
          ),
        );
  }

  Future<void> clearHistory() async {
    await _db.delete(_db.alarmHistory).go();
  }
}
