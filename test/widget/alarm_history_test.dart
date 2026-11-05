import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/alarms/presentation/alarm_history_screen.dart';

void main() {
  testWidgets('AlarmHistoryScreen renders empty state when no alarms logged',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          alarmHistoryStreamProvider.overrideWith((ref) => Stream<List<AlarmHistoryData>>.value([])),
        ],
        child: const MaterialApp(
          home: AlarmHistoryScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Title
    expect(find.text('Alarm History'), findsOneWidget);

    // Verify Empty state
    expect(find.text('No Alarm History Yet'), findsOneWidget);
    expect(
      find.text(
        'When your smart reminders trigger, actions like Stop, Snooze, and Complete will be logged here.',
      ),
      findsOneWidget,
    );

    // Verify delete button
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
  });
}
