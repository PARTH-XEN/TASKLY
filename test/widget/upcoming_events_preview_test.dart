import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/calendar/data/calendar_repository.dart';
import 'package:taskly/features/dashboard/presentation/widgets/upcoming_events_preview.dart';

void main() {
  testWidgets('UpcomingEventsPreview shows empty card when no events scheduled today',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsForSelectedDateStreamProvider.overrideWith(
            (ref) => Stream.value([]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: UpcomingEventsPreview(),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text("Today's Schedule"), findsOneWidget);
    expect(find.text('No events scheduled for today'), findsOneWidget);
  });

  testWidgets('UpcomingEventsPreview shows event list with alarm indicator',
      (tester) async {
    final now = DateTime.now();
    final sampleEvent = CalendarEvent(
      id: 'dash-evt-1',
      title: 'Sprint Planning Meeting',
      description: 'Discuss Q4 roadmap',
      eventDate: now,
      startTime: '10:00',
      endTime: '11:00',
      categoryColor: 0xFF6366F1,
      isImportantDate: true,
      hasAlarm: true,
      createdAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsForSelectedDateStreamProvider.overrideWith(
            (ref) => Stream.value([sampleEvent]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: UpcomingEventsPreview(),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Sprint Planning Meeting'), findsOneWidget);
    expect(find.text('10:00 - 11:00'), findsOneWidget);
    expect(find.text('Alarm'), findsOneWidget);
  });
}
