// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:scrcpygui/models/tasks/task_type_ids.dart';

sealed class TaskType {
  final String id;
  const TaskType({required this.id});

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());

  factory TaskType.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    final id = map['id'] as String;

    switch (id) {
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
        throw Exception('Unknown TaskType: $id');
    }
  }
}

class StartScrcpyTask extends TaskType {
  final String? configId;
  final String? serialNo;
  final bool? preferWireless;

  StartScrcpyTask(
      {String type = TaskId.startScrcpy,
      this.configId,
      this.serialNo,
      this.preferWireless = false})
      : super(id: TaskId.startScrcpy);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
}

class StopScrcpyTask extends TaskType {
  final String? deviceId;
  final String? pid;

  StopScrcpyTask({this.deviceId, this.pid}) : super(id: TaskId.stopScrcpy);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
}

class ConnectWirelessTask extends TaskType {
  final String deviceId;

  ConnectWirelessTask({required this.deviceId})
      : super(id: TaskId.connectWireless);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deviceId': deviceId,
    };
  }

  factory ConnectWirelessTask.fromMap(Map<String, dynamic> map) {
    return ConnectWirelessTask(
      deviceId: map['deviceId'] as String,
    );
  }
}

class DisconnectWirelessTask extends TaskType {
  final String deviceId;

  DisconnectWirelessTask({required this.deviceId})
      : super(id: TaskId.disconnectWireless);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deviceId': deviceId,
    };
  }

  factory DisconnectWirelessTask.fromMap(Map<String, dynamic> map) {
    return DisconnectWirelessTask(
      deviceId: map['deviceId'] as String,
    );
  }
}

class RunAdbCommandTask extends TaskType {
  final String deviceId;
  final List<String> commands;

  RunAdbCommandTask({required this.deviceId, required this.commands})
      : super(id: TaskId.runAdbCommand);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
}
