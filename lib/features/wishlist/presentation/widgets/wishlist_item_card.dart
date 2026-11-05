import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final ValueChanged<bool>? onToggleCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const WishlistItemCard({
    super.key,
    required this.item,
    this.onToggleCompleted,
    this.onTap,
    this.onDelete,
  });

  (IconData, Color) _getCategoryStyle(String category) {
    switch (category.toLowerCase()) {
      case 'product':
        return (Icons.shopping_bag_outlined, AppColors.warningLight);
      case 'skill':
        return (Icons.school_outlined, AppColors.indigoLight);
      case 'project':
        return (Icons.code_rounded, AppColors.cyanLight);
      case 'travel':
        return (Icons.flight_takeoff_rounded, AppColors.successLight);
      case 'goal':
      default:
        return (Icons.flag_outlined, AppColors.primaryIndigo);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.dangerLight;
      case 'medium':
        return AppColors.warningLight;
      case 'low':
      default:
        return AppColors.cyanLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (catIcon, catColor) = _getCategoryStyle(item.category);
    final priorityColor = _getPriorityColor(item.priority);

    String? targetDateStr;
    if (item.targetDate != null) {
      final daysDiff = item.targetDate!.difference(DateTime.now()).inDays;
      if (daysDiff < 0) {
        targetDateStr = 'Target passed (${DateFormat('MMM d').format(item.targetDate!)})';
      } else if (daysDiff == 0) {
        targetDateStr = 'Target: Today';
      } else {
        targetDateStr = '$daysDiff days left (${DateFormat('MMM d').format(item.targetDate!)})';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.roundedMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox button
              InkWell(
                onTap: () => onToggleCompleted?.call(!item.isCompleted),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isCompleted
                        ? AppColors.successLight
                        : Colors.transparent,
                    border: Border.all(
                      color: item.isCompleted
                          ? AppColors.successLight
                          : (isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary),
                      width: 2,
                    ),
                  ),
                  child: item.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: item.isCompleted
                            ? (isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary)
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                      ),
                    ),
                    if (item.description != null &&
                        item.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),

                    // Badges row
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(catIcon, size: 12, color: catColor),
                              const SizedBox(width: 4),
                              Text(
                                item.category.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: catColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Priority badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.priority.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ),

                        // Target date countdown
                        if (targetDateStr != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.flag_circle_rounded,
                                size: 12,
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                targetDateStr,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete button
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                  onPressed: onDelete,
                  tooltip: 'Delete Item',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
