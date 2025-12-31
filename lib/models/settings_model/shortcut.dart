// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/tasks/task_model.dart';
import 'package:scrcpygui/utils/extension.dart';

class Shortcut {
  final String id;
  final HotKey hotKey;
  final Tasks task;

  Shortcut({
    required this.id,
    required this.hotKey,
    required this.task,
  });
  Shortcut copyWith({
    String? id,
    HotKey? hotKey,
    Tasks? task,
  }) {
    return Shortcut(
      id: id ?? this.id,
      hotKey: hotKey ?? this.hotKey,
      task: task ?? this.task,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hotKey': hotKey.toJson(),
      'task': task.toMap(),
    };
  }

  factory Shortcut.fromMap(Map<String, dynamic> map) {
    return Shortcut(
      id: map['id'] as String,
      hotKey: HotKey.fromJson(map['hotKey']),
      task: Tasks.fromMap(map['task'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Shortcut.fromJson(String source) =>
      Shortcut.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Shortcut other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.hotKey.isEqualTo(hotKey) &&
        other.task == task;
  }

  @override
  int get hashCode => id.hashCode ^ hotKey.hash() ^ task.hashCode;

  @override
  String toString() => 'Shortcut(id: $id, hotKey: $hotKey, task: $task)';
}
