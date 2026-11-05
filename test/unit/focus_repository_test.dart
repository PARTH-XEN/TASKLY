import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/productivity/data/focus_repository.dart';

void main() {
  late AppDatabase db;
  late FocusRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = FocusRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('FocusRepository Unit Tests', () {
    test('logFocusSession inserts session and watchTodayFocusMinutes calculates accurately', () async {
      await repository.logFocusSession(
        id: 'f-1',
        durationMinutes: 25,
        notes: 'Deep work on Flutter Riverpod',
      );
      await repository.logFocusSession(
        id: 'f-2',
        durationMinutes: 15,
        notes: 'Review code comments',
      );

      final minutes = await repository.watchTodayFocusMinutes().first;
      expect(minutes, 40);

      final totalSessions = await repository.watchTotalSessions().first;
      expect(totalSessions, 2);
    });
  });
}
