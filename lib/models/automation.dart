// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ConfigAutomation {
  final String deviceId;
  final String configId;

  ConfigAutomation({required this.deviceId, required this.configId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceId': deviceId,
      'configId': configId,
    };
  }

  factory ConfigAutomation.fromMap(Map<String, dynamic> map) {
    return ConfigAutomation(
      deviceId: map['deviceId'] as String,
      configId: map['configId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigAutomation.fromJson(String source) =>
      ConfigAutomation.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ConnectAutomation {
  final String deviceIp;

  ConnectAutomation({required this.deviceIp});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceIp': deviceIp,
    };
  }

  factory ConnectAutomation.fromMap(Map<String, dynamic> map) {
    return ConnectAutomation(
      deviceIp: map['deviceIp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectAutomation.fromJson(String source) =>
      ConnectAutomation.fromMap(json.decode(source) as Map<String, dynamic>);
}
