import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/alarms/presentation/alarm_screen.dart';
import 'package:taskly/features/alarms/presentation/widgets/waveform_visualizer.dart';

void main() {
  testWidgets('AlarmScreen renders waveform, title, spoken prompt, and action buttons',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AlarmScreen(
            reminderId: 'test-reminder-id',
            title: 'Study Flutter Architecture',
            scheduledTimeText: '10:00 AM',
            voicePersonality: 'nova',
            spokenMessage: "Hey! It's time to study Flutter Architecture. Let's get started!",
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Title and Voice
    expect(find.text('Study Flutter Architecture'), findsOneWidget);
    expect(find.text('VOICE: NOVA'), findsOneWidget);
    expect(find.text('Scheduled for 10:00 AM'), findsOneWidget);

    // Verify Waveform visualizer
    expect(find.byType(WaveformVisualizer), findsOneWidget);

    // Verify Spoken Message
    expect(
      find.text("Hey! It's time to study Flutter Architecture. Let's get started!"),
      findsOneWidget,
    );

    // Verify Actions: Stop, Snooze, Complete, Reschedule
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Snooze 10m'), findsOneWidget);
    expect(find.text('Mark as Completed'), findsOneWidget);
    expect(find.text('Reschedule for another time'), findsOneWidget);

    // Tap Stop button
    await tester.tap(find.text('Stop'));
    await tester.pump(const Duration(milliseconds: 100));
  });
}
