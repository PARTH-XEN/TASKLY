import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../tasks/data/tasks_repository.dart';
import '../data/focus_repository.dart';

class FocusTimerSheet extends ConsumerStatefulWidget {
  const FocusTimerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FocusTimerSheet(),
    );
  }

  @override
  ConsumerState<FocusTimerSheet> createState() => _FocusTimerSheetState();
}

class _FocusTimerSheetState extends ConsumerState<FocusTimerSheet> {
  int _selectedDurationMinutes = 25;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  String? _selectedTaskId;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _selectedDurationMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
        _onSessionComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer([int? newMinutes]) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (newMinutes != null) _selectedDurationMinutes = newMinutes;
      _remainingSeconds = _selectedDurationMinutes * 60;
    });
  }

  Future<void> _onSessionComplete([
    ScaffoldMessengerState? externalMessenger,
  ]) async {
    final messenger =
        externalMessenger ?? (mounted ? ScaffoldMessenger.of(context) : null);
    final repo = ref.read(focusRepositoryProvider);
    final linkedTaskId = _selectedTaskId;
    await repo.logFocusSession(
      id: const Uuid().v4(),
      durationMinutes: _selectedDurationMinutes,
      taskId: linkedTaskId,
      notes: linkedTaskId != null
          ? 'Completed focus session for linked task'
          : 'Completed $_selectedDurationMinutes min focus session',
    );

    if (messenger != null) {
      if (linkedTaskId != null) {
        messenger.showSnackBar(
          SnackBar(
            content: const Text(
              '🎉 Session saved! Mark linked task as completed?',
            ),
            backgroundColor: AppColors.successLight,
            action: SnackBarAction(
              label: 'Complete',
              textColor: Colors.white,
              onPressed: () {
                ref
                    .read(tasksRepositoryProvider)
                    .toggleTaskCompleted(linkedTaskId, true);
              },
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '🎉 Great job! You completed a $_selectedDurationMinutes-minute focus session.',
            ),
            backgroundColor: AppColors.successLight,
          ),
        );
      }
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalSeconds = _selectedDurationMinutes * 60;
    final progress = totalSeconds > 0
        ? (1.0 - (_remainingSeconds / totalSeconds))
        : 0.0;
    final todayMinutesAsync = ref.watch(todayFocusMinutesStreamProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Focus Session',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      todayMinutesAsync.when(
                        data: (mins) => Text(
                          'Today: $mins mins focused',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.indigoLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (err, stack) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Preset Duration Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [15, 25, 45].map((mins) {
                  final isSelected = _selectedDurationMinutes == mins;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: ChoiceChip(
                      label: Text('$mins min'),
                      selected: isSelected,
                      selectedColor: AppColors.indigoLight,
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightSurfaceElevated,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected && !_isRunning) {
                          _resetTimer(mins);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),

              // Optional Link to Task
              Consumer(
                builder: (context, ref, child) {
                  final activeTasksAsync = ref.watch(activeTasksStreamProvider);
                  final tasks = activeTasksAsync.value ?? [];
                  final effectiveValue =
                      (_selectedTaskId != null &&
                          tasks.any((t) => t.id == _selectedTaskId))
                      ? _selectedTaskId
                      : null;

                  return DropdownButtonFormField<String?>(
                    key: ValueKey(effectiveValue),
                    initialValue: effectiveValue,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Link to Task (Optional)',
                      prefixIcon: const Icon(Icons.link_rounded, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('None (General Focus)'),
                      ),
                      ...tasks.map(
                        (t) => DropdownMenuItem<String?>(
                          value: t.id,
                          child: Text(
                            t.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                    onChanged: _isRunning
                        ? null
                        : (val) {
                            setState(() => _selectedTaskId = val);
                          },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Circular Countdown Timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightSurfaceElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.indigoLight,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _isRunning ? 'STAY FOCUSED' : 'READY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.2,
                          color: _isRunning
                              ? AppColors.indigoLight
                              : (isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset Button
                  IconButton.filledTonal(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Reset',
                    onPressed: () => _resetTimer(),
                  ),
                  const SizedBox(width: AppSpacing.lg),

                  // Play / Pause Button
                  ElevatedButton.icon(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    icon: Icon(
                      _isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(_isRunning ? 'Pause' : 'Start Focus'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.indigoLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),

                  // Complete early button
                  IconButton.filledTonal(
                    icon: const Icon(Icons.check_rounded),
                    tooltip: 'Finish Early',
                    onPressed: () async {
                      _timer?.cancel();
                      final messenger = ScaffoldMessenger.of(context);
                      final nav = Navigator.of(context);
                      await _onSessionComplete(messenger);
                      if (nav.canPop()) {
                        nav.pop();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
