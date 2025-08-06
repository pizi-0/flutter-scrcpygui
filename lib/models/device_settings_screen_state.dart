// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:scrcpygui/models/automation.dart';

class DeviceSettingsScreenState {
  final String deviceName;
  final List<ConfigAutomation> autoLaunchConfig;
  final bool autoConnect;
  final bool loading;
  final bool autoLaunch;

  DeviceSettingsScreenState({
    required this.deviceName,
    required this.autoLaunchConfig,
    required this.autoConnect,
    required this.loading,
    required this.autoLaunch,
  });

  DeviceSettingsScreenState copyWith({
    String? deviceName,
    List<ConfigAutomation>? autoLaunchConfig,
    bool? autoConnect,
    bool? loading,
    bool? autoLaunch,
  }) {
    return DeviceSettingsScreenState(
      deviceName: deviceName ?? this.deviceName,
      autoLaunchConfig: autoLaunchConfig ?? this.autoLaunchConfig,
      autoConnect: autoConnect ?? this.autoConnect,
      loading: loading ?? this.loading,
      autoLaunch: autoLaunch ?? this.autoLaunch,
    );
  }

  @override
  bool operator ==(covariant DeviceSettingsScreenState other) {
    if (identical(this, other)) return true;

    return other.deviceName == deviceName &&
        listEquals(other.autoLaunchConfig, autoLaunchConfig) &&
        other.autoConnect == autoConnect;
  }

  @override
  int get hashCode {
    return deviceName.hashCode ^
        autoLaunchConfig.hashCode ^
        autoLaunch.hashCode ^
        autoConnect.hashCode;
  }
}
