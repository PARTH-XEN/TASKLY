import 'package:flutter/material.dart';

/// Centralized color palette for TASKLY adhering to Material 3
/// and high-contrast accessibility standards.
abstract class AppColors {
  // Brand accents
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color indigoLight = Color(0xFF818CF8);
  static const Color indigoDark = Color(0xFF4F46E5);

  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF38BDF8);
  static const Color cyanDark = Color(0xFF0284C7);

  // Status indicators
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFF87171);
  static const Color dangerDark = Color(0xFFDC2626);

  // Voice Personality signature colors
  static const Color voiceNova = Color(0xFF818CF8); // Friendly indigo
  static const Color voiceMax = Color(0xFFF97316);  // Energetic orange
  static const Color voiceAtlas = Color(0xFF0284C7);// Professional blue
  static const Color voiceEcho = Color(0xFF10B981); // Simple emerald

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F111A);
  static const Color darkSurface = Color(0xFF181B28);
  static const Color darkSurfaceElevated = Color(0xFF222738);
  static const Color darkCard = Color(0xFF181B28);
  static const Color darkBorder = Color(0xFF272B3F);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F3F9);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
}
