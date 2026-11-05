import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/app.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/reminders/data/reminders_repository.dart';

void main() {
  testWidgets('TasklyApp initializes and displays Home dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          upcomingRemindersStreamProvider.overrideWith((ref) => Stream<List<Reminder>>.value([])),
        ],
        child: const TasklyApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify root dashboard loads
    expect(find.text('Offline Ready'), findsOneWidget);
    expect(find.text('NEXT SPOKEN REMINDER'), findsOneWidget);

    final navBarFinder = find.byType(NavigationBar);
    expect(find.descendant(of: navBarFinder, matching: find.text('Home')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Tasks')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Calendar')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Wishlist')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Profile')), findsOneWidget);
  });
}
