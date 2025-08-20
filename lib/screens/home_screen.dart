import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/progress_ring.dart';
import '../widgets/add_task_field.dart';
import '../widgets/search_box.dart';
import '../widgets/filter_chips.dart';
import '../widgets/task_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C003E), 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
            bottom: 10,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF2C003E),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress ring
              Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  return ProgressRing(
                    progress: provider.completionProgress,
                    centerText: provider.progressText,
                    size: 60,
                    strokeWidth: 6,
                  );
                },
              ),
              const SizedBox(width: 20),
              // App title
              const Text(
                'PocketTasks',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Task Section
                AddTaskField(
                  onAddTask: (title) async {
                    final success = await taskProvider.addTask(title);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Task added successfully'),
                          backgroundColor: Colors.green[600],
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Search Box
                SearchBox(
                  onSearchChanged: taskProvider.updateSearchQuery,
                ),
                
                const SizedBox(height: 24),
                
                // Filter Chips
                FilterChips(
                  currentFilter: taskProvider.currentFilter,
                  onFilterChanged: taskProvider.updateFilter,
                ),
                
                const SizedBox(height: 24),
                
                // Task List
                Expanded(
                  child: taskProvider.tasks.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return TaskItem(
                            task: task,
                            onToggle: () async {
                              await taskProvider.toggleTask(task.id);
                              if (context.mounted) {
                                _showUndoSnackBar(
                                  context,
                                  task.done 
                                    ? 'Task marked as active' 
                                    : 'Task completed',
                                  () => taskProvider.toggleTask(task.id),
                                );
                              }
                            },
                            onDelete: () async {
                              await taskProvider.deleteTask(task.id);
                              if (context.mounted) {
                                _showUndoSnackBar(
                                  context,
                                  'Task deleted',
                                  taskProvider.undoDelete,
                                  canUndo: taskProvider.canUndo,
                                );
                              }
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a task to get started',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Show snack bar with undo functionality
  void _showUndoSnackBar(
    BuildContext context,
    String message,
    VoidCallback undoAction, {
    bool canUndo = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 4),
        action: canUndo
          ? SnackBarAction(
              label: 'Undo',
              textColor: Colors.blue[300],
              onPressed: undoAction,
            )
          : null,
      ),
    );
  }
}