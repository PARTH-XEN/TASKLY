import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../calendar/data/calendar_repository.dart';

class UpcomingEventsPreview extends ConsumerWidget {
  const UpcomingEventsPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final eventsAsync = ref.watch(eventsForSelectedDateStreamProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Schedule",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/calendar'),
                child: const Text('View Calendar'),
              ),
            ],
          ),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.cyanLight.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: AppColors.cyanLight,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No events scheduled for today',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Tap to add exams, meetings, or milestones',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_rounded),
                          tooltip: 'Add Event',
                          onPressed: () => context.go('/calendar'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: events.take(3).map((event) {
                  final catColor = Color(event.categoryColor);
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Material(
                      color: isDark
                          ? AppColors.darkSurfaceElevated
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundedMd,
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: ListTile(
                      dense: true,
                      leading: Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          color: catColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      title: Text(
                        event.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: event.startTime != null
                          ? Text(
                              event.endTime != null
                                  ? '${event.startTime} - ${event.endTime}'
                                  : event.startTime!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            )
                          : null,
                      trailing: event.hasAlarm
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryIndigo.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.notifications_active_rounded,
                                    size: 11,
                                    color: AppColors.indigoLight,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Alarm',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.indigoLight,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Icon(
                              Icons.event_note_rounded,
                              size: 16,
                              color: AppColors.darkTextTertiary,
                            ),
                      onTap: () => context.go('/calendar'),
                    ),
                  ),
                );
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
