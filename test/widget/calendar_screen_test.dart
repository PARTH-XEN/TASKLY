import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/calendar/data/calendar_repository.dart';
import 'package:taskly/features/calendar/presentation/calendar_screen.dart';
import 'package:taskly/features/calendar/presentation/widgets/event_item_tile.dart';

void main() {
  testWidgets('CalendarScreen displays TableCalendar and empty state initially',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsForSelectedDateStreamProvider.overrideWith(
            (ref) => Stream.value([]),
          ),
          allCalendarEventsStreamProvider.overrideWith(
            (ref) => Stream.value([]),
          ),
        ],
        child: const MaterialApp(
          home: CalendarScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Calendar'), findsOneWidget);
    expect(find.byType(TableCalendar<CalendarEvent>), findsOneWidget);
    expect(find.text('No events scheduled'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('CalendarScreen renders EventItemTile with prominent alarm distinction',
      (tester) async {
    final now = DateTime.now();
    final alarmEvent = CalendarEvent(
      id: 'alarm-evt-1',
      title: 'Doctor Appointment',
      description: 'Annual health checkup',
      eventDate: now,
      startTime: '10:00',
      endTime: '11:00',
      categoryColor: 0xFF6366F1,
      isImportantDate: true,
      hasAlarm: true, // Spoken alarm enabled
      createdAt: now,
    );

    final silentEvent = CalendarEvent(
      id: 'silent-evt-2',
      title: 'Tax Filing Deadline',
      description: 'Silent calendar date',
      eventDate: now,
      categoryColor: 0xFF06B6D4,
      isImportantDate: false,
      hasAlarm: false, // Silent event
      createdAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsForSelectedDateStreamProvider.overrideWith(
            (ref) => Stream.value([alarmEvent, silentEvent]),
          ),
          allCalendarEventsStreamProvider.overrideWith(
            (ref) => Stream.value([alarmEvent, silentEvent]),
          ),
        ],
        child: const MaterialApp(
          home: CalendarScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Doctor Appointment'), findsOneWidget);
    expect(find.text('Tax Filing Deadline'), findsOneWidget);

    // Verify alarm distinction badges
    expect(find.text('Spoken Alarm'), findsOneWidget);
    expect(find.text('Silent Marker'), findsOneWidget);
    expect(find.byType(EventItemTile), findsNWidgets(2));
  });
}
