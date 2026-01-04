// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:scrcpygui/models/tasks/task_type_ids.dart';
import 'package:uuid/uuid.dart';

sealed class ToRun {
  final String id;
  final String taskId;

  ToRun({
    String? id,
    required this.taskId,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());

  factory ToRun.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    final taskId = map['taskId'] as String;

    switch (taskId) {
      case TaskId.startScrcpy:
        return StartScrcpyTask.fromMap(map);
      case TaskId.stopScrcpy:
        return StopScrcpyTask.fromMap(map);
      case TaskId.connectWireless:
        return ConnectWirelessTask.fromMap(map);
      case TaskId.disconnectWireless:
        return DisconnectWirelessTask.fromMap(map);
      case TaskId.runAdbCommand:
        return RunAdbCommandTask.fromMap(map);
      default:
        throw Exception('Unknown ToRun: $taskId');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToRun &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taskId == other.taskId;

  @override
  int get hashCode => id.hashCode ^ taskId.hashCode;
}

class StartScrcpyTask extends ToRun {
  final String? configId;
  final String? serialNo;
  final bool? preferWireless;

  StartScrcpyTask(
      {String type = TaskId.startScrcpy,
      this.configId,
      this.serialNo,
      this.preferWireless = false})
      : super(taskId: TaskId.startScrcpy);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'configId': configId,
      'serialNo': serialNo,
      'preferWireless': preferWireless,
    };
  }

  factory StartScrcpyTask.fromMap(Map<String, dynamic> map) {
    return StartScrcpyTask(
      configId: map['configId'] as String?,
      serialNo: map['serialNo'] as String?,
    );
  }

  StartScrcpyTask copyWith({
    String? configId,
    String? serialNo,
    bool? preferWireless,
  }) {
    return StartScrcpyTask(
      configId: configId ?? this.configId,
      serialNo: serialNo ?? this.serialNo,
      preferWireless: preferWireless ?? this.preferWireless,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StartScrcpyTask &&
        other.configId == configId &&
        other.serialNo == serialNo &&
        other.preferWireless == preferWireless;
  }

  @override
  int get hashCode =>
      configId.hashCode ^ serialNo.hashCode ^ preferWireless.hashCode;
}

class StopScrcpyTask extends ToRun {
  final String? deviceId;
  final String? pid;

  StopScrcpyTask({this.deviceId, this.pid}) : super(taskId: TaskId.stopScrcpy);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'deviceId': deviceId,
      'pid': pid,
    };
  }

  factory StopScrcpyTask.fromMap(Map<String, dynamic> map) {
    return StopScrcpyTask(
      deviceId: map['deviceId'] as String?,
      pid: map['pid'] as String?,
    );
  }

  StopScrcpyTask copyWith({
    String? deviceId,
    String? pid,
  }) {
    return StopScrcpyTask(
      deviceId: deviceId ?? this.deviceId,
      pid: pid ?? this.pid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StopScrcpyTask &&
        other.deviceId == deviceId &&
        other.pid == pid;
  }

  @override
  int get hashCode => deviceId.hashCode ^ pid.hashCode;
}

class ConnectWirelessTask extends ToRun {
  final String deviceId;

  ConnectWirelessTask({required this.deviceId})
      : super(taskId: TaskId.connectWireless);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'deviceId': deviceId,
    };
  }

  factory ConnectWirelessTask.fromMap(Map<String, dynamic> map) {
    return ConnectWirelessTask(
      deviceId: map['deviceId'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConnectWirelessTask && other.deviceId == deviceId;
  }

  @override
  int get hashCode => deviceId.hashCode;
}

class DisconnectWirelessTask extends ToRun {
  final String deviceId;

  DisconnectWirelessTask({required this.deviceId})
      : super(taskId: TaskId.disconnectWireless);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'deviceId': deviceId,
    };
  }

  factory DisconnectWirelessTask.fromMap(Map<String, dynamic> map) {
    return DisconnectWirelessTask(
      deviceId: map['deviceId'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DisconnectWirelessTask && other.deviceId == deviceId;
  }

  @override
  int get hashCode => deviceId.hashCode;
}

class RunAdbCommandTask extends ToRun {
  final String deviceId;
  final List<String> commands;

  RunAdbCommandTask({required this.deviceId, required this.commands})
      : super(taskId: TaskId.runAdbCommand);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'deviceId': deviceId,
      'commands': commands,
    };
  }

  factory RunAdbCommandTask.fromMap(Map<String, dynamic> map) {
    return RunAdbCommandTask(
      deviceId: map['deviceId'] as String,
      commands: List<String>.from((map['commands'] as List)),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RunAdbCommandTask &&
        other.deviceId == deviceId &&
        listEquals(other.commands, commands);
  }

  @override
  int get hashCode => deviceId.hashCode ^ Object.hashAll(commands);
}

class RunTasksList extends ToRun {
  final List<ToRun> tasks;

  RunTasksList({required this.tasks}) : super(taskId: TaskId.runTasksList);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'tasks': tasks.map((e) => e.toMap()).toList(),
    };
  }

  factory RunTasksList.fromMap(Map<String, dynamic> map) {
    return RunTasksList(
      tasks: List<ToRun>.from(
        (map['tasks'] as List).map(
          (e) => ToRun.fromJson(
            json.encode(e),
          ),
        ),
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RunTasksList && listEquals(other.tasks, tasks);
  }

  @override
  int get hashCode => tasks.hashCode;
}
