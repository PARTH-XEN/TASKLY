import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class QuickActionGrid extends StatelessWidget {
  final VoidCallback onNewReminder;
  final VoidCallback onNewTask;
  final VoidCallback onCalendar;
  final VoidCallback onFocus;

  const QuickActionGrid({
    super.key,
    required this.onNewReminder,
    required this.onNewTask,
    required this.onCalendar,
    required this.onFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _QuickButton(
              title: 'Reminder',
              icon: Icons.record_voice_over_rounded,
              color: AppColors.indigoLight,
              onTap: onNewReminder,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickButton(
              title: 'Task',
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.successLight,
              onTap: onNewTask,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickButton(
              title: 'Calendar',
              icon: Icons.calendar_today_rounded,
              color: AppColors.cyanLight,
              onTap: onCalendar,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _QuickButton(
              title: 'Focus',
              icon: Icons.timer_outlined,
              color: AppColors.warningLight,
              onTap: onFocus,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: AppRadius.roundedLg,
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
