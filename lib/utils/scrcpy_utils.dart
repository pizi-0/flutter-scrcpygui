// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/position_and_size.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:screen_retriever/screen_retriever.dart';
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

Set<ScrcpyConfig> ignoreAutoArrangeConfigs = {};

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
      List<String> split = (await Process.run('bash', ['-c', 'pgrep scrcpy'])).stdout.toString().split('\n');
      split.removeLast();

      pids = split.map((e) => e.trim()).where((el) => el != appPID.trim() && el.trim().isNotEmpty).toList();
    }

    if (Platform.isWindows) {
      final list =
          (await Process.run('tasklist', ['/fi', 'ImageName eq scrcpy.exe', '/v', '/fo', 'csv'])).stdout.toString();

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

  static Future<ScrcpyRunningInstance> _startServer(WidgetRef ref, AdbDevices selectedDevice, ScrcpyConfig config,
      {bool isTest = true, String customInstanceName = '', Map<String, String>? env}) async {
    ScrcpyConfig selectedConfig = config;
    final workDir = ref.read(execDirProvider);
    final runningInstance = ref.read(scrcpyInstanceProvider);
    final shouldArrange = ref.read(settingsProvider).behaviour.autoArrangeScrcpyWindow;

    final deviceInfo = ref.read(infoProvider).firstWhereOrNull((info) => info.serialNo == selectedDevice.serialNo);

    final isWireless = selectedDevice.id.contains(adbMdns) || selectedDevice.id.isIpv4 || selectedDevice.id.isIpv6;

    List<String> comm = [];
    String customName =
        '[${isWireless ? 'WiFi' : 'USB'}] [${deviceInfo?.deviceName.toUpperCase() ?? selectedDevice.modelName}] ${customInstanceName == '' ? selectedConfig.configName : customInstanceName}';

    if (runningInstance.where((r) => r.instanceName == customName).isNotEmpty) {
      for (int i = 1; i < 100; i++) {
        bool alreadyExist = runningInstance.where((r) => r.instanceName == '$customName($i)').isNotEmpty;

        if (!alreadyExist) {
          customName = '$customName($i)';
          break;
        }
      }
    }

    if (shouldArrange && !isTest) {
      selectedConfig = await ScrcpyUtils.handleHorizontalPosition(ref, config: config, device: selectedDevice);
    }

    comm = ScrcpyCommand.buildCommand(ref, selectedConfig, selectedDevice,
        customName: '${isTest ? '[TEST] ' : ''}$customName');

    final process = await CommandRunner.startScrcpyCommand(workDir, selectedDevice, args: comm, env: env);
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
      String customInstanceName = '',
      Map<String, String>? env}) async {
    AdbDevices device = selectedDevice ?? ref.read(selectedDeviceProvider)!;

    final deviceInfo = ref.read(infoProvider).firstWhereOrNull((info) => info.serialNo == device.serialNo);

    if (deviceInfo == null) {
      final info = await AdbUtils.getDeviceInfoFor(ref.read(execDirProvider), device);

      ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);
      await Db.saveDeviceInfos(ref.read(infoProvider));
    }

    final inst = await _startServer(ref, device, selectedConfig,
        isTest: isTest, customInstanceName: customInstanceName, env: env);

    ref.read(scrcpyInstanceProvider.notifier).addInstance(inst);
  }

  static Future<void> killServer(ScrcpyRunningInstance instance, {bool forceKill = false}) async {
    if (Platform.isLinux || Platform.isMacOS) {
      Process.killPid(int.parse(instance.scrcpyPID));
    }

    if (Platform.isWindows) {
      // necessary as taskkill seems to unable to kill console app
      // give out this when running only taskkill: SUCCESS: Sent termination signal to the process with PID $instance.scrcpyPID

      final res = await Process.run('taskkill', ['/pid', instance.scrcpyPID, '/t']);

      final regex = RegExp(r"\d+");
      final pids = regex.allMatches(res.stderr.toString()).map((match) => int.parse(match.group(0)!)).toSet();

      pids
        ..remove(pid) // scrcpygui pid
        ..remove(int.parse(instance.scrcpyPID));

      for (final p in pids) {
        Process.killPid(p);
      }
    }
  }

  static List<ScrcpyRunningInstance> getInstanceForDevice(WidgetRef ref, AdbDevices dev) {
    List<ScrcpyRunningInstance> res = ref.read(scrcpyInstanceProvider).where((inst) => inst.device == dev).toList();

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

  static ScrcpyConfig handleOverrides(WidgetRef ref, List<ScrcpyOverride> overrides, ScrcpyConfig config) {
    var resultingConfig = config;
    final device = ref.read(selectedDeviceProvider);

    if (device == null) {
      logger.e('No device selected');
      return resultingConfig;
    }

    if (overrides.contains(ScrcpyOverride.record)) {
      resultingConfig = resultingConfig.copyWith(isRecording: true);
    }

    if (overrides.contains(ScrcpyOverride.landscape)) {
      if (config.videoOptions.displayId == 'new') {
        final currentVdOption = resultingConfig.videoOptions.virtualDisplayOptions;
        String reso = currentVdOption.resolution;

        if (reso == DEFAULT) {
          final info = ref.read(infoProvider).firstWhereOrNull((i) => i.serialNo == device.serialNo);

          if (info == null) {
            logger.e('No display info for device (${device.id})');
            return resultingConfig;
          }

          reso = info.displays.first.resolution;
        }

        if (!reso.isLandscape) {
          reso = reso.rotate ?? reso;
        }

        final currentVideoOptions = resultingConfig.videoOptions;

        resultingConfig = resultingConfig.copyWith(
          videoOptions: currentVideoOptions.copyWith(virtualDisplayOptions: currentVdOption.copyWith(resolution: reso)),
        );
      }
      // else {
      //   final currentFlags = resultingConfig.additionalFlags;

      //   resultingConfig = resultingConfig.copyWith(
      //     additionalFlags: currentFlags.append('--capture-orientation=90'),
      //   );
      // }
    }

    if (overrides.contains(ScrcpyOverride.mute)) {
      resultingConfig = resultingConfig.copyWith(scrcpyMode: ScrcpyMode.videoOnly);
    }

    return resultingConfig;
  }

  static Future<ScrcpyConfig> handleHorizontalPosition(
    WidgetRef ref, {
    required ScrcpyConfig config,
    required AdbDevices device,
    bool startFromRight = false,
  }) async {
    ScrcpyConfig res = config;
    final display = (await screenRetriever.getPrimaryDisplay());
    final screenSize = display.size;

    final instances = ref.read(scrcpyInstanceProvider);
    final info = ref.read(infoProvider).firstWhere((i) => i.serialNo == device.serialNo);

    final defaultDeviceResolution = getDisplays(
                (await CommandRunner.runScrcpyCommand(ref.read(execDirProvider), device, args: ['--list-displays']))
                    .stdout)
            .firstWhereOrNull((d) => d.id == config.videoOptions.displayId)
            ?.resolution ??
        info.displays.first.resolution;

    final workingResolution = config.videoOptions.displayId == 'new'
        ? config.videoOptions.virtualDisplayOptions.resolution == DEFAULT
            ? defaultDeviceResolution
            : config.videoOptions.virtualDisplayOptions.resolution
        : defaultDeviceResolution;

    final scale = workingResolution.resolutionHeight! / (screenSize.height * 0.88);

    final newWindowWidth = (workingResolution.resolutionWidth! / scale).ceil();
    final newWindowHeight = (workingResolution.resolutionHeight! / scale).ceil();

    const int gap = 2; // Gap between windows

    if (workingResolution.isLandscape ||
        config.windowOptions.noWindow ||
        config.additionalFlags.containsAny(['orientation=90', 'orientation=270']) ||
        config.windowOptions.size?.height != null ||
        config.windowOptions.size?.width != null ||
        config.windowOptions.position?.x != null ||
        config.windowOptions.position?.y != null ||
        config.additionalFlags.containsAny(['window-x', 'window-y', 'window-width', 'window-height'])) {
      ignoreAutoArrangeConfigs.add(config);

      return res;
    }

    // Gather all running instances with defined position and size.
    final positionedInstances = instances
        .where((i) =>
            i.config.windowOptions.position?.x != null &&
            i.config.windowOptions.position?.y != null &&
            i.config.windowOptions.size?.width != null &&
            i.config.windowOptions.size?.height != null &&
            !ignoreAutoArrangeConfigs.contains(i.config))
        .map((inst) => (
              x: inst.config.windowOptions.position!.x!,
              y: inst.config.windowOptions.position!.y!,
              width: inst.config.windowOptions.size!.width!,
              height: inst.config.windowOptions.size!.height!,
            ))
        .toList();

    for (int row = 0;; row++) {
      final y = row * (newWindowHeight + gap);
      if (y + newWindowHeight > screenSize.height) break; // No more vertical space

      final rowInstances = positionedInstances.where((w) => (w.y - y).abs() < gap).toList();

      // Sort by x (left-to-right) or by x descending (right-to-left)
      rowInstances.sort((a, b) => startFromRight ? b.x.compareTo(a.x) : a.x.compareTo(b.x));

      if (!startFromRight) {
        int x = 0;
        for (final win in rowInstances) {
          if (x + newWindowWidth <= win.x - gap) {
            return res.copyWith(
              windowOptions: res.windowOptions.copyWith(
                position: ScrcpyPosition(x: x, y: y),
                size: ScrcpySize(width: newWindowWidth, height: newWindowHeight),
              ),
            );
          }
          x = win.x + win.width + gap;
        }
        if (x + newWindowWidth <= screenSize.width) {
          return res.copyWith(
            windowOptions: res.windowOptions.copyWith(
              position: ScrcpyPosition(x: x, y: y),
              size: ScrcpySize(width: newWindowWidth, height: newWindowHeight),
            ),
          );
        }
      } else {
        int x = (screenSize.width - newWindowWidth).ceil();
        for (final win in rowInstances) {
          if (x >= win.x + win.width + gap) {
            return res.copyWith(
              windowOptions: res.windowOptions.copyWith(
                position: ScrcpyPosition(x: x, y: y),
                size: ScrcpySize(width: newWindowWidth, height: newWindowHeight),
              ),
            );
          }
          x = win.x - newWindowWidth - gap;
        }
        if (x >= 0) {
          return res.copyWith(
            windowOptions: res.windowOptions.copyWith(
              position: ScrcpyPosition(x: x, y: y),
              size: ScrcpySize(width: newWindowWidth, height: newWindowHeight),
            ),
          );
        }
      }
      // Otherwise, try next row
    }

    // If no suitable position was found, return the original config.
    return res;
  }
}
