// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';

class InstancePayload {
  final String name;
  final String pid;
  final String deviceId;

  InstancePayload(
      {required this.name, required this.pid, required this.deviceId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'pid': pid,
      'deviceId': deviceId,
    };
  }

  factory InstancePayload.fromMap(Map<String, dynamic> map) {
    return InstancePayload(
      name: map['name'] as String,
      pid: map['pid'] as String,
      deviceId: map['deviceId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InstancePayload.fromJson(String source) =>
      InstancePayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension InstancePayloader on ScrcpyRunningInstance {
  InstancePayload toPayload() {
    return InstancePayload(
        name: instanceName, pid: scrcpyPID, deviceId: device.id);
  }
}
