// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/adb_devices.dart';

class DevicePayload {
  final String name;
  final String id;

  DevicePayload({required this.name, required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory DevicePayload.fromMap(Map<String, dynamic> map) {
    return DevicePayload(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DevicePayload.fromJson(String source) =>
      DevicePayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension DevicePayloader on AdbDevices {
  DevicePayload toPayload() {
    return DevicePayload(name: name ?? modelName, id: id);
  }
}
