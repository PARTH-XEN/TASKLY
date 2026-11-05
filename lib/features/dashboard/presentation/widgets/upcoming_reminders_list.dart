import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../reminders/data/reminders_repository.dart';

class UpcomingRemindersList extends ConsumerWidget {
  const UpcomingRemindersList({super.key});

  Color _getVoiceColor(String voice) {
    switch (voice.toLowerCase()) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final remindersAsync = ref.watch(upcomingRemindersStreamProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upcoming Reminders', style: theme.textTheme.titleLarge),
              TextButton(
                onPressed: () => context.push('/alarm-history'),
                child: Text(
                  'History',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.indigoLight
                        : AppColors.indigoDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          remindersAsync.when(
            data: (reminders) {
              if (reminders.isEmpty) {
                // Default helpful samples when fresh
                return Column(
                  children: [
                    _ReminderItemTile(
                      title: 'Study Flutter Architecture',
                      timeText: '1:00 PM • Today',
                      voiceName: 'Nova',
                      voiceColor: AppColors.voiceNova,
                      repeatText: 'Never',
                      isEnabled: true,
                      onTap: () {
                        context.push(
                          '/alarm',
                          extra: {
                            'reminderId': 'sample-1',
                            'title': 'Study Flutter Architecture',
                            'scheduledTimeText': '1:00 PM',
                            'voicePersonality': 'nova',
                            'spokenMessage': "Hey! It's time to study Flutter Architecture. Let's get started!",
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _ReminderItemTile(
                      title: 'Review Project PRs',
                      timeText: '4:30 PM • Today',
                      voiceName: 'Max',
                      voiceColor: AppColors.voiceMax,
                      repeatText: 'Weekdays',
                      isEnabled: true,
                      onTap: () {
                        context.push(
                          '/alarm',
                          extra: {
                            'reminderId': 'sample-2',
                            'title': 'Review Project PRs',
                            'scheduledTimeText': '4:30 PM',
                            'voicePersonality': 'max',
                            'spokenMessage': "Hey! Time to review your open project pull requests!",
                          },
                        );
                      },
                    ),
                  ],
                );
              }

              return Column(
                children: reminders.map((r) {
                  final voiceColor = _getVoiceColor(r.voicePersonality);
                  final timeFormatted = DateFormat('h:mm a • EEE, MMM d')
                      .format(r.scheduledAt);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _ReminderItemTile(
                      title: r.title,
                      timeText: timeFormatted,
                      voiceName: r.voicePersonality.toUpperCase(),
                      voiceColor: voiceColor,
                      repeatText: r.repeatFrequency == 'none'
                          ? 'Once'
                          : r.repeatFrequency,
                      isEnabled: r.isEnabled,
                      onTap: () {
                        context.push(
                          '/alarm',
                          extra: {
                            'reminderId': r.id,
                            'title': r.title,
                            'scheduledTimeText': DateFormat('h:mm a')
                                .format(r.scheduledAt),
                            'voicePersonality': r.voicePersonality,
                            'spokenMessage':
                                r.customSpokenMessage ??
                                "Hey! It's time to ${r.title}. Let's get started!",
                          },
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Text('Error: $err'),
          ),
        ],
      ),
    );
  }
}

class _ReminderItemTile extends StatelessWidget {
  final String title;
  final String timeText;
  final String voiceName;
  final Color voiceColor;
  final String repeatText;
  final bool isEnabled;
  final VoidCallback onTap;

  const _ReminderItemTile({
    required this.title,
    required this.timeText,
    required this.voiceName,
    required this.voiceColor,
    required this.repeatText,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.roundedLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: voiceColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Icon(
                  Icons.record_voice_over_rounded,
                  color: voiceColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(timeText, style: theme.textTheme.bodySmall),
                        const SizedBox(width: 6),
                        Text('•', style: theme.textTheme.bodySmall),
                        const SizedBox(width: 6),
                        Text(
                          repeatText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.indigoLight
                                : AppColors.indigoDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: voiceColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  voiceName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: voiceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
