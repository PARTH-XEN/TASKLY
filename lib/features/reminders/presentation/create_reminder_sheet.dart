import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../services/alarm_service.dart';
import '../data/reminders_repository.dart';
import 'widgets/relative_duration_chips.dart';
import 'widgets/voice_personality_selector.dart';

/// Modal bottom sheet for creating smart spoken reminders.
class CreateReminderSheet extends ConsumerStatefulWidget {
  const CreateReminderSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateReminderSheet(),
    );
  }

  @override
  ConsumerState<CreateReminderSheet> createState() => _CreateReminderSheetState();
}

class _CreateReminderSheetState extends ConsumerState<CreateReminderSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customMessageController = TextEditingController();

  int? _relativeMinutes = 120; // Default: +2h
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 2));
  String _selectedPersonality = 'nova';
  final double _speechRate = 0.5;
  final double _speechPitch = 1.0;
  final String _repeatFrequency = 'none';
  bool _isSpokenEnabled = true;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
    _customMessageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _customMessageController.dispose();
    super.dispose();
  }

  void _onRelativeMinutesSelected(int? minutes) {
    setState(() {
      _relativeMinutes = minutes;
      if (minutes != null) {
        _scheduledAt = DateTime.now().add(Duration(minutes: minutes));
      } else {
        _pickCustomDateTime();
      }
    });
  }

  Future<void> _pickCustomDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_scheduledAt),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _scheduledAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  String get _spokenPreview {
    final title = _titleController.text.trim().isEmpty ? 'your task' : _titleController.text.trim();
    return AlarmService.generateSpokenMessage(
      title: title,
      customMessage: _customMessageController.text,
    );
  }

  Future<void> _saveReminder() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reminder title')),
      );
      return;
    }

    final id = const Uuid().v4();
    final repo = ref.read(remindersRepositoryProvider);

    await repo.createReminder(
      id: id,
      title: title,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      scheduledAt: _scheduledAt,
      relativeDurationMinutes: _relativeMinutes,
      voicePersonality: _selectedPersonality,
      speechRate: _speechRate,
      speechPitch: _speechPitch,
      repeatFrequency: _repeatFrequency,
      customSpokenMessage: _customMessageController.text.trim().isEmpty
          ? null
          : _customMessageController.text.trim(),
      isSpokenEnabled: _isSpokenEnabled,
    );

    if (mounted) {
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Spoken reminder scheduled for ${DateFormat('h:mm a').format(_scheduledAt)}'),
          backgroundColor: AppColors.successDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.88,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Drag handle & Header
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md, left: AppSpacing.lg, right: AppSpacing.lg),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.lightBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Spoken Reminder',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            // Scrollable Form
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // Title Field
                  TextField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Title',
                      hintText: 'e.g. Study Flutter Architecture',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Description Field (Optional)
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Add details, chapter names, or context',
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Relative Timing Chips
                  Text(
                    'WHEN TO REMIND',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.indigoLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RelativeDurationChips(
                    selectedMinutes: _relativeMinutes,
                    onSelected: _onRelativeMinutesSelected,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  InkWell(
                    onTap: _pickCustomDateTime,
                    borderRadius: AppRadius.roundedMd,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.indigoLight),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Scheduled: ${DateFormat('EEE, MMM d • h:mm a').format(_scheduledAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Change', style: TextStyle(color: AppColors.indigoLight, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Voice Personality Selector (USP)
                  Text(
                    'VOICE PERSONALITY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.indigoLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  VoicePersonalitySelector(
                    selectedPersonality: _selectedPersonality,
                    onSelected: (p) => setState(() => _selectedPersonality = p),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Spoken Message Preview Bubble (USP)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                      borderRadius: AppRadius.roundedMd,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.volume_up_rounded, size: 18, color: AppColors.indigoLight),
                            const SizedBox(width: 6),
                            Text(
                              'SPOKEN TASK PREVIEW',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: AppColors.indigoLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _spokenPreview,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Custom Message Override Field
                  TextField(
                    controller: _customMessageController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Spoken Message (Optional)',
                      hintText: 'Leave empty for automated friendly prompt',
                      prefixIcon: Icon(Icons.record_voice_over_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Spoken reminder toggle
                  SwitchListTile(
                    title: const Text('Spoken Reminder'),
                    subtitle: const Text('Speak task aloud when alarm fires'),
                    value: _isSpokenEnabled,
                    onChanged: (val) => setState(() => _isSpokenEnabled = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: _saveReminder,
                icon: const Icon(Icons.alarm_add_rounded),
                label: const Text('Schedule Spoken Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
