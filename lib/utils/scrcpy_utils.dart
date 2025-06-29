// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/command_runner.dart';

import '../db/db.dart';
import '../models/scrcpy_related/scrcpy_enum.dart';
import '../models/scrcpy_related/scrcpy_running_instance.dart';
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

    if (Platform.isLinux || Platform.isMacOS) {
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

      final split = list.splitLines();
      split.removeAt(0);
      split.removeWhere((e) => e.isEmpty);

      pids = split.map((e) => e.replaceAll('"', '').split(',')[1]).toList();
    }

    return pids;
  }

  static void killStrays(List<String> pids, ProcessSignal signal) {
    for (var p in pids) {
      Process.killPid(p.toInt()!, signal);
    }
  }

  static Future<ScrcpyRunningInstance> _startServer(
      WidgetRef ref, AdbDevices selectedDevice, ScrcpyConfig selectedConfig,
      {bool isTest = true, String customInstanceName = ''}) async {
    final workDir = ref.read(execDirProvider);
    final runningInstance = ref.read(scrcpyInstanceProvider);

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == selectedDevice.serialNo);

    final isWireless = selectedDevice.id.contains(adbMdns) ||
        selectedDevice.id.isIpv4 ||
        selectedDevice.id.isIpv6;

    List<String> comm = [];
    String customName =
        '[${isWireless ? 'WiFi' : 'USB'}] [${deviceInfo?.deviceName.toUpperCase() ?? selectedDevice.modelName}] ${customInstanceName == '' ? selectedConfig.configName : customInstanceName}';

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

    comm = ScrcpyCommand.buildCommand(ref, selectedConfig, selectedDevice,
        customName: '${isTest ? '[TEST] ' : ''}$customName');

    final process = await CommandRunner.startScrcpyCommand(
        workDir, selectedDevice,
        args: comm);
    await Future.delayed(500.milliseconds);

    final now = DateTime.now();

    logger.i('Scrcpy started: ${process.pid}');

    final instance = ScrcpyRunningInstance(
      device: selectedDevice,
      config: selectedConfig,
      scrcpyPID: process.pid.toString(),
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

    if (Platform.isLinux || Platform.isMacOS) {
      final strays = await AdbUtils.getScrcpyServerPIDs();
      if (strays.isNotEmpty) {
        ScrcpyUtils.killStrays(strays, ProcessSignal.sigterm);
      }
    }
  }

  static Future newInstance(WidgetRef ref,
      {AdbDevices? selectedDevice,
      required ScrcpyConfig selectedConfig,
      bool isTest = false,
      String customInstanceName = ''}) async {
    AdbDevices device = selectedDevice ?? ref.read(selectedDeviceProvider)!;

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == device.serialNo);

    if (deviceInfo == null) {
      final info =
          await AdbUtils.getDeviceInfoFor(ref.read(execDirProvider), device);

      ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);
      await Db.saveDeviceInfos(ref.read(infoProvider));
    }

    final inst = await _startServer(ref, device, selectedConfig,
        isTest: isTest, customInstanceName: customInstanceName);

    ref.read(scrcpyInstanceProvider.notifier).addInstance(inst);
  }

  static Future<void> killServer(ScrcpyRunningInstance instance,
      {bool forceKill = false}) async {
    if (Platform.isLinux || Platform.isMacOS) {
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

  // static Future<List<Widget>> checkForIncompatibleFlags(WidgetRef ref,
  //     ScrcpyConfig selectedConfig, AdbDevices selectedDevice) async {
  //   // List<FlagCheckResult> result = [];
  //   List<Widget> overrideWidget = [];

  //   bool display = selectedDevice.info!.displays
  //           .where(
  //               (d) => d.id == selectedConfig.videoOptions.displayId.toString())
  //           .isEmpty &&
  //       selectedConfig.videoOptions.displayId != 'new';

  //   bool videoCodec = selectedDevice.info!.videoEncoders
  //       .where((enc) => enc.codec == selectedConfig.videoOptions.videoCodec)
  //       .isEmpty;

  //   bool videoEncoder = selectedConfig.videoOptions.videoEncoder == 'default'
  //       ? false
  //       : selectedDevice.info!.videoEncoders
  //           .where((ve) =>
  //               ve.encoder.contains(selectedConfig.videoOptions.videoEncoder))
  //           .isEmpty;

  //   bool duplicateAudio = selectedConfig.audioOptions.duplicateAudio &&
  //       int.parse(selectedDevice.info!.buildVersion) < 13;

  //   bool audioCodec = selectedDevice.info!.audioEncoder
  //       .where((enc) => enc.codec == selectedConfig.audioOptions.audioCodec)
  //       .isEmpty;

  //   bool audioEncoder = selectedConfig.audioOptions.audioEncoder == 'default'
  //       ? false
  //       : selectedDevice.info!.audioEncoder
  //           .where((ae) =>
  //               ae.encoder.contains(selectedConfig.audioOptions.audioEncoder))
  //           .isEmpty;

  //   if (display || videoCodec || videoEncoder) {
  //     overrideWidget.add(VideoOptionsOverride(
  //       display: display,
  //       codec: videoCodec,
  //       encoder: videoEncoder,
  //     ));
  //   }

  //   if (!duplicateAudio || !audioEncoder || !audioCodec) {
  //     overrideWidget.add(AudioOptionsOverride(
  //       duplicateAudio: !duplicateAudio,
  //       audioCodec: !audioCodec,
  //       audioEncoder: !audioEncoder,
  //     ));
  //   }

  //   if (overrideWidget.isNotEmpty) {
  //     ref.read(configOverrideProvider.notifier).state = selectedConfig;
  //   }

  //   return overrideWidget;
  // }

  static ScrcpyConfig handleOverrides(
      List<ScrcpyOverride> overrides, ScrcpyConfig config) {
    var resultingConfig = config;

    if (overrides.contains(ScrcpyOverride.record)) {
      resultingConfig = resultingConfig.copyWith(isRecording: true);
    }

    if (overrides.contains(ScrcpyOverride.landscape)) {
      final currentUserFlags = resultingConfig.additionalFlags;

      resultingConfig = resultingConfig.copyWith(
        additionalFlags: currentUserFlags.append('--orientation=270'),
      );
    }

    if (overrides.contains(ScrcpyOverride.mute)) {
      resultingConfig =
          resultingConfig.copyWith(scrcpyMode: ScrcpyMode.videoOnly);
    }

    return resultingConfig;
  }
}
