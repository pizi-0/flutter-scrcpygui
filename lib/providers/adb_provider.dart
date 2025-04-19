import 'package:collection/collection.dart';
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
  ProviderSubscription? _savedDevicesSubscription;

  AdbNotifier(this.ref) : super([]) {
    _listenToAdbStream();
    _listenToSavedDevices();
  }

  void _listenToAdbStream() {
    _adbStreamSubscription?.close();
    _adbStreamSubscription = ref.listen<AsyncValue<List<AdbDevices>>>(
      adbTrackDevicesStreamProvider,
      (previous, next) {
        next.when(
          data: (newAdb) {
            logger.t(
                'AdbNotifier received new device list data from stream (${newAdb.length} devices)');
            _updateDeviceListFromAdbStream(newAdb);
          },
          loading: () {
            logger.t('AdbNotifier received loading state from stream.');
          },
          error: (err, stack) {
            logger.e('AdbNotifier received error from adbDevicesStreamProvider',
                error: err, stackTrace: stack);

            if (state.isNotEmpty) {
              logger.w('Clearing device list due to stream error.');
              state = [];
              _updateSelectedDevice([]);
            }
          },
        );
      },
      fireImmediately: true,
    );
  }

  void _listenToSavedDevices() {
    _savedDevicesSubscription?.close();
    _savedDevicesSubscription = ref.listen<List<AdbDevices>>(
      savedAdbDevicesProvider,
      (previousSaved, nextSaved) {
        if (!listEquals(previousSaved, nextSaved)) {
          logger.t('AdbNotifier detected change in savedAdbDevicesProvider.');
          _updateDeviceListOnSavedDeviceChanged(nextSaved);
        }
      },
      fireImmediately: true,
    );
  }

  /// Update device list [state] with new data when savedAdbProvider changes.
  /// Maintain current device list order.
  void _updateDeviceListOnSavedDeviceChanged(List<AdbDevices> newSavedDevices) {
    final newSavedMap = {for (var d in newSavedDevices) d.id: d};
    final List<AdbDevices> updatedListInPlace = [];
    bool changed = false;

    for (final device in state) {
      final updatedData = newSavedMap[device.id];
      if (updatedData != null) {
        updatedListInPlace.add(updatedData);
        changed = true;
      } else {
        updatedListInPlace.add(device);
      }
    }

    if (changed || !listEquals(state, updatedListInPlace)) {
      logger.i(
          'Updating AdbNotifier state due to savedAdbDevicesProvider change (metadata only).');
      state = updatedListInPlace;

      _updateSelectedDevice(updatedListInPlace);
    } else {
      logger.t(
          'Saved data change did not affect any currently connected devices.');
    }
  }

  void _updateDeviceListFromAdbStream(List<AdbDevices> newAdb) {
    final saved = ref.read(savedAdbDevicesProvider);
    final currentAdb = state;
    final Map<String, AdbDevices> savedMap = {for (var d in saved) d.id: d};

    // [newMerged] = a list of device with device info or user assigned name
    final newMerged = newAdb.map((rawDevice) {
      return savedMap[rawDevice.id] ?? rawDevice;
    }).toList();

    final reorderedMerged = <AdbDevices>[];
    final newMergedMap = {for (var d in newMerged) d.id: d}; // For quick lookup

    for (final oldDevice in currentAdb) {
      if (newMergedMap.containsKey(oldDevice.id)) {
        reorderedMerged.add(newMergedMap[oldDevice.id]!);
        newMergedMap.remove(oldDevice.id); // Remove processed device
      }
      // If oldDevice is not in newMergedMap, it means it disconnected. It's implicitly removed.
    }

    // Add any newly connected devices (those remaining in newMergedMap) to the end
    reorderedMerged.addAll(newMergedMap.values);

    if (!listEquals(currentAdb, reorderedMerged)) {
      logger.i(
          'Updating AdbNotifier state due to adbTrackDevicesStreamProvider change (connections).');
      state = reorderedMerged;
      _updateSelectedDevice(reorderedMerged);
    } else {
      logger.t('Device list from stream resulted in no state change.');
    }
  }

  // --- Update Selected Device Logic ---
  void _updateSelectedDevice(List<AdbDevices> currentDeviceList) {
    final selected = ref.read(selectedDeviceProvider);
    final selectedNotifier = ref.read(selectedDeviceProvider.notifier);
    if (selected != null) {
      final currentSelectedDeviceData =
          currentDeviceList.firstWhereOrNull((d) => d.id == selected.id);

      if (currentSelectedDeviceData != null) {
        if (selected != currentSelectedDeviceData) {
          logger.d(
              'Updating selected device object instance/data for ${selected.id}');
          selectedNotifier.state = currentSelectedDeviceData;
        }
      } else {
        logger.i(
            'Selected device ${selected.id} disconnected or removed. Deselecting.');
        selectedNotifier.state = null;
      }
    } else {}

    if (currentDeviceList.isEmpty && selectedNotifier.state != null) {
      logger.i('Device list is empty. Deselecting.');
      selectedNotifier.state = null;
    }
  }

  @override
  void dispose() {
    logger.t('Disposing AdbNotifier: cancelling subscriptions.');
    _adbStreamSubscription?.close();
    _savedDevicesSubscription?.close();
    super.dispose();
  }
}

final adbProvider = StateNotifierProvider<AdbNotifier, List<AdbDevices>>((ref) {
  return AdbNotifier(ref);
});
