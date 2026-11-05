import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/calendar_repository.dart';

class CreateEditEventSheet extends ConsumerStatefulWidget {
  final CalendarEvent? eventToEdit;
  final DateTime? initialDate;

  const CreateEditEventSheet({super.key, this.eventToEdit, this.initialDate});

  @override
  ConsumerState<CreateEditEventSheet> createState() =>
      _CreateEditEventSheetState();
}

class _CreateEditEventSheetState extends ConsumerState<CreateEditEventSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  late DateTime _eventDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late int _categoryColor;
  late bool _isImportantDate;
  late bool _hasAlarm;
  bool _isSaving = false;

  final List<int> _colorPalette = const [
    0xFF6366F1, // Indigo
    0xFF06B6D4, // Cyan
    0xFF10B981, // Emerald
    0xFFF59E0B, // Amber
    0xFFEF4444, // Rose
    0xFF8B5CF6, // Purple
  ];

  @override
  void initState() {
    super.initState();
    final event = widget.eventToEdit;
    _titleController = TextEditingController(text: event?.title ?? '');
    _descController = TextEditingController(text: event?.description ?? '');
    _eventDate = event?.eventDate ?? widget.initialDate ?? DateTime.now();
    _categoryColor = event?.categoryColor ?? _colorPalette.first;
    _isImportantDate = event?.isImportantDate ?? false;
    _hasAlarm = event?.hasAlarm ?? false;

    if (event?.startTime != null) {
      try {
        final parts = event!.startTime!.split(':');
        _startTime = TimeOfDay(
          hour: int.parse(parts[0].trim()),
          minute: int.parse(parts[1].trim().split(' ')[0]),
        );
      } catch (_) {}
    }

    if (event?.endTime != null) {
      try {
        final parts = event!.endTime!.split(':');
        _endTime = TimeOfDay(
          hour: int.parse(parts[0].trim()),
          minute: int.parse(parts[1].trim().split(' ')[0]),
        );
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          _endTime ??
          TimeOfDay(
            hour: (_startTime?.hour ?? 9) + 1,
            minute: _startTime?.minute ?? 0,
          ),
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(calendarRepositoryProvider);
      final formattedStartTime = _startTime != null
          ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
          : null;
      final formattedEndTime = _endTime != null
          ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
          : null;

      if (widget.eventToEdit != null) {
        await repo.updateEvent(
          id: widget.eventToEdit!.id,
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          eventDate: _eventDate,
          startTime: formattedStartTime,
          endTime: formattedEndTime,
          categoryColor: _categoryColor,
          isImportantDate: _isImportantDate,
          hasAlarm: _hasAlarm,
        );
      } else {
        await repo.createEvent(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          eventDate: _eventDate,
          startTime: formattedStartTime,
          endTime: formattedEndTime,
          categoryColor: _categoryColor,
          isImportantDate: _isImportantDate,
          hasAlarm: _hasAlarm,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.eventToEdit != null
                  ? 'Event updated successfully'
                  : 'Event created successfully',
            ),
            backgroundColor: AppColors.successLight,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save event: $e'),
            backgroundColor: AppColors.dangerLight,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.eventToEdit != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Event' : 'New Calendar Event',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Title Input
                TextFormField(
                  controller: _titleController,
                  autofocus: !isEditing,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Event Title *',
                    hintText: 'e.g. Flutter Architecture Review',
                    prefixIcon: Icon(Icons.event_note_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Description Input
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Add agenda, room link, or notes',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Date Picker
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: Text(
                    'Date: ${DateFormat('EEE, MMM d, y').format(_eventDate)}',
                  ),
                  onPressed: _selectDate,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Time Pickers (Start and End)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.access_time_rounded, size: 18),
                        label: Text(
                          _startTime == null
                              ? 'Start Time'
                              : _startTime!.format(context),
                        ),
                        onPressed: _selectStartTime,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.timer_outlined, size: 18),
                        label: Text(
                          _endTime == null
                              ? 'End Time'
                              : _endTime!.format(context),
                        ),
                        onPressed: _selectEndTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Category Color Palette
                Row(
                  children: [
                    Text(
                      'Color Tag:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        children: _colorPalette.map((colorVal) {
                          final isSelected = _categoryColor == colorVal;
                          return InkWell(
                            onTap: () =>
                                setState(() => _categoryColor = colorVal),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Color(colorVal),
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Important Date switch
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Important Date'),
                  subtitle: const Text('Marks this event with a priority star'),
                  value: _isImportantDate,
                  onChanged: (val) => setState(() => _isImportantDate = val),
                ),

                // CRUCIAL: hasAlarm Distinction Switch Container
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _hasAlarm
                        ? AppColors.primaryIndigo.withValues(alpha: 0.12)
                        : (isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.lightSurfaceElevated),
                    borderRadius: AppRadius.roundedMd,
                    border: Border.all(
                      color: _hasAlarm
                          ? AppColors.indigoLight
                          : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                    ),
                  ),
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(
                      _hasAlarm
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_outlined,
                      color: _hasAlarm
                          ? AppColors.indigoLight
                          : (isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary),
                    ),
                    title: Text(
                      'Spoken Alarm Reminder (USP)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _hasAlarm ? AppColors.indigoLight : null,
                      ),
                    ),
                    subtitle: Text(
                      _hasAlarm
                          ? 'TASKLY will trigger an exact alarm and speak this event aloud.'
                          : 'Silent calendar event only. No alarm will ring.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    value: _hasAlarm,
                    onChanged: (val) => setState(() => _hasAlarm = val),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Save button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigoLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditing ? 'Save Changes' : 'Create Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
