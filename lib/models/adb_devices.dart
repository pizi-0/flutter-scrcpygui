// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:scrcpygui/utils/command_runner.dart';

class AdbDevices {
  final String id;
  String? ip;
  final String modelName;
  final String serialNo;
  final bool status;

  AdbDevices({
    required this.id,
    this.ip,
    required this.modelName,
    required this.serialNo,
    required this.status,
  }) {
    ip = ip ?? id.split(':').first;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'modelName': modelName,
      'serialNo': serialNo,
      'status': status,
      'ip': ip ?? id,
    };
  }

  factory AdbDevices.fromMap(Map<String, dynamic> map) {
    return AdbDevices(
      id: map['id'] as String,
      ip: map['ip'] ?? map['id'],
      modelName: map['modelName'] as String,
      serialNo: map['serialNo'] as String,
      status: map['status'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdbDevices.fromJson(String source) =>
      AdbDevices.fromMap(json.decode(source) as Map<String, dynamic>);

  AdbDevices copyWith({
    String? id,
    String? ip,
    String? modelName,
    String? serialNo,
    bool? status,
  }) {
    return AdbDevices(
      id: id ?? this.id,
      ip: ip ?? this.ip,
      modelName: modelName ?? this.modelName,
      serialNo: serialNo ?? this.serialNo,
      status: status ?? this.status,
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

    return other.id == id &&
        other.ip == ip &&
        other.modelName == modelName &&
        other.serialNo == serialNo &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ip.hashCode ^
        modelName.hashCode ^
        serialNo.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'AdbDevices(id: $id, ip: $ip, modelName: $modelName, serialNo: $serialNo, status: $status)';
  }
}
