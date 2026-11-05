import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Predefined offline voice personality model for TASKLY.
class VoicePersonality {
  final String id;
  final String name;
  final String trait;
  final String description;
  final double defaultRate;
  final double defaultPitch;
  final Color signatureColor;
  final String previewQuote;

  const VoicePersonality({
    required this.id,
    required this.name,
    required this.trait,
    required this.description,
    required this.defaultRate,
    required this.defaultPitch,
    required this.signatureColor,
    required this.previewQuote,
  });

  static const VoicePersonality nova = VoicePersonality(
    id: 'nova',
    name: 'Nova',
    trait: 'Friendly & Encouraging',
    description: 'Warm, calm, and supportive voice that gently helps you stay on track.',
    defaultRate: 0.48,
    defaultPitch: 1.05,
    signatureColor: AppColors.voiceNova,
    previewQuote: "Hey! It's time to get started on your task. You've got this!",
  );

  static const VoicePersonality max = VoicePersonality(
    id: 'max',
    name: 'Max',
    trait: 'Energetic & Enthusiastic',
    description: 'High-energy, fast-paced motivating voice designed to fire you up.',
    defaultRate: 0.58,
    defaultPitch: 1.15,
    signatureColor: AppColors.voiceMax,
    previewQuote: "Let's go! Time to crush your goals and get things done right now!",
  );

  static const VoicePersonality atlas = VoicePersonality(
    id: 'atlas',
    name: 'Atlas',
    trait: 'Professional & Direct',
    description: 'Clear, authoritative, and structured voice for focused productivity.',
    defaultRate: 0.50,
    defaultPitch: 0.90,
    signatureColor: AppColors.voiceAtlas,
    previewQuote: 'Attention: your scheduled activity is due now. Commencing task.',
  );

  static const VoicePersonality echo = VoicePersonality(
    id: 'echo',
    name: 'Echo',
    trait: 'Simple & Minimal',
    description: 'Brief, calm, and straightforward voice with no extra fluff.',
    defaultRate: 0.45,
    defaultPitch: 1.00,
    signatureColor: AppColors.voiceEcho,
    previewQuote: 'Reminder: your scheduled task is ready.',
  );

  static const List<VoicePersonality> all = [nova, max, atlas, echo];

  static VoicePersonality fromId(String? id) {
    if (id == null) return nova;
    final normalized = id.toLowerCase().trim();
    return all.firstWhere(
      (p) => p.id == normalized,
      orElse: () => nova,
    );
  }
}
