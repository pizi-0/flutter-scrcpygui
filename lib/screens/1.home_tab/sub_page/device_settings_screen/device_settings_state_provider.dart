import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/models/device_settings_screen_state.dart';

import '../../../../providers/automation_provider.dart';
import '../../../../providers/device_info_provider.dart';

class DeviceSettingsStateNotifier
    extends AutoDisposeFamilyNotifier<DeviceSettingsScreenState, AdbDevices> {
  @override
  build(AdbDevices device) {
    final info = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == device.serialNo);

    final autolaunch = ref
        .read(autoLaunchProvider)
        .where((a) => a.deviceId == device.id)
        .toList();

    final autoConnect = ref
        .read(autoConnectProvider)
        .where((a) => a.deviceIp == device.id)
        .isNotEmpty;

    return DeviceSettingsScreenState(
      deviceName: info?.deviceName ?? device.modelName,
      autoLaunchConfig: autolaunch,
      autoConnect: autoConnect,
      loading: false,
      autoLaunch: autolaunch.isNotEmpty,
    );
  }

  void toggleLoading() {
    state = state.copyWith(loading: !state.loading);
  }

  void rename(String name) {
    state = state.copyWith(deviceName: name.trim());
  }

  void toggleAutoConnect() {
    state = state.copyWith(autoConnect: !state.autoConnect);
  }

  void toggleAutoLaunch() {
    state = state.copyWith(autoLaunch: !state.autoLaunch);

    state = state.copyWith(autoLaunchConfig: []);
  }

  void toggleConfig(ConfigAutomation ca) {
    final currentAutoLaunchConfigs = [...state.autoLaunchConfig];

    if (currentAutoLaunchConfigs.contains(ca)) {
      currentAutoLaunchConfigs.remove(ca);
    } else {
      currentAutoLaunchConfigs.add(ca);
    }

    state = state.copyWith(autoLaunchConfig: currentAutoLaunchConfigs);
  }
}

final deviceSettingsStateProvider = NotifierProvider.autoDispose
    .family<DeviceSettingsStateNotifier, DeviceSettingsScreenState, AdbDevices>(
        () => DeviceSettingsStateNotifier());
