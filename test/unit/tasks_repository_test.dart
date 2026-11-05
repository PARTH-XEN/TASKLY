import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/core/database/app_database.dart';
import 'package:taskly/features/tasks/data/tasks_repository.dart';

void main() {
  late AppDatabase db;
  late TasksRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TasksRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TasksRepository Unit Tests', () {
    test('createTask inserts task into Drift and watchTasks retrieves it', () async {
      await repository.createTask(
        id: 'task-1',
        title: 'Study Flutter Architecture',
        description: 'Understand Riverpod and Drift',
        category: 'study',
        priority: 'high',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      final tasks = await repository.watchTasks().first;
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Study Flutter Architecture');
      expect(tasks.first.priority, 'high');
      expect(tasks.first.category, 'study');
      expect(tasks.first.isCompleted, isFalse);
    });

    test('toggleTaskCompleted updates isCompleted status accurately', () async {
      await repository.createTask(
        id: 'task-2',
        title: 'Submit report',
        category: 'work',
        priority: 'medium',
      );

      await repository.toggleTaskCompleted('task-2', true);
      final tasks = await repository.watchTasks().first;
      expect(tasks.first.isCompleted, isTrue);

      await repository.toggleTaskCompleted('task-2', false);
      final tasksAfter = await repository.watchTasks().first;
      expect(tasksAfter.first.isCompleted, isFalse);
    });

    test('TaskFilter filters correctly for Today, Upcoming, and Overdue', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 14, 0);
      final tomorrow = now.add(const Duration(days: 2));
      final yesterday = now.subtract(const Duration(days: 2));

      await repository.createTask(
        id: 't-today',
        title: 'Today Task',
        dueDate: today,
      );
      await repository.createTask(
        id: 't-upcoming',
        title: 'Upcoming Task',
        dueDate: tomorrow,
      );
      await repository.createTask(
        id: 't-overdue',
        title: 'Overdue Task',
        dueDate: yesterday,
      );

      final todayTasks = await repository.watchTasks(filter: TaskFilter.today).first;
      expect(todayTasks.map((t) => t.id).toList(), contains('t-today'));
      expect(todayTasks.map((t) => t.id).toList(), isNot(contains('t-upcoming')));
      expect(todayTasks.map((t) => t.id).toList(), isNot(contains('t-overdue')));

      final upcomingTasks =
          await repository.watchTasks(filter: TaskFilter.upcoming).first;
      expect(upcomingTasks.map((t) => t.id).toList(), contains('t-upcoming'));

      final overdueTasks =
          await repository.watchTasks(filter: TaskFilter.overdue).first;
      expect(overdueTasks.map((t) => t.id).toList(), contains('t-overdue'));
    });

    test('searchQuery filters by title and description case-insensitively', () async {
      await repository.createTask(
        id: 'search-1',
        title: 'Grocery shopping',
        description: 'Buy fresh apples and oat milk',
      );
      await repository.createTask(
        id: 'search-2',
        title: 'Dentist appointment',
        description: 'Routine checkup',
      );

      final results =
          await repository.watchTasks(searchQuery: 'apples').first;
      expect(results.length, 1);
      expect(results.first.id, 'search-1');
    });

    test('watchTaskStats returns accurate counts and completion percentage', () async {
      await repository.createTask(id: 'stat-1', title: 'Task 1');
      await repository.createTask(id: 'stat-2', title: 'Task 2');
      await repository.createTask(id: 'stat-3', title: 'Task 3');
      await repository.toggleTaskCompleted('stat-1', true);

      final stats = await repository.watchTaskStats().first;
      expect(stats.totalCount, 3);
      expect(stats.completedCount, 1);
      expect(stats.pendingCount, 2);
      expect(stats.completionRate, closeTo(0.333, 0.01));
    });

    test('deleteTask removes task from database', () async {
      await repository.createTask(id: 'del-1', title: 'Delete me');
      var list = await repository.watchTasks().first;
      expect(list.length, 1);

      await repository.deleteTask('del-1');
      list = await repository.watchTasks().first;
      expect(list.isEmpty, isTrue);
    });
  });
}
