import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/tasks_repository.dart';

class TaskFilterBar extends StatelessWidget {
  final TaskFilter selectedFilter;
  final String? selectedCategory;
  final ValueChanged<TaskFilter> onFilterChanged;
  final ValueChanged<String?> onCategoryChanged;

  const TaskFilterBar({
    super.key,
    required this.selectedFilter,
    required this.selectedCategory,
    required this.onFilterChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filters = [
      (TaskFilter.all, 'All', Icons.list_alt_rounded),
      (TaskFilter.today, 'Today', Icons.today_rounded),
      (TaskFilter.upcoming, 'Upcoming', Icons.upcoming_rounded),
      (TaskFilter.overdue, 'Overdue', Icons.warning_amber_rounded),
      (TaskFilter.completed, 'Completed', Icons.check_circle_rounded),
    ];

    final categories = [
      (null, 'All Categories'),
      ('personal', 'Personal'),
      ('work', 'Work'),
      ('study', 'Study'),
      ('health', 'Health'),
      ('projects', 'Projects'),
      ('other', 'Other'),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status/Time filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: filters.map((item) {
              final isSelected = selectedFilter == item.$1;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: ChoiceChip(
                  avatar: Icon(
                    item.$3,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  label: Text(item.$2),
                  selected: isSelected,
                  selectedColor: AppColors.indigoLight,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceElevated
                      : AppColors.lightSurfaceElevated,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.indigoLight
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  onSelected: (selected) {
                    if (selected) onFilterChanged(item.$1);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Category filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: categories.map((cat) {
              final isSelected = selectedCategory == cat.$1 ||
                  (selectedCategory == null && cat.$1 == null);
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: FilterChip(
                  label: Text(cat.$2),
                  selected: isSelected,
                  checkmarkColor: AppColors.indigoLight,
                  selectedColor: AppColors.indigoLight.withValues(alpha: 0.15),
                  backgroundColor: Colors.transparent,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColors.indigoLight
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.indigoLight
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  onSelected: (_) => onCategoryChanged(cat.$1),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
