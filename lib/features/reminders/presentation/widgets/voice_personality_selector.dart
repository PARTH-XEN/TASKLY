import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../voice/domain/voice_personality.dart';

class VoicePersonalitySelector extends StatelessWidget {
  final String selectedPersonality;
  final ValueChanged<String> onSelected;
  final ValueChanged<VoicePersonality>? onPreview;

  const VoicePersonalitySelector({
    super.key,
    required this.selectedPersonality,
    required this.onSelected,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: VoicePersonality.all.map((p) {
        final isSelected = selectedPersonality.toLowerCase() == p.id;
        final color = p.signatureColor;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () => onSelected(p.id),
            borderRadius: AppRadius.roundedMd,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                    : (isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightSurfaceElevated),
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
                          p.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : null,
                          ),
                        ),
                        Text(
                          p.trait,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (onPreview != null)
                    IconButton(
                      icon: Icon(Icons.volume_up_rounded, color: color, size: 20),
                      tooltip: 'Audition ${p.name}',
                      onPressed: () => onPreview!(p),
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
