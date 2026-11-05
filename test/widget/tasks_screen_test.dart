import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/tasks/data/tasks_repository.dart';
import 'package:taskly/features/tasks/presentation/tasks_screen.dart';
import 'package:taskly/features/tasks/presentation/widgets/task_item_tile.dart';

void main() {
  testWidgets(
    'TasksScreen displays header, filter chips and empty state initially',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredTasksStreamProvider.overrideWith((ref) => Stream.value([])),
            taskStatsStreamProvider.overrideWith(
              (ref) => Stream.value(TaskStats.empty()),
            ),
          ],
          child: const MaterialApp(home: TasksScreen()),
        ),
      );

      await tester.pump();

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('No tasks found'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    },
  );

  testWidgets('TasksScreen displays TaskItemTile when tasks are provided', (
    tester,
  ) async {
    final sampleTask = Task(
      id: 'task-test-1',
      title: 'Finish Unit Tests',
      description: 'Ensure 100% reliability',
      category: 'work',
      priority: 'high',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      dueTime: '15:30',
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          filteredTasksStreamProvider.overrideWith(
            (ref) => Stream.value([sampleTask]),
          ),
          taskStatsStreamProvider.overrideWith(
            (ref) => Stream.value(
              const TaskStats(
                totalCount: 1,
                completedCount: 0,
                pendingCount: 1,
                completionRate: 0.0,
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: TasksScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Finish Unit Tests'), findsOneWidget);
    expect(find.text('Ensure 100% reliability'), findsOneWidget);
    expect(find.text('WORK'), findsOneWidget);
    expect(find.text('HIGH'), findsOneWidget);
    expect(find.byType(TaskItemTile), findsOneWidget);
  });
}
