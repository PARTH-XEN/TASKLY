import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../productivity/data/focus_repository.dart';
import '../../../tasks/data/tasks_repository.dart';

class TodaySummaryCard extends ConsumerWidget {
  final int? pendingTasks;
  final int? completedTasks;

  const TodaySummaryCard({super.key, this.pendingTasks, this.completedTasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final statsAsync = ref.watch(taskStatsStreamProvider);
    final focusMinutesAsync = ref.watch(todayFocusMinutesStreamProvider);
    final todayFocusMinutes = focusMinutesAsync.value ?? 0;

    final actualPending = pendingTasks ?? statsAsync.value?.pendingCount ?? 0;
    final actualCompleted =
        completedTasks ?? statsAsync.value?.completedCount ?? 0;

    final total = actualPending + actualCompleted;
    final double completionRate = total > 0 ? (actualCompleted / total) : 0.0;
    final int percentage = (completionRate * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Overview", style: theme.textTheme.titleLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successLight.withValues(alpha: 0.15),
                      borderRadius: AppRadius.roundedSm,
                    ),
                    child: Text(
                      '$percentage% DONE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.successLight
                            : AppColors.successDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: AppRadius.roundedFull,
                child: LinearProgressIndicator(
                  value: completionRate,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceElevated
                      : AppColors.lightSurfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.successLight,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Pending',
                      valueText: actualPending.toString(),
                      color: AppColors.warningLight,
                      icon: Icons.pending_actions_rounded,
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  Expanded(
                    child: _StatTile(
                      label: 'Completed',
                      valueText: actualCompleted.toString(),
                      color: AppColors.successLight,
                      icon: Icons.task_alt_rounded,
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  Expanded(
                    child: _StatTile(
                      label: 'Focus',
                      valueText: '${todayFocusMinutes}m',
                      color: AppColors.indigoLight,
                      icon: Icons.timer_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String valueText;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.valueText,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs + 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadius.roundedSm,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              valueText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
