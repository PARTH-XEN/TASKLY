import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

enum TaskFilter { all, today, upcoming, overdue, completed }

enum TaskPriority { high, medium, low }

enum TaskCategory { personal, work, study, health, projects, other }

class TaskStats {
  final int totalCount;
  final int completedCount;
  final int pendingCount;
  final double completionRate;

  const TaskStats({
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
    required this.completionRate,
  });

  factory TaskStats.empty() => const TaskStats(
        totalCount: 0,
        completedCount: 0,
        pendingCount: 0,
        completionRate: 0.0,
      );
}

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TasksRepository(db);
});

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final taskCategoryFilterProvider = StateProvider<String?>((ref) => null);
final taskSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(tasksRepositoryProvider);
  final filter = ref.watch(taskFilterProvider);
  final category = ref.watch(taskCategoryFilterProvider);
  final query = ref.watch(taskSearchQueryProvider);
  return repo.watchTasks(filter: filter, category: category, searchQuery: query);
});

final taskStatsStreamProvider = StreamProvider<TaskStats>((ref) {
  final repo = ref.watch(tasksRepositoryProvider);
  return repo.watchTaskStats();
});

class TasksRepository {
  final AppDatabase _db;

  TasksRepository(this._db);

  Stream<List<Task>> watchTasks({
    TaskFilter filter = TaskFilter.all,
    String? category,
    String? searchQuery,
  }) {
    return _db.select(_db.tasks).watch().map((tasks) {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      return tasks.where((task) {
        // Search filter
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final query = searchQuery.trim().toLowerCase();
          final titleMatch = task.title.toLowerCase().contains(query);
          final descMatch =
              task.description?.toLowerCase().contains(query) ?? false;
          if (!titleMatch && !descMatch) return false;
        }

        // Category filter
        if (category != null && category.isNotEmpty && category != 'all') {
          if (task.category.toLowerCase() != category.toLowerCase()) return false;
        }

        // Status/Time filter
        switch (filter) {
          case TaskFilter.all:
            return true;
          case TaskFilter.completed:
            return task.isCompleted;
          case TaskFilter.today:
            if (task.isCompleted) return false;
            if (task.dueDate == null) return false;
            return task.dueDate!.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
                task.dueDate!.isBefore(todayEnd.add(const Duration(seconds: 1)));
          case TaskFilter.upcoming:
            if (task.isCompleted) return false;
            if (task.dueDate == null) return true;
            return task.dueDate!.isAfter(todayEnd);
          case TaskFilter.overdue:
            if (task.isCompleted) return false;
            if (task.dueDate == null) return false;
            return task.dueDate!.isBefore(todayStart);
        }
      }).toList()
        ..sort((a, b) {
          // Incompleted tasks first, then by priority (high > medium > low), then by dueDate
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          final pA = priorityOrder[a.priority.toLowerCase()] ?? 1;
          final pB = priorityOrder[b.priority.toLowerCase()] ?? 1;
          if (pA != pB) return pA.compareTo(pB);

          if (a.dueDate != null && b.dueDate != null) {
            return a.dueDate!.compareTo(b.dueDate!);
          }
          if (a.dueDate != null) return -1;
          if (b.dueDate != null) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
    });
  }

  Stream<TaskStats> watchTaskStats() {
    return _db.select(_db.tasks).watch().map((tasks) {
      if (tasks.isEmpty) return TaskStats.empty();
      final total = tasks.length;
      final completed = tasks.where((t) => t.isCompleted).length;
      final pending = total - completed;
      final rate = total > 0 ? (completed / total) : 0.0;
      return TaskStats(
        totalCount: total,
        completedCount: completed,
        pendingCount: pending,
        completionRate: rate,
      );
    });
  }

  Future<void> createTask({
    required String id,
    required String title,
    String? description,
    String category = 'personal',
    String priority = 'medium',
    DateTime? dueDate,
    String? dueTime,
    String? reminderId,
    String? notes,
  }) async {
    await _db.into(_db.tasks).insert(
          TasksCompanion.insert(
            id: id,
            title: title,
            description: Value(description),
            category: Value(category),
            priority: Value(priority),
            dueDate: Value(dueDate),
            dueTime: Value(dueTime),
            reminderId: Value(reminderId),
            notes: Value(notes),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> updateTask({
    required String id,
    required String title,
    String? description,
    String category = 'personal',
    String priority = 'medium',
    DateTime? dueDate,
    String? dueTime,
    String? notes,
  }) async {
    await (_db.update(_db.tasks)..where((tbl) => tbl.id.equals(id))).write(
      TasksCompanion(
        title: Value(title),
        description: Value(description),
        category: Value(category),
        priority: Value(priority),
        dueDate: Value(dueDate),
        dueTime: Value(dueTime),
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> toggleTaskCompleted(String id, bool isCompleted) async {
    await (_db.update(_db.tasks)..where((tbl) => tbl.id.equals(id))).write(
      TasksCompanion(
        isCompleted: Value(isCompleted),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteTask(String id) async {
    await (_db.delete(_db.tasks)..where((tbl) => tbl.id.equals(id))).go();
  }
}
