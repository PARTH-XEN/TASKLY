import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class UpcomingRemindersList extends StatelessWidget {
  const UpcomingRemindersList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Reminders',
                style: theme.textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: isDark ? AppColors.indigoLight : AppColors.indigoDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _ReminderItemTile(
            title: 'Study Flutter Architecture',
            timeText: '1:00 PM • Today',
            voiceName: 'Nova',
            voiceColor: AppColors.voiceNova,
            repeatText: 'Never',
            isEnabled: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReminderItemTile(
            title: 'Review Project PRs',
            timeText: '4:30 PM • Today',
            voiceName: 'Max',
            voiceColor: AppColors.voiceMax,
            repeatText: 'Weekdays',
            isEnabled: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReminderItemTile(
            title: 'Evening Health Run',
            timeText: '7:00 PM • Today',
            voiceName: 'Atlas',
            voiceColor: AppColors.voiceAtlas,
            repeatText: 'Daily',
            isEnabled: true,
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

  const _ReminderItemTile({
    required this.title,
    required this.timeText,
    required this.voiceName,
    required this.voiceColor,
    required this.repeatText,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
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
              child: Icon(Icons.record_voice_over_rounded, color: voiceColor, size: 20),
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
                      Text(
                        timeText,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 6),
                      Text('•', style: theme.textTheme.bodySmall),
                      const SizedBox(width: 6),
                      Text(
                        repeatText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.indigoLight : AppColors.indigoDark,
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
    );
  }
}
