import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/voice_personality.dart';

class VoicePreviewCard extends StatelessWidget {
  final VoicePersonality personality;
  final bool isDefault;
  final bool isPlaying;
  final VoidCallback onPreview;
  final VoidCallback onSetDefault;

  const VoicePreviewCard({
    super.key,
    required this.personality,
    required this.isDefault,
    required this.isPlaying,
    required this.onPreview,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = personality.signatureColor;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.roundedLg,
        side: BorderSide(
          color: isDefault
              ? color
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isDefault ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Title + Default Badge
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: AppRadius.roundedMd,
                  ),
                  child: Icon(
                    Icons.record_voice_over_rounded,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            personality.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        personality.trait,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description
            Text(personality.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),

            // Sample Spoken Quote Bubble
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.lightSurfaceElevated,
                borderRadius: AppRadius.roundedMd,
              ),
              child: Row(
                children: [
                  Icon(Icons.format_quote_rounded, size: 16, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      personality.previewQuote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPreview,
                    icon: Icon(
                      isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: color,
                      size: 20,
                    ),
                    label: Text(
                      isPlaying ? 'Stop Audio' : 'Preview Voice',
                      style: TextStyle(color: color),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                if (!isDefault) ...[
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text('Set as Default'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
