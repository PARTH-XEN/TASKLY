import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized accessible typography configured for 100% offline-first reliability.
abstract class AppTypography {
  static const List<String> fontFallbacks = [
    'Plus Jakarta Sans',
    'Inter',
    'Roboto',
    'Segoe UI',
    'sans-serif',
  ];

  static TextTheme createTextTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: primaryColor,
        height: 1.2,
        fontFamilyFallback: fontFallbacks,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: primaryColor,
        height: 1.25,
        fontFamilyFallback: fontFallbacks,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: primaryColor,
        height: 1.3,
        fontFamilyFallback: fontFallbacks,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primaryColor,
        height: 1.35,
        fontFamilyFallback: fontFallbacks,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.4,
        fontFamilyFallback: fontFallbacks,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        height: 1.4,
        fontFamilyFallback: fontFallbacks,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        height: 1.45,
        fontFamilyFallback: fontFallbacks,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        height: 1.45,
        fontFamilyFallback: fontFallbacks,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        height: 1.5,
        fontFamilyFallback: fontFallbacks,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
        fontFamilyFallback: fontFallbacks,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.4,
        fontFamilyFallback: fontFallbacks,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primaryColor,
        fontFamilyFallback: fontFallbacks,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: secondaryColor,
        fontFamilyFallback: fontFallbacks,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: secondaryColor,
        fontFamilyFallback: fontFallbacks,
      ),
    );
  }
}
