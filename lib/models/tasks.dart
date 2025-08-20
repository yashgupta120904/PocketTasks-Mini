import 'package:uuid/uuid.dart';

// Task model with JSON serialization support
class Task {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.done = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Create Task from JSON map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  //Convert Task to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a copy of task with modified fields
  Task copyWith({
    String? id,
    String? title,
    bool? done,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Task(id: $id, title: $title, done: $done)';
}
