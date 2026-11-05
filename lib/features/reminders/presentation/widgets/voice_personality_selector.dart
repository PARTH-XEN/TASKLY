import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class VoicePersonalitySelector extends StatelessWidget {
  final String selectedPersonality;
  final ValueChanged<String> onSelected;

  const VoicePersonalitySelector({
    super.key,
    required this.selectedPersonality,
    required this.onSelected,
  });

  static const List<Map<String, dynamic>> personalities = [
    {
      'id': 'nova',
      'name': 'Nova',
      'trait': 'Friendly, calm & encouraging',
      'color': AppColors.voiceNova,
    },
    {
      'id': 'max',
      'name': 'Max',
      'trait': 'Energetic & motivating',
      'color': AppColors.voiceMax,
    },
    {
      'id': 'atlas',
      'name': 'Atlas',
      'trait': 'Professional & direct',
      'color': AppColors.voiceAtlas,
    },
    {
      'id': 'echo',
      'name': 'Echo',
      'trait': 'Simple & minimal',
      'color': AppColors.voiceEcho,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: personalities.map((p) {
        final id = p['id'] as String;
        final name = p['name'] as String;
        final trait = p['trait'] as String;
        final color = p['color'] as Color;
        final isSelected = selectedPersonality.toLowerCase() == id;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () => onSelected(id),
            borderRadius: AppRadius.roundedMd,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                    : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated),
                borderRadius: AppRadius.roundedMd,
                border: Border.all(
                  color: isSelected
                      ? color
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic_rounded, color: color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : null,
                          ),
                        ),
                        Text(
                          trait,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle_rounded, color: color, size: 22),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
