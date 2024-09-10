import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/adb_devices.dart';

class AdbNotifier extends Notifier<List<AdbDevices>> {
  @override
  build() {
    return [];
  }

  setConnected(List<AdbDevices> devs) {
    List<AdbDevices> currentAdb = state;

    if (currentAdb.length > devs.length) {
      final diff = currentAdb.toSet().difference(devs.toSet()).toList();

      List<AdbDevices> newCurrent =
          currentAdb.where((d) => !diff.contains(d)).toList();

      state = [...newCurrent];

      //device connected
    } else if (devs.length > currentAdb.length) {
      final diff = devs.toSet().difference(currentAdb.toSet()).toList();

      final newCurrent = [...currentAdb, ...diff];

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
