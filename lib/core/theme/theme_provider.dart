import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/settings_repository.dart';

/// Provider for dynamic application theme mode (system, dark, light),
/// initialized and synchronized with persisted SQLite app settings.
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final settingAsync = ref.watch(themeModeStreamProvider);
  return settingAsync.value ?? ThemeMode.system;
});
