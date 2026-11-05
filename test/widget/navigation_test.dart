import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/router/app_router.dart';
import 'package:taskly/core/theme/app_theme.dart';

void main() {
  testWidgets('Navigation shell displays 5 destinations and FAB', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme.darkTheme,
      ),
    );
    await tester.pumpAndSettle();

    // Verify 5 tab labels exist in the NavigationBar
    final navBarFinder = find.byType(NavigationBar);
    expect(find.descendant(of: navBarFinder, matching: find.text('Home')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Tasks')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Calendar')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Wishlist')), findsOneWidget);
    expect(find.descendant(of: navBarFinder, matching: find.text('Profile')), findsOneWidget);

    // Verify Floating Action Button exists
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Tap on Tasks tab and verify Tasks screen is shown
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('Tasks')));
    await tester.pumpAndSettle();
    expect(find.text('Task Management'), findsOneWidget);

    // Tap on Calendar tab
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('Calendar')));
    await tester.pumpAndSettle();
    expect(find.text('Calendar & Events'), findsOneWidget);

    // Tap on Wishlist tab
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('Wishlist')));
    await tester.pumpAndSettle();
    expect(find.text('Personal Wishlist'), findsOneWidget);

    // Tap on Profile tab
    await tester.tap(find.descendant(of: navBarFinder, matching: find.text('Profile')));
    await tester.pumpAndSettle();
    expect(find.text('TTS Voice Engines'), findsOneWidget);

    // Tap the FAB to open quick actions
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Create New'), findsOneWidget);
    expect(find.text('Spoken Reminder'), findsOneWidget);
  });
}
