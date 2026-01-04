// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'task_type.dart';

class Tasks {
  final String id;
  final List<ToRun> toRun;

  Tasks({
    String? id,
    required this.toRun,
  }) : id = id ?? Uuid().v4();

  Tasks copyWith({
    String? id,
    List<ToRun>? toRun,
  }) {
    return Tasks(
      id: id ?? this.id,
      toRun: toRun ?? this.toRun,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'toRun': toRun.map((x) => x.toJson()).toList(),
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'] as String,
      toRun: List<ToRun>.from(
        (map['toRun']).map<ToRun>(
          (x) => ToRun.fromJson(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tasks.fromJson(String source) =>
      Tasks.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tasks(id: $id, toRun: $toRun)';
  @override
  bool operator ==(covariant Tasks other) {
    if (identical(this, other)) return true;

    return other.id == id && listEquals(other.toRun, toRun);
  }

  @override
  int get hashCode => id.hashCode ^ toRun.hashCode;
}
