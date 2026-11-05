import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Centralized Material 3 ThemeData generator for TASKLY.
abstract class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = AppTypography.createTextTheme(Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.indigoLight,
        onPrimary: AppColors.darkBackground,
        primaryContainer: Color(0xFF312E81),
        onPrimaryContainer: Color(0xFFE0E7FF),
        secondary: AppColors.cyanLight,
        onSecondary: AppColors.darkBackground,
        secondaryContainer: Color(0xFF0C4A6E),
        onSecondaryContainer: Color(0xFFBAE6FD),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceElevated,
        error: AppColors.dangerLight,
        onError: AppColors.darkBackground,
        outline: AppColors.darkBorder,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedLg,
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        height: 72,
        indicatorColor: AppColors.indigoLight.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.indigoLight, size: 24);
          }
          return const IconThemeData(color: AppColors.darkTextTertiary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.indigoLight,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextTertiary,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.indigoLight,
        foregroundColor: AppColors.darkBackground,
        elevation: 4,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.indigoLight,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.2),
          minimumSize: const Size(double.infinity, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.indigoLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.dangerLight),
        ),
        hintStyle: const TextStyle(color: AppColors.darkTextTertiary, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = AppTypography.createTextTheme(Brightness.light);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.indigoDark,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE0E7FF),
        onPrimaryContainer: Color(0xFF312E81),
        secondary: AppColors.cyanDark,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFBAE6FD),
        onSecondaryContainer: Color(0xFF0C4A6E),
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: AppColors.lightSurfaceElevated,
        error: AppColors.dangerDark,
        onError: Colors.white,
        outline: AppColors.lightBorder,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedLg,
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 0,
        height: 72,
        indicatorColor: AppColors.indigoDark.withValues(alpha: 0.1),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.indigoDark, size: 24);
          }
          return const IconThemeData(color: AppColors.lightTextTertiary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.indigoDark,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextTertiary,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.indigoDark,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.indigoDark,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          side: const BorderSide(color: AppColors.lightBorder, width: 1.2),
          minimumSize: const Size(double.infinity, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.indigoDark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: const BorderSide(color: AppColors.dangerDark),
        ),
        hintStyle: const TextStyle(color: AppColors.lightTextTertiary, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
