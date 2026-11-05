import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/reminders/presentation/create_reminder_sheet.dart';

void main() {
  testWidgets(
    'CreateReminderSheet renders form, relative chips, and voice options',
    (WidgetTester tester) async {
      // Set realistic mobile phone viewport
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: CreateReminderSheet())),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title and form inputs
      expect(find.text('New Spoken Reminder'), findsOneWidget);
      expect(find.text('Reminder Title'), findsOneWidget);

      // Verify relative timing chips
      expect(find.text('+15m'), findsOneWidget);
      expect(find.text('+30m'), findsOneWidget);
      expect(find.text('+1h'), findsOneWidget);
      expect(find.text('+2h'), findsOneWidget);
      expect(find.text('+3h'), findsOneWidget);

      // Verify Voice Personalities
      expect(find.text('Nova'), findsOneWidget);
      expect(find.text('Max'), findsOneWidget);
      expect(find.text('Atlas'), findsOneWidget);
      expect(find.text('Echo'), findsOneWidget);

      // Verify Spoken task preview bubble
      expect(find.text('SPOKEN TASK PREVIEW'), findsOneWidget);

      // Type a title and verify dynamic update in the preview
      await tester.enterText(
        find.byType(TextField).first,
        'Study Flutter Architecture',
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          "Hey! It's time to Study Flutter Architecture. Let's get started!",
        ),
        findsOneWidget,
      );

      // Verify Save Button
      expect(find.text('Schedule Spoken Reminder'), findsOneWidget);
    },
  );
}
