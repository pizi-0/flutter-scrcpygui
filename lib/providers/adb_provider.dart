import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/utils/tray_utils.dart';
import 'package:tray_manager/tray_manager.dart';

class AdbNotifier extends Notifier<List<AdbDevices>> {
  @override
  build() {
    return [];
  }

  setConnected(List<AdbDevices> connected, List<AdbDevices> saved,
      List<ScrcpyConfig> configs) {
    List<AdbDevices> currentAdb = state;

    if (currentAdb.length > connected.length) {
      final diff = currentAdb.toSet().difference(connected.toSet()).toList();

      List<AdbDevices> newCurrent =
          currentAdb.where((d) => !diff.contains(d)).toList();

      trayManager.destroy();
      TrayUtils.initTray(newCurrent, saved, configs);

      state = [...newCurrent];

      //device connected
    } else if (connected.length > currentAdb.length) {
      final diff = connected.toSet().difference(currentAdb.toSet()).toList();

      final newCurrent = [...currentAdb, ...diff];

      trayManager.destroy();
      TrayUtils.initTray(newCurrent, saved, configs);

      state = [...newCurrent];
    } else {
      state = [...state];
    }
  }

  removeDevice(AdbDevices dev) {
    if (state.contains(dev)) {
      state = [
        for (final d in state)
          if (dev != d) d
      ];
    }
  }
}

final adbProvider =
    NotifierProvider<AdbNotifier, List<AdbDevices>>(() => AdbNotifier());

final selectedDeviceProvider = StateProvider<AdbDevices?>((ref) => null);

final savedAdbDevicesProvider = StateProvider<List<AdbDevices>>((ref) => []);

final wirelessDevicesHistoryProvider =
    StateProvider<List<AdbDevices>>((ref) => []);
