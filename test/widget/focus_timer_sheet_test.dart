import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/core/database/database_provider.dart';
import 'package:taskly/features/productivity/presentation/focus_timer_sheet.dart';
import 'package:taskly/features/tasks/data/tasks_repository.dart';

void main() {
  testWidgets(
    'FocusTimerSheet renders duration chips, timer, and task linker',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = AppDatabase(NativeDatabase.memory());
      final tasksRepo = TasksRepository(db);

      // Seed a task
      await tasksRepo.createTask(
        id: 'task-101',
        title: 'Complete Flutter Master Prompt',
        category: 'work',
        priority: 'high',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: Scaffold(body: FocusTimerSheet())),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Focus Session Header & Duration chips
      expect(find.text('Focus Session'), findsOneWidget);
      expect(find.text('15 min'), findsOneWidget);
      expect(find.text('25 min'), findsOneWidget);
      expect(find.text('45 min'), findsOneWidget);

      // Verify Countdown Timer
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('READY'), findsOneWidget);

      // Verify Task Linking Dropdown or Selector
      expect(find.text('Link to Task (Optional)'), findsOneWidget);

      // Verify Start Focus button
      expect(find.text('Start Focus'), findsOneWidget);

      // Tap Start Focus
      await tester.tap(find.text('Start Focus'));
      await tester.pump();
      expect(find.text('Pause'), findsOneWidget);
      expect(find.text('STAY FOCUSED'), findsOneWidget);

      await db.close();
    },
  );

  testWidgets(
    'Finish Early logs focus session and shows completion prompt when task linked',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final db = AppDatabase(NativeDatabase.memory());
      final tasksRepo = TasksRepository(db);

      await tasksRepo.createTask(
        id: 'task-link-test',
        title: 'Study Flutter State Management',
        category: 'study',
        priority: 'high',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: Scaffold(body: FocusTimerSheet())),
        ),
      );

      await tester.pumpAndSettle();

      // Select the task from dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Study Flutter State Management').last);
      await tester.pumpAndSettle();

      // Tap Finish Early button
      final finishEarlyButton = find.byTooltip('Finish Early');
      expect(finishEarlyButton, findsOneWidget);
      await tester.tap(finishEarlyButton);
      await tester.pumpAndSettle();

      // Verify session completed prompt appears with "Complete" action
      expect(
        find.text('🎉 Session saved! Mark linked task as completed?'),
        findsOneWidget,
      );
      expect(find.text('Complete'), findsOneWidget);

      // Tap Complete
      await tester.tap(find.text('Complete'));
      await tester.pumpAndSettle();

      // Verify task is now marked completed in DB
      final tasks = await db.select(db.tasks).get();
      expect(tasks.first.isCompleted, isTrue);

      await db.close();
    },
  );
}
