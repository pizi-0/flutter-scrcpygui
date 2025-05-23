// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/utils/command_runner.dart';
import 'package:scrcpygui/utils/const.dart';

class AdbDevices {
  String? name;
  final String id;
  String? ip;
  final String modelName;
  final String serialNo;
  final bool status;
  final AutomationData? automationData;
  final ScrcpyInfo? info;

  AdbDevices({
    this.name,
    required this.id,
    this.ip,
    required this.modelName,
    required this.serialNo,
    required this.status,
    this.automationData,
    this.info,
  }) {
    name = name ?? modelName;
    ip = ip ?? id.split(':').first;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'modelName': modelName,
      'serialNo': serialNo,
      'status': status,
      'ip': ip ?? id,
      'automationData': automationData?.toMap(),
      'info': info?.toMap(),
    };
  }

  factory AdbDevices.fromMap(Map<String, dynamic> map) {
    return AdbDevices(
      name: map['name'] != null ? map['name'] as String : map['modelName'],
      id: map['id'] as String,
      ip: map['ip'] ?? map['id'],
      modelName: map['modelName'] as String,
      serialNo: map['serialNo'] as String,
      status: map['status'] as bool,
      automationData: map['automationData'] != null
          ? AutomationData.fromMap(
              map['automationData'] as Map<String, dynamic>)
          : defaultAutomationData,
      info: map['info'] != null
          ? ScrcpyInfo.fromMap(map['info'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdbDevices.fromJson(String source) =>
      AdbDevices.fromMap(json.decode(source) as Map<String, dynamic>);

  AdbDevices copyWith({
    String? name,
    String? id,
    String? ip,
    String? modelName,
    String? serialNo,
    bool? status,
    AutomationData? automationData,
    ScrcpyInfo? info,
  }) {
    return AdbDevices(
      name: name ?? this.name,
      id: id ?? this.id,
      ip: ip ?? this.ip,
      modelName: modelName ?? this.modelName,
      serialNo: serialNo ?? this.serialNo,
      status: status ?? this.status,
      automationData: automationData ?? this.automationData,
      info: info ?? this.info,
    );
  }

  Future<ProcessResult> sendKeyEvent(String workDir, String key) async {
    final res = await CommandRunner.runAdbShellCommand(workDir, this,
        args: ['input', 'keyevent', key]);

    return res;
  }

  @override
  bool operator ==(covariant AdbDevices other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.ip == ip &&
        other.modelName == modelName &&
        other.serialNo == serialNo &&
        other.status == status &&
        other.automationData == automationData &&
        other.info == info;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        ip.hashCode ^
        modelName.hashCode ^
        serialNo.hashCode ^
        status.hashCode ^
        automationData.hashCode ^
        info.hashCode;
  }

  @override
  String toString() {
    return 'AdbDevices(name: $name, id: $id, ip: $ip, modelName: $modelName, serialNo: $serialNo, status: $status, automationData: $automationData, info: $info)';
  }
}
