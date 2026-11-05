import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for dynamic application theme mode (system, dark, light).
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});
