import 'dart:convert';
import 'package:pockettask/models/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';



class TaskStorage {
  static const String _storageKey = 'pocket_tasks_v1';

  /// Save tasks list to local storage as JSON
  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      final jsonString = jsonEncode(tasksJson);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save tasks: $e');
    }
  }

  /// Load tasks list from local storage
  static Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return <Task>[];
      }

      final List<dynamic> tasksJson = jsonDecode(jsonString);
      return tasksJson
          .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return empty list if loading fails to prevent app crash
      return <Task>[];
    }
  }

  /// Clear all stored tasks
  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
