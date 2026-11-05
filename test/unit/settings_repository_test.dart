import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SettingsRepository Unit Tests', () {
    test(
      'watchThemeMode returns ThemeMode.system by default and updates',
      () async {
        expect(await repo.watchThemeMode().first, equals(ThemeMode.system));

        await repo.setThemeMode(ThemeMode.dark);
        expect(await repo.watchThemeMode().first, equals(ThemeMode.dark));

        await repo.setThemeMode(ThemeMode.light);
        expect(await repo.watchThemeMode().first, equals(ThemeMode.light));
      },
    );

    test(
      'watchDefaultSnoozeMinutes returns 10 by default and updates',
      () async {
        expect(await repo.watchDefaultSnoozeMinutes().first, equals(10));

        await repo.setDefaultSnoozeMinutes(15);
        expect(await repo.watchDefaultSnoozeMinutes().first, equals(15));
      },
    );

    test('watchTimeFormat24h returns false by default and updates', () async {
      expect(await repo.watchTimeFormat24h().first, equals(false));

      await repo.setTimeFormat24h(true);
      expect(await repo.watchTimeFormat24h().first, equals(true));
    });

    test('watchFirstDayOfWeek returns monday by default and updates', () async {
      expect(await repo.watchFirstDayOfWeek().first, equals('monday'));

      await repo.setFirstDayOfWeek('sunday');
      expect(await repo.watchFirstDayOfWeek().first, equals('sunday'));
    });

    test('watchHapticFeedback returns true by default and updates', () async {
      expect(await repo.watchHapticFeedback().first, equals(true));

      await repo.setHapticFeedback(false);
      expect(await repo.watchHapticFeedback().first, equals(false));
    });
  });
}
