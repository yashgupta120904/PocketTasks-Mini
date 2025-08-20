import 'package:flutter_test/flutter_test.dart';
import 'package:pockettask/providers/task_provider.dart';


void main() {
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;

    setUp(() {
      taskProvider = TaskProvider();
    });

    tearDown(() {
      taskProvider.dispose();
    });

    test('should initialize with empty task list', () {
      expect(taskProvider.tasks, isEmpty);
      expect(taskProvider.completionProgress, equals(0.0));
      expect(taskProvider.currentFilter, equals(TaskFilter.all));
    });

    test('should add task successfully', () async {
      const taskTitle = 'Test Task';
      
      final result = await taskProvider.addTask(taskTitle);
      
      expect(result, isTrue);
      expect(taskProvider.allTasks.length, equals(1));
      expect(taskProvider.allTasks.first.title, equals(taskTitle));
      expect(taskProvider.allTasks.first.done, isFalse);
    });

    test('should not add empty task', () async {
      final result = await taskProvider.addTask('');
      
      expect(result, isFalse);
      expect(taskProvider.allTasks, isEmpty);
    });

    test('should toggle task completion', () async {
      // Add a task first
      await taskProvider.addTask('Test Task');
      final taskId = taskProvider.allTasks.first.id;
      
      // Toggle to completed
      await taskProvider.toggleTask(taskId);
      expect(taskProvider.allTasks.first.done, isTrue);
      
      // Toggle back to active
      await taskProvider.toggleTask(taskId);
      expect(taskProvider.allTasks.first.done, isFalse);
    });

    test('should calculate completion progress correctly', () async {
      // Add 3 tasks
      await taskProvider.addTask('Task 1');
      await taskProvider.addTask('Task 2');
      await taskProvider.addTask('Task 3');
      
      // Complete 1 task
      await taskProvider.toggleTask(taskProvider.allTasks.first.id);
      
      expect(taskProvider.completionProgress, closeTo(0.33, 0.01));
      expect(taskProvider.progressText, equals('1/3'));
      
      // Complete another task
      await taskProvider.toggleTask(taskProvider.allTasks[1].id);
      
      expect(taskProvider.completionProgress, closeTo(0.67, 0.01));
      expect(taskProvider.progressText, equals('2/3'));
    });

    test('should filter tasks correctly', () async {
      // Add mixed tasks
      await taskProvider.addTask('Active Task 1');
      await taskProvider.addTask('Active Task 2');
      await taskProvider.addTask('Done Task');
      
      // Mark one task as done
      await taskProvider.toggleTask(taskProvider.allTasks.last.id);
      
      // Test All filter
      taskProvider.updateFilter(TaskFilter.all);
      expect(taskProvider.tasks.length, equals(3));
      
      // Test Active filter
      taskProvider.updateFilter(TaskFilter.active);
      expect(taskProvider.tasks.length, equals(2));
      expect(taskProvider.tasks.every((task) => !task.done), isTrue);
      
      // Test Done filter
      taskProvider.updateFilter(TaskFilter.done);
      expect(taskProvider.tasks.length, equals(1));
      expect(taskProvider.tasks.every((task) => task.done), isTrue);
    });

    test('should search tasks by title', () async {
      // Add test tasks
      await taskProvider.addTask('Buy groceries');
      await taskProvider.addTask('Walk the dog');
      await taskProvider.addTask('Buy milk');
      
      // Search for "buy"
      taskProvider.updateSearchQuery('buy');
      
      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 350));
      
      expect(taskProvider.tasks.length, equals(2));
      expect(taskProvider.tasks.every((task) => 
        task.title.toLowerCase().contains('buy')), isTrue);
    });

    test('should combine search and filter correctly', () async {
      // Add test tasks
      await taskProvider.addTask('Buy groceries');
      await taskProvider.addTask('Walk the dog');
      await taskProvider.addTask('Buy milk');
      
      // Mark one "buy" task as done
      final buyTask = taskProvider.allTasks
          .firstWhere((task) => task.title.contains('Buy groceries'));
      await taskProvider.toggleTask(buyTask.id);
      
      // Search for "buy" and filter for active
      taskProvider.updateSearchQuery('buy');
      await Future.delayed(const Duration(milliseconds: 350));
      taskProvider.updateFilter(TaskFilter.active);
      
      expect(taskProvider.tasks.length, equals(1));
      expect(taskProvider.tasks.first.title, equals('Buy milk'));
      expect(taskProvider.tasks.first.done, isFalse);
    });

    test('should delete and undo task correctly', () async {
      // Add a task
      await taskProvider.addTask('Test Task');
      final taskId = taskProvider.allTasks.first.id;
      
      expect(taskProvider.allTasks.length, equals(1));
      expect(taskProvider.canUndo, isFalse);
      
      // Delete the task
      await taskProvider.deleteTask(taskId);
      
      expect(taskProvider.allTasks.length, equals(0));
      expect(taskProvider.canUndo, isTrue);
      
      // Undo the delete
      await taskProvider.undoDelete();
      
      expect(taskProvider.allTasks.length, equals(1));
      expect(taskProvider.allTasks.first.id, equals(taskId));
      expect(taskProvider.canUndo, isFalse);
    });

    test('should handle empty search query', () async {
      await taskProvider.addTask('Task 1');
      await taskProvider.addTask('Task 2');
      
      // Apply search then clear it
      taskProvider.updateSearchQuery('Task 1');
      await Future.delayed(const Duration(milliseconds: 350));
      
      expect(taskProvider.tasks.length, equals(1));
      
      taskProvider.updateSearchQuery('');
      await Future.delayed(const Duration(milliseconds: 350));
      
      expect(taskProvider.tasks.length, equals(2));
    });
  });
}
