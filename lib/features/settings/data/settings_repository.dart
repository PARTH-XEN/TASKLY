import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepository(db);
});

final themeModeStreamProvider = StreamProvider<ThemeMode>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchThemeMode();
});

final defaultSnoozeMinutesStreamProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchDefaultSnoozeMinutes();
});

final timeFormat24hStreamProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchTimeFormat24h();
});

final firstDayOfWeekStreamProvider = StreamProvider<String>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchFirstDayOfWeek();
});

final hapticFeedbackStreamProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchHapticFeedback();
});

class SettingsRepository {
  final AppDatabase _db;

  static const String keyThemeMode = 'theme_mode';
  static const String keyDefaultSnooze = 'default_snooze_minutes';
  static const String keyTimeFormat24h = 'time_format_24h';
  static const String keyFirstDayOfWeek = 'first_day_of_week';
  static const String keyHapticFeedback = 'haptic_feedback';

  SettingsRepository(this._db);

  Stream<String> watchSetting(String key, String defaultValue) {
    final query = _db.select(_db.appSettings)
      ..where((tbl) => tbl.key.equals(key));
    return query.watchSingleOrNull().map(
      (setting) => setting?.value ?? defaultValue,
    );
  }

  Future<String?> getSetting(String key) async {
    final query = _db.select(_db.appSettings)
      ..where((tbl) => tbl.key.equals(key));
    final setting = await query.getSingleOrNull();
    return setting?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Stream<ThemeMode> watchThemeMode() {
    return watchSetting(keyThemeMode, 'system').map((val) {
      switch (val) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    });
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final str = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await setSetting(keyThemeMode, str);
  }

  Stream<int> watchDefaultSnoozeMinutes() {
    return watchSetting(
      keyDefaultSnooze,
      '10',
    ).map((val) => int.tryParse(val) ?? 10);
  }

  Future<void> setDefaultSnoozeMinutes(int minutes) async {
    await setSetting(keyDefaultSnooze, minutes.toString());
  }

  Stream<bool> watchTimeFormat24h() {
    return watchSetting(keyTimeFormat24h, 'false').map((val) => val == 'true');
  }

  Future<void> setTimeFormat24h(bool is24h) async {
    await setSetting(keyTimeFormat24h, is24h.toString());
  }

  Stream<String> watchFirstDayOfWeek() {
    return watchSetting(keyFirstDayOfWeek, 'monday');
  }

  Future<void> setFirstDayOfWeek(String day) async {
    await setSetting(keyFirstDayOfWeek, day);
  }

  Stream<bool> watchHapticFeedback() {
    return watchSetting(keyHapticFeedback, 'true').map((val) => val == 'true');
  }

  Future<void> setHapticFeedback(bool enabled) async {
    await setSetting(keyHapticFeedback, enabled.toString());
  }
}
