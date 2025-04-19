import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/command_runner.dart';
import 'package:scrcpygui/utils/const.dart';

final adbTrackDevicesStreamProvider = StreamProvider<List<AdbDevices>>((ref) {
  final workDir = ref.watch(execDirProvider);
  final controller = StreamController<List<AdbDevices>>();
  Process? adbProcess;
  StreamSubscription? stdoutSub;
  StreamSubscription? stderrSub;

  // Helper to fetch full list
  Future<void> fetchAndUpdateDevices(Ref ref,
      StreamController<List<AdbDevices>> controller, String workDir) async {
    try {
      logger.t('Change detected by track-devices, fetching full list...');
      final devices = await AdbUtils.connectedDevices(workDir, showLog: false);
      if (!controller.isClosed) {
        controller.add(devices);
        logger.t(
            'Updated device list via track-devices trigger (${devices.length} found).');
      }
    } catch (e, s) {
      logger.e('Failed to fetch device list after track-devices trigger:',
          error: e, stackTrace: s);
      if (!controller.isClosed) controller.addError(e, s);
    }
  }

  Future<void> startTracking() async {
    logger.t('Attempting to start adb track-devices...');
    try {
      adbProcess?.kill();
      stdoutSub?.cancel();
      stderrSub?.cancel();

      // Get initial list
      try {
        final initialDevices =
            await AdbUtils.connectedDevices(workDir, showLog: false);

        if (!controller.isClosed) controller.add(initialDevices);
        logger.t('Got initial devices: ${initialDevices.length}');
      } catch (e) {
        logger.w('Failed to get initial device list before tracking: $e');
      }

      // Start track
      adbProcess =
          await CommandRunner.startAdbCommand(workDir, args: ['track-devices']);

      logger.i('adb track-devices process started (PID: ${adbProcess?.pid})');

      // Handle process exit
      adbProcess?.exitCode.then((code) {
        logger.w('adb track-devices process exited with code $code.');
        if (!controller.isClosed) {
          controller
              .addError('ADB track-devices process stopped unexpectedly.');

          Future.delayed(Duration(seconds: 5), () {
            if (!controller.isClosed) startTracking();
          });
        }
      });

      stdoutSub = adbProcess?.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          logger.t('adb track-devices stdout: $line');
          // The first output is the full list, subsequent lines are changes.
          // However, parsing can be tricky. A simpler way is to just re-fetch
          // the full list whenever *any* output is received from track-devices.
          // This is less efficient than parsing the diff, but much simpler
          // and still vastly more efficient than polling `adb devices`.

          fetchAndUpdateDevices(ref, controller, workDir);
        },
        onError: (error) {
          logger.e('adb track-devices stdout error:', error: error);
          if (!controller.isClosed) controller.addError(error);
        },
        onDone: () {
          logger.i('adb track-devices stdout stream closed.');
        },
      );

      stderrSub = adbProcess?.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          logger.w('adb track-devices stderr: $line');
        },
        onError: (error) {
          logger.e('adb track-devices stderr error:', error: error);
          if (!controller.isClosed) controller.addError(error);
        },
      );
    } catch (e, s) {
      logger.e('Failed to start adb track-devices:', error: e, stackTrace: s);
      if (!controller.isClosed) {
        controller.addError(e, s);
        // Retry after delay?
        Future.delayed(Duration(seconds: 5), () {
          if (!controller.isClosed) startTracking();
        });
      }
    }
  }

  startTracking();

  ref.onDispose(() {
    logger.i(
        'Disposing adbTrackDevicesStreamProvider: Killing process and cancelling subscriptions.');
    stdoutSub?.cancel();
    stderrSub?.cancel();

    adbProcess?.kill();
    controller.close();
  });

  return controller.stream;
});
