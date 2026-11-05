import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/tasks_repository.dart';
import 'widgets/create_edit_task_sheet.dart';
import 'widgets/task_filter_bar.dart';
import 'widgets/task_item_tile.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateEditSheet([Task? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateEditTaskSheet(taskToEdit: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedFilter = ref.watch(taskFilterProvider);
    final selectedCategory = ref.watch(taskCategoryFilterProvider);
    final tasksAsync = ref.watch(filteredTasksStreamProvider);
    final statsAsync = ref.watch(taskStatsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                ),
                onChanged: (val) {
                  ref.read(taskSearchQueryProvider.notifier).state = val;
                },
              )
            : const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
            ),
            tooltip: _isSearching ? 'Close search' : 'Search tasks',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  ref.read(taskSearchQueryProvider.notifier).state = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add task',
            onPressed: () => _showCreateEditSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Category Bar
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.xs,
            ),
            child: TaskFilterBar(
              selectedFilter: selectedFilter,
              selectedCategory: selectedCategory,
              onFilterChanged: (filter) {
                ref.read(taskFilterProvider.notifier).state = filter;
              },
              onCategoryChanged: (cat) {
                ref.read(taskCategoryFilterProvider.notifier).state = cat;
              },
            ),
          ),

          // Overview status summary bar
          statsAsync.when(
            data: (stats) {
              if (stats.totalCount == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Text(
                      '${stats.pendingCount} pending',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.indigoLight,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '• ${stats.completedCount} completed',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(stats.completionRate * 100).round()}% done',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.successLight,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          const Divider(height: 1),

          // Tasks List or Empty State
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.indigoLight.withValues(
                                alpha: 0.12,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.checklist_rounded,
                              size: 32,
                              color: AppColors.indigoLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            selectedFilter == TaskFilter.completed
                                ? 'No completed tasks yet'
                                : 'No tasks found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            selectedFilter == TaskFilter.completed
                                ? 'Complete tasks to track your productivity!'
                                : 'Tap the + button to create your first task.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add Task'),
                            onPressed: () => _showCreateEditSheet(),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xs,
                    bottom: AppSpacing.xxl * 2,
                  ),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskItemTile(
                      task: task,
                      onToggleCompleted: (completed) {
                        ref
                            .read(tasksRepositoryProvider)
                            .toggleTaskCompleted(task.id, completed);
                      },
                      onTap: () => _showCreateEditSheet(task),
                      onDelete: () {
                        ref.read(tasksRepositoryProvider).deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Deleted "${task.title}"'),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Error loading tasks: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'tasks_screen_fab',
        onPressed: () => _showCreateEditSheet(),
        backgroundColor: AppColors.indigoLight,
        foregroundColor: Colors.white,
        tooltip: 'Add Task',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
