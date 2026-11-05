// lib/features/dashboard/presentation/widgets/update_banner.dart
//
// Shows a gradient banner at the top of the dashboard when a newer TASKLY
// version is available on GitHub Releases.  Dismissed per-session only
// (reappears on next app launch until the user updates).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../services/update_service.dart';

class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hide if the user dismissed for this session.
    final dismissed = ref.watch(updateBannerDismissedProvider);
    if (dismissed) return const SizedBox.shrink();

    final updateAsync = ref.watch(updateInfoProvider);

    return updateAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (info) {
        if (info == null) return const SizedBox.shrink();
        return _UpdateBannerContent(info: info);
      },
    );
  }
}

class _UpdateBannerContent extends ConsumerWidget {
  final UpdateInfo info;
  const _UpdateBannerContent({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryIndigo, AppColors.primaryCyan],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: AppRadius.roundedMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryIndigo.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.md),
            const Icon(
              Icons.system_update_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '✨ Update available — v${info.version}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (info.releaseNotes.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        info.releaseNotes,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Update Now button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedSm,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {
                final service = UpdateService();
                final launched = await service.launchDownload(info.downloadUrl);
                if (!launched && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not open download link. Please visit GitHub manually.',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Update Now',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Dismiss button
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
              onPressed: () {
                ref.read(updateBannerDismissedProvider.notifier).state = true;
              },
              tooltip: 'Dismiss',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(AppSpacing.sm),
            ),
          ],
        ),
      ),
    );
  }
}
