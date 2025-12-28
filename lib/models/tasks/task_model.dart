// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'task_type.dart';

class Tasks {
  final String id;
  final List<TaskType> tasks;

  Tasks({
    required this.id,
    required this.tasks,
  });

  Tasks copyWith({
    String? id,
    List<TaskType>? tasks,
  }) {
    return Tasks(
      id: id ?? this.id,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tasks': tasks.map((x) => x.toJson()).toList(),
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'] as String,
      tasks: List<TaskType>.from(
        (map['tasks'] as List<String>).map<TaskType>(
          (x) => TaskType.fromJson(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tasks.fromJson(String source) =>
      Tasks.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tasks(id: $id, tasks: $tasks)';
  @override
  bool operator ==(covariant Tasks other) {
    if (identical(this, other)) return true;

    return other.id == id && listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode => id.hashCode ^ tasks.hashCode;
}
