// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/toast_providers.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/command_runner.dart';
import 'package:scrcpygui/widgets/override_dialog.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_item.dart';

import '../models/scrcpy_related/scrcpy_running_instance.dart';
import '../widgets/config_override.dart';
import 'adb_utils.dart';
import 'scrcpy_command.dart';

class ScrcpyUtils {
  static Future<void> pingRunning(WidgetRef ref) async {
    final running = ref.read(scrcpyInstanceProvider);
    final actual = await getRunningScrcpy(ref.read(appPidProvider));

    for (final inst in running) {
      if (!actual.contains(inst.scrcpyPID)) {
        ref.read(scrcpyInstanceProvider.notifier).removeInstance(inst);
      }
    }
  }

  static Future<List<String>> getRunningScrcpy(String appPID) async {
    List<String> pids = [];

    if (Platform.isLinux) {
      List<String> split = (await Process.run('bash', ['-c', 'pgrep scrcpy']))
          .stdout
          .toString()
          .split('\n');
      split.removeLast();

      pids = split
          .map((e) => e.trim())
          .where((el) => el != appPID.trim() && el.trim().isNotEmpty)
          .toList();
    }

    if (Platform.isWindows) {
      final list = (await Process.run('tasklist',
              ['/fi', 'ImageName eq scrcpy.exe', '/v', '/fo', 'csv']))
          .stdout
          .toString();

      // // needed as closing scrcpy window does not remove the process from task manager, unless the main app is closed
      // final strayList = (await Process.run('tasklist', [
      //   '/fi',
      //   'ImageName eq scrcpy.exe',
      //   '/fi',
      //   'Status eq NOT RESPONDING',
      //   '/v',
      //   '/fo',
      //   'csv'
      // ]))
      //     .stdout
      //     .toString();

      // final strays = strayList.splitLines();
      // strays.removeAt(0);
      // strays
      //     .removeWhere((e) => e.isEmpty || e.contains('OleMainThreadWndName'));
      // // OleMainThreadWndName is in exception because for some reason, instances with no window show not responding as status from tasklist and ends up buing killed as strays

      // if (strays.isNotEmpty) {
      //   final strayPIDS =
      //       strays.map((e) => e.replaceAll('"', '').split(',')[1]).toList();

      //   killStrays(strayPIDS, ProcessSignal.sigterm);
      // }

      final split = list.splitLines();
      split.removeAt(0);
      split.removeWhere((e) => e.isEmpty);

      pids = split.map((e) => e.replaceAll('"', '').split(',')[1]).toList();
    }

    return pids;
  }

  static killStrays(List<String> pids, ProcessSignal signal) {
    for (var p in pids) {
      Process.killPid(p.toInt()!, signal);
    }
  }

  static Future<ScrcpyRunningInstance> _startServer(
      WidgetRef ref, AdbDevices selectedDevice, ScrcpyConfig selectedConfig,
      {bool isTest = true}) async {
    final workDir = ref.read(execDirProvider);
    final customInstanceName = ref.read(customNameProvider);
    final runningInstance = ref.read(scrcpyInstanceProvider);

    final d = ref.watch(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == selectedDevice.id,
        orElse: () => selectedDevice);

    List<String> comm = [];
    String customName =
        '[${d.name?.toUpperCase() ?? d.id}] ${customInstanceName == '' ? selectedConfig.configName : customInstanceName}';

    if (runningInstance.where((r) => r.instanceName == customName).isNotEmpty) {
      for (int i = 1; i < 100; i++) {
        bool alreadyExist = runningInstance
            .where((r) => r.instanceName == '$customName($i)')
            .isNotEmpty;

        if (!alreadyExist) {
          customName = '$customName($i)';
          break;
        }
      }
    }

    comm = ScrcpyCommand.buildCommand(ref, selectedConfig, d,
        customName: '${isTest ? '[TEST] ' : ''}$customName');

    final process = await CommandRunner.startScrcpyCommand(
        workDir, selectedDevice,
        args: comm);
    await Future.delayed(500.milliseconds);

    final now = DateTime.now();

    final instance = ScrcpyRunningInstance(
      device: d,
      config: selectedConfig,
      scrcpyPID: Platform.isMacOS
          ? (process.pid + 1).toString()
          : Platform.isMacOS && selectedConfig.windowOptions.noWindow
              ? process.pid.toString()
              : process.pid.toString(),
      process: process,
      instanceName: customName,
      startTime: now,
    );

    return instance;
  }

  static Future<void> killAllServers(WidgetRef ref) async {
    final runningInstance = ref.read(scrcpyInstanceProvider);

    for (var p in runningInstance) {
      ScrcpyUtils.killServer(p).then((a) async {
        ref.read(scrcpyInstanceProvider.notifier).removeInstance(p);
      });
    }

    if (Platform.isLinux) {
      final strays = await AdbUtils.getScrcpyServerPIDs();
      if (strays.isNotEmpty) {
        ScrcpyUtils.killStrays(strays, ProcessSignal.sigterm);
      }
    }

    ref.read(toastProvider.notifier).addToast(
          SimpleToastItem(
            message: 'All (${runningInstance.length}) servers  killed',
            toastStyle: SimpleToastStyle.success,
            key: UniqueKey(),
          ),
        );
  }

  static Future newInstance(WidgetRef ref,
      {AdbDevices? selectedDevice,
      required ScrcpyConfig selectedConfig,
      bool isTest = false}) async {
    AdbDevices device = selectedDevice ?? ref.read(selectedDeviceProvider)!;

    if (device.info == null) {
      final info =
          await AdbUtils.getScrcpyDetailsFor(ref.read(execDirProvider), device);
      device = device.copyWith(info: info);

      ref.read(savedAdbDevicesProvider.notifier).addEditDevices(device);
      ref.read(selectedDeviceProvider.notifier).state = device;
    }

    final checkResult =
        await checkForIncompatibleFlags(ref, selectedConfig, device);

    bool proceed = checkResult.isEmpty;

    if (!proceed) {
      proceed = (await showDialog(
            context: ref.context,
            builder: (context) => OverrideDialog(overrideWidget: checkResult),
          )) ??
          false;
    }

    if (proceed) {
      final inst =
          await _startServer(ref, device, selectedConfig, isTest: isTest);

      ref.read(scrcpyInstanceProvider.notifier).addInstance(inst);
    }
  }

  static Future<void> killServer(ScrcpyRunningInstance instance,
      {bool forceKill = false}) async {
    if (Platform.isLinux) {
      Process.killPid(int.parse(instance.scrcpyPID));
    }

    if (Platform.isWindows) {
      // necessary as taskkill seems to unable to kill console app
      // give out this when running only taskkill: SUCCESS: Sent termination signal to the process with PID $instance.scrcpyPID
      final res =
          await Process.run('taskkill', ['/pid', instance.scrcpyPID, '/t']);

      final pid = res.stderr
          .toString()
          .splitLines()
          .where((e) => e.toLowerCase().contains('pid'))
          .toList()[1]
          .removeLetters
          .removeSpecial
          .trimAll!
          .split(' ')
          .first;

      await Process.run('taskkill', ['/pid', pid, '/f']);
    }
  }

  static List<ScrcpyRunningInstance> getInstanceForDevice(
      WidgetRef ref, AdbDevices dev) {
    List<ScrcpyRunningInstance> res = ref
        .read(scrcpyInstanceProvider)
        .where((inst) => inst.device == dev)
        .toList();

    return res;
  }

  static Future<List<Widget>> checkForIncompatibleFlags(WidgetRef ref,
      ScrcpyConfig selectedConfig, AdbDevices selectedDevice) async {
    // List<FlagCheckResult> result = [];
    List<Widget> overrideWidget = [];

    bool display = selectedDevice.info!.displays
        .where((d) => d.id == selectedConfig.videoOptions.displayId.toString())
        .isEmpty;

    bool videoCodec = selectedDevice.info!.videoEncoders
        .where((enc) => enc.codec == selectedConfig.videoOptions.videoCodec)
        .isEmpty;

    bool videoEncoder = selectedConfig.videoOptions.videoEncoder == 'default'
        ? false
        : selectedDevice.info!.videoEncoders
            .where((ve) =>
                ve.encoder.contains(selectedConfig.videoOptions.videoEncoder))
            .isEmpty;

    bool duplicateAudio = selectedConfig.audioOptions.duplicateAudio &&
        int.parse(selectedDevice.info!.buildVersion) < 13;

    bool audioCodec = selectedDevice.info!.audioEncoder
        .where((enc) => enc.codec == selectedConfig.audioOptions.audioCodec)
        .isEmpty;

    bool audioEncoder = selectedConfig.audioOptions.audioEncoder == 'default'
        ? false
        : selectedDevice.info!.audioEncoder
            .where((ae) =>
                ae.encoder.contains(selectedConfig.audioOptions.audioEncoder))
            .isEmpty;

    if (display || videoCodec || videoEncoder) {
      overrideWidget.add(VideoOptionsOverride(
        display: display,
        codec: videoCodec,
        encoder: videoEncoder,
      ));
    }

    if (duplicateAudio || audioEncoder || audioCodec) {
      overrideWidget.add(AudioOptionsOverride(
        duplicateAudio: duplicateAudio,
        audioCodec: audioCodec,
        audioEncoder: audioEncoder,
      ));
    }

    //)

    // if (display == true) {
    //   FlagCheckResult dis = FlagCheckResult(ok: true);
    //   result.add(dis);
    // } else if (display == false) {
    //   FlagCheckResult dis = FlagCheckResult(
    //     ok: false,
    //     errorMessage:
    //         "Display with ID: '${selectedConfig.videoOptions.displayId}' is not available for this device.",
    //     overrideFlag: const DisplayIdOverride(),
    //   );

    //   result.add(dis);
    // }

    // if (videoCodec == true) {
    //   FlagCheckResult vidCodec = FlagCheckResult(ok: true);
    //   result.add(vidCodec);
    // } else if (videoCodec == false) {
    //   FlagCheckResult vidCodec = FlagCheckResult(
    //     ok: false,
    //     errorMessage:
    //         "Codec: '${selectedConfig.videoOptions.videoCodec}' is not available for this device.",
    //     overrideFlag: const VideoCodecOverride(),
    //   );

    //   result.add(vidCodec);
    // }

    // if (videoEncoder == true) {
    //   FlagCheckResult vidEncoder = FlagCheckResult(ok: true);
    //   result.add(vidEncoder);
    // } else if (videoEncoder == false) {
    //   FlagCheckResult vidEncoder = FlagCheckResult(
    //     ok: false,
    //     errorMessage:
    //         "Encoder: '${selectedConfig.videoOptions.videoEncoder}' is not available for this device.",
    //     overrideFlag: const VideoEncoderOverride(),
    //   );

    //   result.add(vidEncoder);
    // }

    // if (duplicateAudio == true) {
    //   FlagCheckResult dup = FlagCheckResult(ok: true);
    //   result.add(dup);
    // } else if (duplicateAudio == false) {
    //   FlagCheckResult dup = FlagCheckResult(
    //     ok: false,
    //     errorMessage: 'Audio duplicate only available for Android 13 and up.',
    //   );

    //   result.add(dup);
    // }

    // if (audioCodec == true) {
    //   FlagCheckResult audCodec = FlagCheckResult(ok: true);
    //   result.add(audCodec);
    // } else if (audioCodec == false) {
    //   FlagCheckResult audCodec = FlagCheckResult(
    //     ok: false,
    //     errorMessage:
    //         "Codec: '${selectedConfig.audioOptions.audioCodec}' is not available for this device.",
    //     overrideFlag: const VideoCodecOverride(),
    //   );

    //   result.add(audCodec);
    // }

    // if (audioEncoder == true) {
    //   FlagCheckResult audEncoder = FlagCheckResult(ok: true);
    //   result.add(audEncoder);
    // } else if (audioEncoder == false) {
    //   FlagCheckResult audEncoder = FlagCheckResult(
    //     ok: false,
    //     errorMessage:
    //         "Encoder: '${selectedConfig.audioOptions.audioEncoder}' is not available for this device.",
    //     overrideFlag: const VideoCodecOverride(),
    //   );

    //   result.add(audEncoder);
    // }

    if (overrideWidget.isNotEmpty) {
      ref.read(configOverrideProvider.notifier).state = selectedConfig;
    }

    return overrideWidget;
  }
}
