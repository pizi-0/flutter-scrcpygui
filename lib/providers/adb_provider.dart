import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';

class AdbNotifier extends Notifier<List<AdbDevices>> {
  @override
  build() {
    return [];
  }

  setConnected(List<AdbDevices> connected) {
    List<AdbDevices> currentAdb = state;

    if (currentAdb.length > connected.length) {
      final diff = currentAdb.toSet().difference(connected.toSet()).toList();

      List<AdbDevices> newCurrent =
          currentAdb.where((d) => !diff.contains(d)).toList();

      state = [...newCurrent];

      //device connected
    } else if (connected.length > currentAdb.length) {
      final diff = connected.toSet().difference(currentAdb.toSet()).toList();

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

class SavedAdb extends Notifier<List<AdbDevices>> {
  @override
  build() {
    return [];
  }

  setDevices(List<AdbDevices> devices) {
    state = devices;
  }

  addEditDevices(AdbDevices device) {
    final list = [...state.where((d) => d.id != device.id)];

    state = [...list, device];
  }

  removeDevice(AdbDevices device) {
    state = [...state.where((d) => d.id != device.id)];
  }
}

final adbProvider =
    NotifierProvider<AdbNotifier, List<AdbDevices>>(() => AdbNotifier());

final selectedDeviceProvider = StateProvider<AdbDevices?>((ref) => null);

final savedAdbDevicesProvider =
    NotifierProvider<SavedAdb, List<AdbDevices>>(() => SavedAdb());

final wirelessDevicesHistoryProvider =
    StateProvider<List<AdbDevices>>((ref) => []);

final autoConnectDevicesProvider = StateProvider<List<AdbDevices>>((ref) => []);
