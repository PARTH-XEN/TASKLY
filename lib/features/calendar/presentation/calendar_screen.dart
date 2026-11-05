import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/calendar_repository.dart';
import 'widgets/create_edit_event_sheet.dart';
import 'widgets/event_item_tile.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  void _showCreateEditSheet([CalendarEvent? event]) {
    final selectedDate = ref.read(selectedCalendarDateProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEditEventSheet(
        eventToEdit: event,
        initialDate: selectedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedDay = ref.watch(selectedCalendarDateProvider);
    final eventsForDayAsync = ref.watch(eventsForSelectedDateStreamProvider);
    final allEventsAsync = ref.watch(allCalendarEventsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            tooltip: 'Go to Today',
            onPressed: () {
              final today = DateTime.now();
              ref.read(selectedCalendarDateProvider.notifier).state = today;
              setState(() => _focusedDay = today);
            },
          ),
          IconButton(
            icon: Icon(
              _calendarFormat == CalendarFormat.month
                  ? Icons.view_week_rounded
                  : Icons.calendar_view_month_rounded,
            ),
            tooltip: _calendarFormat == CalendarFormat.month
                ? 'Week View'
                : 'Month View',
            onPressed: () {
              setState(() {
                _calendarFormat = _calendarFormat == CalendarFormat.month
                    ? CalendarFormat.week
                    : CalendarFormat.month;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Event',
            onPressed: () => _showCreateEditSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          // TableCalendar view
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            elevation: 0,
            color: isDark ? AppColors.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: TableCalendar<CalendarEvent>(
              firstDay: DateTime.now().subtract(const Duration(days: 365 * 2)),
              lastDay: DateTime.now().add(const Duration(days: 365 * 5)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              onDaySelected: (newSelectedDay, newFocusedDay) {
                ref.read(selectedCalendarDateProvider.notifier).state =
                    newSelectedDay;
                setState(() => _focusedDay = newFocusedDay);
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                final allEvents = allEventsAsync.value ?? [];
                return allEvents.where((e) {
                  return e.eventDate.year == day.year &&
                      e.eventDate.month == day.month &&
                      e.eventDate.day == day.day;
                }).toList();
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: AppColors.indigoLight.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: AppColors.indigoLight,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.indigoLight,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.primaryIndigo,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Selected Day Agenda Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  DateFormat('EEEE, MMMM d').format(selectedDay),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                eventsForDayAsync.when(
                  data: (events) => Text(
                    '${events.length} event${events.length == 1 ? '' : 's'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (err, stack) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Events Agenda List
          Expanded(
            child: eventsForDayAsync.when(
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.cyanLight.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.event_available_rounded,
                                size: 24,
                                color: AppColors.cyanLight,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'No events scheduled',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap the button below to add an event or milestone.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Add Event'),
                              onPressed: () => _showCreateEditSheet(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xs,
                    bottom: AppSpacing.xxl * 2,
                  ),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventItemTile(
                      event: event,
                      onTap: () => _showCreateEditSheet(event),
                      onDelete: () {
                        ref
                            .read(calendarRepositoryProvider)
                            .deleteEvent(event.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Deleted "${event.title}"'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text('Error loading events: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendar_screen_fab',
        onPressed: () => _showCreateEditSheet(),
        backgroundColor: AppColors.indigoLight,
        foregroundColor: Colors.white,
        tooltip: 'Add Event',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
