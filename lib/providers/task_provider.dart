import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pockettask/models/tasks.dart';

import '../services/task_storage.dart';


enum TaskFilter { all, active, done }


class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String _searchQuery = '';
  TaskFilter _currentFilter = TaskFilter.all;
  bool _isLoading = false;
  Timer? _searchDebouncer;
  
  // Undo functionality
  Task? _lastDeletedTask;
  int? _lastDeletedIndex;

  // Getters
  List<Task> get tasks => _getFilteredTasks();
  List<Task> get allTasks => List.unmodifiable(_tasks);
  String get searchQuery => _searchQuery;
  TaskFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  bool get canUndo => _lastDeletedTask != null;

  /// Get completion progress (0.0 to 1.0)
  double get completionProgress {
    if (_tasks.isEmpty) return 0.0;
    final completedCount = _tasks.where((task) => task.done).length;
    return completedCount / _tasks.length;
  }

  /// Get completed tasks count text
  String get progressText {
    final completed = _tasks.where((task) => task.done).length;
    return '$completed/${_tasks.length}';
  }

  /// Initialize provider and load saved tasks
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _tasks = await TaskStorage.loadTasks();
      // Sort by creation date (newest first)
      _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new task
  Future<bool> addTask(String title) async {
    if (title.trim().isEmpty) return false;
    
    final newTask = Task(title: title.trim());
    _tasks.insert(0, newTask); // Add to beginning
    _clearUndoState();
    notifyListeners();
    
    await _saveTasks();
    return true;
  }

  // Toggle task completion status
  Future<void> toggleTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final oldTask = _tasks[taskIndex];
    _tasks[taskIndex] = oldTask.copyWith(done: !oldTask.done);
    _clearUndoState();
    notifyListeners();
    
    await _saveTasks();
  }

  // Delete task with undo support
  Future<void> deleteTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    // Store for undo functionality
    _lastDeletedTask = _tasks[taskIndex];
    _lastDeletedIndex = taskIndex;
    
    _tasks.removeAt(taskIndex);
    notifyListeners();
    
    await _saveTasks();
  }

  // Undo last delete action
  Future<void> undoDelete() async {
    if (_lastDeletedTask == null || _lastDeletedIndex == null) return;
    
    _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
    _clearUndoState();
    notifyListeners();
    
    await _saveTasks();
  }

  // Update search query with debouncing
  void updateSearchQuery(String query) {
    _searchDebouncer?.cancel();
    _searchDebouncer = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = query.toLowerCase().trim();
      notifyListeners();
    });
  }

  // Update filter type
  void updateFilter(TaskFilter filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      notifyListeners();
    }
  }

  // Get filtered and searched tasks
  List<Task> _getFilteredTasks() {
    var filteredTasks = _tasks;

    // Apply filter
    switch (_currentFilter) {
      case TaskFilter.active:
        filteredTasks = filteredTasks.where((task) => !task.done).toList();
        break;
      case TaskFilter.done:
        filteredTasks = filteredTasks.where((task) => task.done).toList();
        break;
      case TaskFilter.all:
        break;
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) => task.title.toLowerCase().contains(_searchQuery))
          .toList();
    }

    return filteredTasks;
  }

  // Save tasks to storage
  Future<void> _saveTasks() async {
    try {
      await TaskStorage.saveTasks(_tasks);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  // Clear undo state
  void _clearUndoState() {
    _lastDeletedTask = null;
    _lastDeletedIndex = null;
  }

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    super.dispose();
  }
}
