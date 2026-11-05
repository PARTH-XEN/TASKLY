import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class NextReminderCard extends StatelessWidget {
  final String title;
  final String scheduledTimeText;
  final String voicePersonality;
  final String spokenMessage;

  const NextReminderCard({
    super.key,
    this.title = 'Study Flutter Architecture',
    this.scheduledTimeText = 'In 2 hours • 1:00 PM',
    this.voicePersonality = 'Nova',
    this.spokenMessage = "Hey! It's time to study Flutter. You scheduled this two hours ago. Let's get started!",
  });

  Color _getVoiceColor(String voice) {
    switch (voice.toLowerCase()) {
      case 'max':
        return AppColors.voiceMax;
      case 'atlas':
        return AppColors.voiceAtlas;
      case 'echo':
        return AppColors.voiceEcho;
      case 'nova':
      default:
        return AppColors.voiceNova;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final voiceColor = _getVoiceColor(voicePersonality);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E2235), const Color(0xFF151824)]
              : [const Color(0xFFFFFFFF), const Color(0xFFF1F5F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.roundedXl,
        border: Border.all(
          color: isDark ? AppColors.indigoLight.withValues(alpha: 0.3) : AppColors.indigoDark.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: voiceColor.withValues(alpha: isDark ? 0.12 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: USP Badge + Voice Chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.indigoLight.withValues(alpha: 0.2),
                  borderRadius: AppRadius.roundedSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.indigoLight),
                    const SizedBox(width: 4),
                    Text(
                      'NEXT SPOKEN REMINDER',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.indigoLight,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: voiceColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.roundedFull,
                  border: Border.all(color: voiceColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mic_rounded, size: 13, color: voiceColor),
                    const SizedBox(width: 4),
                    Text(
                      voicePersonality,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: voiceColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Title & Scheduled time
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 15, color: AppColors.indigoLight),
              const SizedBox(width: 6),
              Text(
                scheduledTimeText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Spoken Message preview bubble (USP)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
              borderRadius: AppRadius.roundedMd,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  size: 20,
                  color: AppColors.indigoLight,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    spokenMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
