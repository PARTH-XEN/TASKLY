import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../reminders/data/reminders_repository.dart';
import '../data/alarm_history_repository.dart';
import 'widgets/waveform_visualizer.dart';

class AlarmScreen extends ConsumerStatefulWidget {
  final String reminderId;
  final String title;
  final String scheduledTimeText;
  final String voicePersonality;
  final String spokenMessage;

  const AlarmScreen({
    super.key,
    required this.reminderId,
    this.title = 'Study Flutter Architecture',
    this.scheduledTimeText = '10:00 AM',
    this.voicePersonality = 'nova',
    this.spokenMessage =
        "Hey! It's time to study Flutter Architecture. Let's get started!",
  });

  @override
  ConsumerState<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends ConsumerState<AlarmScreen> {
  late DateTime _currentTime;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _currentTime = DateTime.now());
      }
    });

    // Provide tactile alarm vibration
    HapticFeedback.vibrate();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Color get _voiceColor {
    switch (widget.voicePersonality.toLowerCase()) {
      case 'max':
        return AppColors.voiceMax;
      case 'atlas':
        return AppColors.voiceAtlas;
      case 'echo':
        return AppColors.voiceEcho;
      case 'nova':
      default:
        return AppColors.voiceNova;
    }
  }

  Future<void> _logAction(String action) async {
    final historyRepo = ref.read(alarmHistoryRepositoryProvider);
    await historyRepo.logAlarmAction(
      id: const Uuid().v4(),
      reminderId: widget.reminderId,
      title: widget.title,
      triggeredAt: DateTime.now(),
      actionTaken: action,
      spokenMessage: widget.spokenMessage,
    );
  }

  Future<void> _onStop() async {
    HapticFeedback.heavyImpact();
    await _logAction('stopped');
    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _onSnooze() async {
    HapticFeedback.mediumImpact();
    final alarmService = ref.read(alarmServiceProvider);
    await alarmService.snoozeReminder(
      id: widget.reminderId,
      title: widget.title,
      snoozeMinutes: 10,
      customSpokenMessage: widget.spokenMessage,
      voicePersonality: widget.voicePersonality,
    );
    await _logAction('snoozed');

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Snoozed for 10 minutes')));
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _onComplete() async {
    HapticFeedback.mediumImpact();
    await _logAction('completed');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Great job! Reminder marked complete.'),
          backgroundColor: AppColors.successDark,
        ),
      );
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _onReschedule() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && mounted) {
      final now = DateTime.now();
      final newTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      final alarmService = ref.read(alarmServiceProvider);

      await alarmService.scheduleReminder(
        id: widget.reminderId,
        title: widget.title,
        scheduledAt: newTime,
        customSpokenMessage: widget.spokenMessage,
        voicePersonality: widget.voicePersonality,
      );

      await _logAction('rescheduled');

      if (mounted) {
        Navigator.of(context).maybePop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final timeFormatted = DateFormat('h:mm:ss a').format(_currentTime);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0C14)
          : const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),

              // Voice Personality Banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _voiceColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.roundedFull,
                  border: Border.all(color: _voiceColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.record_voice_over_rounded,
                      color: _voiceColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'VOICE: ${widget.voicePersonality.toUpperCase()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _voiceColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Live Current Time
              Text(
                timeFormatted,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Large Reminder Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Scheduled for ${widget.scheduledTimeText}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),

              const Spacer(),

              // Animated Sound Waveform (USP)
              WaveformVisualizer(color: _voiceColor, height: 80),
              const SizedBox(height: AppSpacing.xl),

              // Spoken task speech bubble
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161A28) : Colors.white,
                  borderRadius: AppRadius.roundedLg,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _voiceColor.withValues(alpha: 0.1),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: _voiceColor,
                      size: 28,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        widget.spokenMessage,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons (Thumb Zone)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onStop,
                      icon: const Icon(
                        Icons.stop_circle_outlined,
                        color: AppColors.dangerLight,
                      ),
                      label: const Text(
                        'Stop',
                        style: TextStyle(color: AppColors.dangerLight),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.dangerLight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _onSnooze,
                      icon: const Icon(Icons.snooze_rounded),
                      label: const Text('Snooze 10m'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceElevated
                            : AppColors.lightSurfaceElevated,
                        foregroundColor: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Complete Task Prominent Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onComplete,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Mark as Completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successLight,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Reschedule link
              TextButton(
                onPressed: _onReschedule,
                child: const Text('Reschedule for another time'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
