import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class TodaySummaryCard extends StatelessWidget {
  final int pendingTasks;
  final int completedTasks;

  const TodaySummaryCard({
    super.key,
    this.pendingTasks = 3,
    this.completedTasks = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = pendingTasks + completedTasks;
    final double completionRate = total > 0 ? (completedTasks / total) : 0.0;
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
                      label: 'Pending Tasks',
                      count: pendingTasks,
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
                      count: completedTasks,
                      color: AppColors.successLight,
                      icon: Icons.task_alt_rounded,
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
  final int count;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
