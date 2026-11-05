import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class RelativeDurationChips extends StatelessWidget {
  final int? selectedMinutes;
  final ValueChanged<int?> onSelected;

  const RelativeDurationChips({
    super.key,
    required this.selectedMinutes,
    required this.onSelected,
  });

  static const List<Map<String, dynamic>> options = [
    {'label': '+15m', 'minutes': 15},
    {'label': '+30m', 'minutes': 30},
    {'label': '+1h', 'minutes': 60},
    {'label': '+2h', 'minutes': 120},
    {'label': '+3h', 'minutes': 180},
    {'label': 'Custom', 'minutes': null},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((opt) {
          final int? minutes = opt['minutes'] as int?;
          final String label = opt['label'] as String;
          final bool isSelected = selectedMinutes == minutes;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(minutes);
                }
              },
              selectedColor: isDark ? AppColors.indigoLight : AppColors.indigoDark,
              labelStyle: TextStyle(
                color: isSelected
                    ? (isDark ? AppColors.darkBackground : Colors.white)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
              backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.roundedFull,
                side: BorderSide(
                  color: isSelected
                      ? (isDark ? AppColors.indigoLight : AppColors.indigoDark)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
