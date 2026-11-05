import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/alarm_history_repository.dart';

final alarmHistoryStreamProvider = StreamProvider((ref) {
  return ref.watch(alarmHistoryRepositoryProvider).watchHistory();
});

class AlarmHistoryScreen extends ConsumerWidget {
  const AlarmHistoryScreen({super.key});

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'completed':
        return AppColors.successLight;
      case 'snoozed':
        return AppColors.warningLight;
      case 'stopped':
      case 'missed':
        return AppColors.dangerLight;
      case 'rescheduled':
      default:
        return AppColors.cyanLight;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final historyAsync = ref.watch(alarmHistoryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Clear history',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History'),
                  content: const Text(
                    'Are you sure you want to delete all alarm logs?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(alarmHistoryRepositoryProvider).clearHistory();
              }
            },
          ),
        ],
      ),
      body: historyAsync.when(
        data: (historyList) {
          if (historyList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceElevated
                            : AppColors.lightSurfaceElevated,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        size: 36,
                        color: AppColors.darkTextTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'No Alarm History Yet',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'When your smart reminders trigger, actions like Stop, Snooze, and Complete will be logged here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];
              final actionColor = _getActionColor(item.actionTaken);
              final timeFormatted = DateFormat('EEE, MMM d • h:mm a')
                  .format(item.triggeredAt);

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: actionColor.withValues(alpha: 0.15),
                          borderRadius: AppRadius.roundedMd,
                        ),
                        child: Icon(
                          item.actionTaken == 'completed'
                              ? Icons.check_circle_rounded
                              : item.actionTaken == 'snoozed'
                              ? Icons.snooze_rounded
                              : Icons.stop_circle_rounded,
                          color: actionColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              timeFormatted,
                              style: theme.textTheme.bodySmall,
                            ),
                            if (item.spokenMessage != null &&
                                item.spokenMessage!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                '"${item.spokenMessage}"',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: actionColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: actionColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          item.actionTaken.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: actionColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading history: $err')),
      ),
    );
  }
}
