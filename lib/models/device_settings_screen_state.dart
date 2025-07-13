// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:scrcpygui/models/automation.dart';

class DeviceSettingsScreenState {
  final TextEditingController namecontroller;
  final List<ConfigAutomation> autoLaunchConfig;
  final bool autoConnect;
  final bool loading;
  final bool autoLaunch;

  DeviceSettingsScreenState({
    required this.namecontroller,
    required this.autoLaunchConfig,
    required this.autoConnect,
    required this.loading,
    required this.autoLaunch,
  });

  DeviceSettingsScreenState copyWith({
    TextEditingController? namecontroller,
    List<ConfigAutomation>? autoLaunchConfig,
    bool? autoConnect,
    bool? loading,
    bool? autoLaunch,
  }) {
    return DeviceSettingsScreenState(
      namecontroller: namecontroller ?? this.namecontroller,
      autoLaunchConfig: autoLaunchConfig ?? this.autoLaunchConfig,
      autoConnect: autoConnect ?? this.autoConnect,
      loading: loading ?? this.loading,
      autoLaunch: autoLaunch ?? this.autoLaunch,
    );
  }

  @override
  bool operator ==(covariant DeviceSettingsScreenState other) {
    if (identical(this, other)) return true;

    return other.namecontroller.text == namecontroller.text &&
        listEquals(other.autoLaunchConfig, autoLaunchConfig) &&
        other.autoConnect == autoConnect;
  }

  @override
  int get hashCode {
    return namecontroller.hashCode ^
        autoLaunchConfig.hashCode ^
        autoLaunch.hashCode ^
        autoConnect.hashCode;
  }
}
