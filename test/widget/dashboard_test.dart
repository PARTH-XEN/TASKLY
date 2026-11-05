import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/theme/app_theme.dart';
import 'package:taskly/features/dashboard/presentation/dashboard_screen.dart';
import 'package:taskly/features/dashboard/presentation/widgets/next_reminder_card.dart';
import 'package:taskly/features/dashboard/presentation/widgets/today_summary_card.dart';
import 'package:taskly/features/reminders/data/reminders_repository.dart';

void main() {
  testWidgets('Dashboard renders greeting, next reminder USP, and summary', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          upcomingRemindersStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Offline Ready badge in greeting
    expect(find.text('Offline Ready'), findsOneWidget);

    // Verify Next Reminder Card components (USP)
    final reminderCardFinder = find.byType(NextReminderCard);
    expect(reminderCardFinder, findsOneWidget);
    expect(find.text('NEXT SPOKEN REMINDER'), findsOneWidget);
    expect(find.descendant(of: reminderCardFinder, matching: find.text('Nova')), findsOneWidget);
    expect(find.text('Study Flutter Architecture'), findsWidgets);

    // Verify Today Summary Card
    expect(find.byType(TodaySummaryCard), findsOneWidget);
    expect(find.text("Today's Overview"), findsOneWidget);
    expect(find.text('Pending Tasks'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);

    // Verify Quick Action Grid items
    expect(find.text('Reminder'), findsOneWidget);
    expect(find.text('Task'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);

    // Verify Upcoming Reminders section
    expect(find.text('Upcoming Reminders'), findsOneWidget);
  });
}
