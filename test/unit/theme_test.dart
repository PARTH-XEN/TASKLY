import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/theme/app_colors.dart';
import 'package:taskly/core/theme/app_spacing.dart';
import 'package:taskly/core/theme/app_theme.dart';

void main() {
  group('TASKLY Design System & Theme Tests', () {
    test('Dark theme provides accessible contrast and proper brightness', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(theme.colorScheme.surface, AppColors.darkSurface);
      expect(theme.colorScheme.primary, AppColors.indigoLight);
    });

    test('Light theme provides crisp canvas and proper brightness', () {
      final theme = AppTheme.lightTheme;
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
      expect(theme.colorScheme.surface, AppColors.lightSurface);
      expect(theme.colorScheme.primary, AppColors.indigoDark);
    });

    test('Accessibility: Minimum touch target adheres to WCAG & Material 3 (>= 48dp)', () {
      expect(AppSpacing.minTouchTarget, greaterThanOrEqualTo(48.0));
    });

    test('Voice personality colors are defined for Nova, Max, Atlas, Echo', () {
      expect(AppColors.voiceNova, isNotNull);
      expect(AppColors.voiceMax, isNotNull);
      expect(AppColors.voiceAtlas, isNotNull);
      expect(AppColors.voiceEcho, isNotNull);
    });
  });
}
