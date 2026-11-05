import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FocusRepository(db);
});

final todayFocusMinutesStreamProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(focusRepositoryProvider);
  return repo.watchTodayFocusMinutes();
});

final totalFocusSessionsStreamProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(focusRepositoryProvider);
  return repo.watchTotalSessions();
});

class FocusRepository {
  final AppDatabase _db;

  FocusRepository(this._db);

  Stream<int> watchTodayFocusMinutes() {
    return _db.select(_db.focusSessions).watch().map((sessions) {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      int totalMinutes = 0;
      for (final s in sessions) {
        if (s.completedAt.isAfter(
              todayStart.subtract(const Duration(seconds: 1)),
            ) &&
            s.completedAt.isBefore(todayEnd.add(const Duration(seconds: 1)))) {
          totalMinutes += s.durationMinutes;
        }
      }
      return totalMinutes;
    });
  }

  Stream<int> watchTotalSessions() {
    return _db.select(_db.focusSessions).watch().map((s) => s.length);
  }

  Future<void> logFocusSession({
    required String id,
    required int durationMinutes,
    String? taskId,
    String? notes,
  }) async {
    await _db
        .into(_db.focusSessions)
        .insert(
          FocusSessionsCompanion.insert(
            id: id,
            durationMinutes: durationMinutes,
            taskId: Value(taskId),
            notes: Value(notes),
            completedAt: Value(DateTime.now()),
          ),
        );
  }
}
