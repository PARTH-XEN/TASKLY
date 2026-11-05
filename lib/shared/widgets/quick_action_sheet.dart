import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Modal bottom sheet presenting quick creation actions.
class QuickActionSheet extends StatelessWidget {
  const QuickActionSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text('Create New', style: theme.textTheme.headlineSmall),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // USP Spoken Reminder
          _ActionCard(
            title: 'Spoken Reminder',
            subtitle: 'Voice alarm that speaks your task aloud',
            icon: Icons.record_voice_over_rounded,
            iconColor: AppColors.indigoLight,
            badge: 'USP',
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Spoken Reminder creation ready for Phase 2'),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // New Task
          _ActionCard(
            title: 'New Task',
            subtitle: 'To-do item with priority & category',
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.successLight,
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task creation ready for Phase 4'),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Calendar Event
          _ActionCard(
            title: 'Calendar Event',
            subtitle: 'Important date or scheduled event',
            icon: Icons.event_rounded,
            iconColor: AppColors.cyanLight,
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calendar event ready for Phase 4'),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Wishlist Item
          _ActionCard(
            title: 'Wishlist Item',
            subtitle: 'Save a goal, product, or skill',
            icon: Icons.bookmark_add_outlined,
            iconColor: AppColors.warningLight,
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist item ready for Phase 4'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String? badge;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.badge,
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
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: AppRadius.roundedLg,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceElevated
                : AppColors.lightSurfaceElevated,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.indigoLight.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.indigoLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.darkTextTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
