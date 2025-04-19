import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';

import '../utils/const.dart';
import 'poll_provider.dart';

final selectedDeviceProvider = StateProvider<AdbDevices?>((ref) => null);

class SavedAdbNotifier extends Notifier<List<AdbDevices>> {
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

final savedAdbDevicesProvider =
    NotifierProvider<SavedAdbNotifier, List<AdbDevices>>(
        () => SavedAdbNotifier());

final ipHistoryProvider = StateProvider<List<String>>((ref) => []);

class AdbNotifier extends StateNotifier<List<AdbDevices>> {
  final Ref ref;
  ProviderSubscription? _adbStreamSubscription;

  AdbNotifier(this.ref) : super([]) {
    _listenToAdbStream();
  }

  void _listenToAdbStream() {
    // Cancel previous subscription if exists
    _adbStreamSubscription?.close();

    // Listen to the stream provider's result
    _adbStreamSubscription = ref.listen<AsyncValue<List<AdbDevices>>>(
      adbTrackDevicesStreamProvider,
      (previous, next) {
        next.when(
          data: (newAdb) {
            if (!listEquals(state, newAdb)) {
              logger.t(
                  'AdbNotifier received new device list data (${newAdb.length} devices)');
              _updateDeviceList(newAdb);
            }
          },
          loading: () {
            logger.t('AdbNotifier received loading state from stream.');
          },
          error: (err, stack) {
            logger.e('AdbNotifier received error from adbDevicesStreamProvider',
                error: err, stackTrace: stack);
          },
        );
      },
      fireImmediately: true,
    );
  }

  void _updateDeviceList(List<AdbDevices> newAdb) {
    final saved = ref.watch(savedAdbDevicesProvider);
    final currentAdb = state;

    // Merge new devices with saved data
    final Map<String, AdbDevices> savedMap = {for (var d in saved) d.id: d};
    final newMerged = newAdb.map((d) => savedMap[d.id] ?? d).toList();

    // Reorder the list to maintain the original order of devices
    final reorderedMerged = <AdbDevices>[];
    for (final device in currentAdb) {
      final foundDevice = newMerged.where((d) => d.id == device.id).firstOrNull;
      if (foundDevice != null) {
        reorderedMerged.add(foundDevice);
      }
    }
    // Add any new devices to the end of the list
    for (final device in newMerged) {
      if (!reorderedMerged.any((d) => d.id == device.id)) {
        reorderedMerged.add(device);
      }
    }

    state = reorderedMerged;

    // Handle selected device logic, using the reordered list
    _updateSelectedDevice(reorderedMerged);
  }

  void _updateSelectedDevice(List<AdbDevices> currentDeviceList) {
    final selected = ref.read(selectedDeviceProvider);
    final selectedNotifier = ref.read(selectedDeviceProvider.notifier);

    if (selected != null) {
      // Check if the currently selected device is still in the list
      final isSelectedDevicePresent =
          currentDeviceList.any((d) => d.id == selected.id);
      if (!isSelectedDevicePresent) {
        logger.i('Selected device ${selected.id} disconnected. Deselecting.');
        selectedNotifier.state = null;
      }
    }

    // Ensure selection is cleared if the list becomes empty
    if (currentDeviceList.isEmpty && selected != null) {
      logger.i('Device list is empty. Deselecting.');
      selectedNotifier.state = null;
    }
  }

  @override
  void dispose() {
    logger.t('Disposing AdbNotifier: cancelling stream subscription.');
    _adbStreamSubscription?.close();
    super.dispose();
  }
}

final adbProvider = StateNotifierProvider<AdbNotifier, List<AdbDevices>>((ref) {
  return AdbNotifier(ref);
});
