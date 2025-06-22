// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';

class DevicePayload {
  final String name;
  final String id;
  final String serialNo;

  DevicePayload({required this.name, required this.id, required this.serialNo});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'serialNo': serialNo,
    };
  }

  factory DevicePayload.fromMap(Map<String, dynamic> map) {
    return DevicePayload(
      name: map['name'] as String,
      id: map['id'] as String,
      serialNo: map['serialNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DevicePayload.fromJson(String source) =>
      DevicePayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension DevicePayloader on AdbDevices {
  DevicePayload toPayload(WidgetRef ref) {
    final info =
        ref.read(infoProvider).firstWhereOrNull((i) => i.serialNo == serialNo);

    return DevicePayload(
        name: info?.deviceName ?? modelName, id: id, serialNo: serialNo);
  }
}
