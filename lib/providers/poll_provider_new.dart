import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart'; // Assuming AdbDevices is here
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:string_extensions/string_extensions.dart';

import '../utils/adb_utils.dart';
import 'adb_provider.dart'; // Keep for adbProvider, selectedDeviceProvider etc.

// --- Configuration ---

/// Controls whether ADB polling is active.
final shouldPollAdbProvider =
    StateProvider<bool>((ref) => true, name: 'shouldPollAdbProvider');

/// Defines the interval for polling ADB devices.
final adbPollingIntervalProvider = StateProvider<Duration>(
  (ref) => 1.seconds, // Default to 1 second
  name: 'adbPollingIntervalProvider',
);

// --- Optimized Polling Stream ---

/// A stream provider that periodically fetches connected ADB devices.
/// It emits the list of connected devices or throws an error if fetching fails.
final adbDevicesStreamProvider = StreamProvider<List<AdbDevices>>((ref) {
  // Use read here as we react to changes via ref.listen below
  final workDir = ref.read(execDirProvider);
  final initialShouldPoll = ref.read(shouldPollAdbProvider);
  final initialInterval = ref.read(adbPollingIntervalProvider);

  final controller = StreamController<List<AdbDevices>>();
  Timer? timer;

  // Function to perform the actual polling
  void pollDevices() async {
    // Ensure polling is still desired before executing expensive work
    // Use read inside the timer callback as watch isn't suitable here.
    // The listen below handles restarting/stopping the timer itself.
    if (!ref.read(shouldPollAdbProvider) || controller.isClosed) {
      logger.t('Polling skipped (disabled or controller closed).');
      return;
    }

    try {
      logger.t('Polling for ADB devices...');
      // Fetch devices (keep showLog: false for less noise during polling)
      final newAdb = await AdbUtils.connectedDevices(workDir, showLog: false);
      // Add the fresh list to the stream if the controller is still open
      if (!controller.isClosed) {
        controller.add(newAdb);
        logger.t('ADB devices polled successfully (${newAdb.length} found).');
      } else {
        logger.t('Controller closed before adding polled devices.');
      }
    } catch (e, stackTrace) {
      logger.e('ADB polling failed', error: e, stackTrace: stackTrace);
      // Add error to the stream if the controller is still open
      // Consumers can decide how to handle this (e.g., show error, retry logic)
      if (!controller.isClosed) {
        controller.addError(e, stackTrace);
        // Optional: Implement backoff logic here instead of fixed interval on error?
        // Optional: Stop polling on specific errors?
        // ref.read(shouldPollAdbProvider.notifier).state = false; // Avoid stopping globally by default
      } else {
        logger.t('Controller closed before adding polling error.');
      }
    }
  }

  // Function to manage the timer lifecycle
  void manageTimer({required bool shouldPoll, required Duration interval}) {
    timer?.cancel(); // Cancel any existing timer
    timer = null;

    if (shouldPoll && !controller.isClosed) {
      logger.t('Starting ADB polling timer with interval: $interval');
      // Run once immediately to get initial state, then periodically
      pollDevices();
      timer = Timer.periodic(interval, (_) => pollDevices());
    } else {
      logger.t(
          'Polling is disabled or controller is closed. Timer stopped/not started.');
    }
  }

  // Initial timer setup
  manageTimer(shouldPoll: initialShouldPoll, interval: initialInterval);

  // Use ref.listen to react to changes in shouldPoll without rebuilding the provider
  ref.listen<bool>(shouldPollAdbProvider, (previous, next) {
    if (previous != next) {
      logger.t(
          'shouldPollAdbProvider changed from $previous to $next. Updating timer.');
      // Read the current interval when updating the timer
      manageTimer(
          shouldPoll: next, interval: ref.read(adbPollingIntervalProvider));
    }
  });

  // Use ref.listen to react to interval changes
  ref.listen<Duration>(adbPollingIntervalProvider, (previous, next) {
    if (previous != next) {
      logger.t(
          'adbPollingIntervalProvider changed from $previous to $next. Updating timer.');
      // Read the current polling status when updating the timer
      manageTimer(shouldPoll: ref.read(shouldPollAdbProvider), interval: next);
    }
  });

  // Cleanup when the provider is disposed
  ref.onDispose(() {
    logger.t(
        'Disposing adbDevicesStreamProvider: cancelling timer and closing controller.');
    timer?.cancel();
    controller.close();
  });

  // Return the stream from the controller
  return controller.stream;
}, name: 'adbDevicesStreamProvider');


// --- Example: How AdbNotifier would consume the stream ---
// (Place this logic inside your actual AdbNotifier class)

/*
// In your AdbNotifier class (adjust class name and state type if needed)
class AdbNotifier extends StateNotifier<List<AdbDevices>> {
  final Ref ref;
  StreamSubscription? _adbStreamSubscription; // Keep track of the subscription

  AdbNotifier(this.ref) : super([]) {
    _listenToAdbStream();
  }

  void _listenToAdbStream() {
    // Cancel previous subscription if exists
    _adbStreamSubscription?.cancel();

    // Listen to the stream provider's result
    _adbStreamSubscription = ref.listen<AsyncValue<List<AdbDevices>>>(
      adbDevicesStreamProvider,
      (previous, next) {
        next.when(
          data: (newAdb) {
            logger.t('AdbNotifier received new device list data (${newAdb.length} devices)');
            _updateDeviceList(newAdb);
          },
          loading: () {
            // Optional: handle loading state, maybe only on initial load?
            logger.t('AdbNotifier received loading state from stream.');
          },
          error: (err, stack) {
            // Optional: handle error state, maybe clear the list or show an error indicator
            logger.e('AdbNotifier received error from adbDevicesStreamProvider', error: err, stackTrace: stack);
            // Decide if you want to clear the list on error
            // state = []; // Example: Clear list on error
          },
        );
      },
      fireImmediately: true, // Process the current value immediately if available
    );
  }

  void _updateDeviceList(List<AdbDevices> newAdb) {
    final saved = ref.read(savedAdbDevicesProvider);
    final currentAdb = state; // Current state managed by this notifier

    // Merge new devices with saved data (ensure unique IDs)
    final Map<String, AdbDevices> savedMap = { for (var d in saved) d.id : d };
    final newMerged = newAdb.map((d) => savedMap[d.id] ?? d).toList();

    // Log connection changes (can be kept here or moved)
    _logConnectionChanges(currentAdb, newMerged);

    // Update the state only if it has actually changed to avoid unnecessary rebuilds
    // Note: List comparison requires careful implementation or use of immutable collections
    // For simplicity, we update; consider packages like `collection`'s `DeepCollectionEquality` if needed.
    state = newMerged;

    // Handle selected device logic
    _updateSelectedDevice(newMerged);
  }

  void _logConnectionChanges(List<AdbDevices> currentAdb, List<AdbDevices> newAdb) {
      final currentIds = currentAdb.map((d) => d.id).toSet();
      final newIds = newAdb.map((d) => d.id).toSet();

      final disconnected = currentAdb
          .where((d) => !newIds.contains(d.id))
          .map((e) => '${e.id.isIpv4 || e.id.contains(adbMdns) ? '(WIFI)' : '(USB)'}-${e.name ?? e.id}')
          .toList();

      if (disconnected.isNotEmpty) {
          logger.i('Device disconnected $disconnected');
      }

      final connected = newAdb
          .where((d) => !currentIds.contains(d.id))
          .map((e) => '${e.id.isIpv4 || e.id.contains(adbMdns) ? '(WIFI)' : '(USB)'}-${e.name ?? e.id}')
          .toList();

      if (connected.isNotEmpty) {
           logger.i('Device connected $connected');
      }
  }

  void _updateSelectedDevice(List<AdbDevices> currentDeviceList) {
      final selected = ref.read(selectedDeviceProvider);
      final selectedNotifier = ref.read(selectedDeviceProvider.notifier);

      if (selected != null) {
          // Check if the currently selected device is still in the list
          final isSelectedDevicePresent = currentDeviceList.any((d) => d.id == selected.id);
          if (!isSelectedDevicePresent) {
              logger.i('Selected device ${selected.id} disconnected. Deselecting.');
              selectedNotifier.state = null;
          }
      }

      // Optional: Auto-select logic if needed (e.g., select first if list was empty and now isn't)
      // if (selected == null && currentDeviceList.isNotEmpty && state.isEmpty) {
      //    logger.i('Auto-selecting first device: ${currentDeviceList.first.id}');
      //    selectedNotifier.state = currentDeviceList.first;
      // }

      // Ensure selection is cleared if the list becomes empty
      if (currentDeviceList.isEmpty && selected != null) {
           logger.i('Device list is empty. Deselecting.');
           selectedNotifier.state = null;
      }
  }


  // Make sure to dispose of the subscription when the Notifier is disposed
  @override
  void dispose() {
    logger.t('Disposing AdbNotifier: cancelling stream subscription.');
    _adbStreamSubscription?.cancel();
    super.dispose();
  }

  // Other methods of AdbNotifier (like manual add/remove if needed) go here...
  // Note: The primary update mechanism is now the stream listener.
}

// Ensure adbProvider uses this notifier:
// final adbProvider = StateNotifierProvider<AdbNotifier, List<AdbDevices>>((ref) {
//   return AdbNotifier(ref);
// });

*/

