// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

import 'scrcpy_related/scrcpy_config.dart';

class AppConfigPair {
  final String deviceId;
  final ScrcpyApp app;
  final ScrcpyConfig config;
  AppConfigPair({
    required this.deviceId,
    required this.app,
    required this.config,
  });

  AppConfigPair copyWith({
    String? deviceId,
    ScrcpyApp? app,
    ScrcpyConfig? config,
  }) {
    return AppConfigPair(
      deviceId: deviceId ?? this.deviceId,
      app: app ?? this.app,
      config: config ?? this.config,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceId': deviceId,
      'app': app.toMap(),
      'config': config.toMap(),
    };
  }

  factory AppConfigPair.fromMap(Map<String, dynamic> map) {
    return AppConfigPair(
      deviceId: map['deviceId'] as String,
      app: ScrcpyApp.fromMap(map['app'] as Map<String, dynamic>),
      config: ScrcpyConfig.fromMap(map['config'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppConfigPair.fromJson(String source) =>
      AppConfigPair.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AppConfigPair(deviceId: $deviceId, app: $app, config: $config)';

  @override
  bool operator ==(covariant AppConfigPair other) {
    if (identical(this, other)) return true;

    return other.deviceId == deviceId &&
        other.app == app &&
        other.config == config;
  }

  @override
  int get hashCode => deviceId.hashCode ^ app.hashCode ^ config.hashCode;
}
