// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/toast_providers.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scrcpy_related/scrcpy_flag_check_result.dart';
import '../models/scrcpy_related/scrcpy_running_instance.dart';
import '../widgets/config_override/config_override.dart';
import 'adb_utils.dart';
import 'scrcpy_command.dart';
import 'tray_utils.dart';

class ScrcpyUtils {
  static Future<bool> scrcpyInstalled() async {
    final res = await Process.run('bash', [
      '-c',
      ' ${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}which scrcpy'
    ]);

    return res.stdout.toString().isNotEmpty;
  }

  static openFolder(String p) async {
    Uri folder = Uri.file(p);
    await launchUrl(folder);
  }

  static Future<List<ScrcpyConfig>> getSavedConfig() async {
    List<ScrcpyConfig> saved = [];
    final prefs = await SharedPreferences.getInstance();

    final res = prefs.getStringList(PKEY_SAVED_CONFIG) ?? [];

    for (var r in res) {
      saved.add(ScrcpyConfig.fromJson(r));
    }

    return saved;
  }

  static Future<void> saveLastUsedConfig(ScrcpyConfig config) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_LASTUSED_CONFIG, config.id);
  }

  static Future<ScrcpyConfig> getLastUsedConfig(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final allConfig = ref.read(configsProvider);

    final res = prefs.getString(PKEY_LASTUSED_CONFIG) ?? defaultMirror.id;

    final lastUsed = allConfig.firstWhere((c) => c.id == res);

    return lastUsed;
  }

  static Future<void> saveConfigs(
      WidgetRef ref, BuildContext context, List<ScrcpyConfig> conf) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedJson = [];

    for (var c in conf) {
      savedJson.add(c.toJson());
    }

    await trayManager.destroy();
    await TrayUtils.initTray(ref, context);

    prefs.setStringList(PKEY_SAVED_CONFIG, savedJson);
  }

  static Future<List<String>> getRunningScrcpy(String appPID) async {
    List<String> pids = [];

    List<String> split = (await Isolate.run(() => Process.run('bash', [
              '-c',
              ' ${Platform.isMacOS ? 'export PATH=/usr/bin:\$PATH; ' : ''}pgrep scrcpy'
            ])))
        .stdout
        .toString()
        .split('\n');
    split.removeLast();

    pids = split
        .map((e) => e.trim())
        .where((el) => el != appPID.trim() && el.trim().isNotEmpty)
        .toList();

    return pids;
  }

  static killStrays(List<String> pids, ProcessSignal signal) {
    for (var p in pids) {
      Process.killPid(p.toInt()!, signal);
    }
  }

  static Future<ScrcpyRunningInstance> _startServer(WidgetRef ref) async {
    final customInstanceName = ref.read(customNameProvider);
    final selectedConfig = ref.read(selectedConfigProvider);
    final runningInstance = ref.read(scrcpyInstanceProvider);
    final selectedDevice = ref.read(selectedDeviceProvider);

    final d = ref.watch(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == selectedDevice!.id,
        orElse: () => selectedDevice!);

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

    if (selectedConfig.isRecording) {
      File file = File(
          '${selectedConfig.savePath}/${customName.replaceAll(' ', '-')}${selectedConfig.videoOptions.videoFormat.command}');

      if (file.existsSync()) {
        for (int i = 1; i < 100; i++) {
          file = File(
              '${selectedConfig.savePath}/${customName.replaceAll(' ', '-')}($i)${selectedConfig.videoOptions.videoFormat.command}');

          if (!file.existsSync()) {
            customName = '$customName($i)';
            break;
          }
        }
      }
    }

    comm = ScrcpyCommand.buildCommand(ref, selectedConfig, d,
        customName: customName);

    final process = await Process.start(
      'bash',
      [
        '-c',
        '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}scrcpy ${comm.join(' ')}'
      ],
    );
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
    final appPID = ref.read(appPidProvider);

    for (var p in runningInstance) {
      ScrcpyUtils.killServer(p, appPID).then((a) async {
        ref.read(scrcpyInstanceProvider.notifier).removeInstance(p);
      });
    }

    final strays = await AdbUtils.getScrcpyServerPIDs();
    if (strays.isNotEmpty) {
      ScrcpyUtils.killStrays(strays, ProcessSignal.sigterm);
    }

    ref.read(toastProvider.notifier).addToast(
          SimpleToastItem(
            message: 'All (${runningInstance.length}) servers  killed',
            toastStyle: SimpleToastStyle.success,
            key: UniqueKey(),
          ),
        );

    await ScrcpyUtils.saveLastUsedConfig(ref.read(selectedConfigProvider));
  }

  static Future<ScrcpyRunningInstance> newInstance(WidgetRef ref) async {
    final inst = await _startServer(ref);
    ref.read(scrcpyInstanceProvider.notifier).addInstance(inst);

    return inst;
  }

  static Future<void> killServer(
      ScrcpyRunningInstance instance, String appPID) async {
    Process.killPid(int.parse(instance.scrcpyPID));
  }

  static List<ScrcpyRunningInstance> getInstanceForDevice(
      WidgetRef ref, AdbDevices dev) {
    List<ScrcpyRunningInstance> res = ref
        .read(scrcpyInstanceProvider)
        .where((inst) => inst.device == dev)
        .toList();

    return res;
  }

  static Future<List<FlagCheckResult>> checkForIncompatibleFlags(
      WidgetRef ref) async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final selectedConfig = ref.read(selectedConfigProvider);

    List<FlagCheckResult> result = [];

    bool display = selectedDevice!.info!.displays
        .where((d) => d.id == selectedConfig.videoOptions.displayId.toString())
        .isNotEmpty;

    bool videoCodec = selectedDevice.info!.videoEncoders
        .where((enc) => enc.codec == selectedConfig.videoOptions.videoCodec)
        .isNotEmpty;

    bool videoEncoder = selectedConfig.videoOptions.videoEncoder == 'default'
        ? true
        : selectedDevice.info!.videoEncoders
            .where((ve) =>
                ve.encoder.contains(selectedConfig.videoOptions.videoEncoder))
            .isNotEmpty;

    bool duplicateAudio = selectedConfig.audioOptions.duplicateAudio
        ? int.parse(selectedDevice.info!.buildVersion) >= 13
        : true;

    bool audioCodec = selectedDevice.info!.audioEncoder
        .where((enc) => enc.codec == selectedConfig.audioOptions.audioCodec)
        .isNotEmpty;

    bool audioEncoder = selectedConfig.audioOptions.audioEncoder == 'default'
        ? true
        : selectedDevice.info!.audioEncoder
            .where((ae) =>
                ae.encoder.contains(selectedConfig.audioOptions.audioEncoder))
            .isNotEmpty;

    if (display == true) {
      FlagCheckResult dis = FlagCheckResult(ok: true);
      result.add(dis);
    } else if (display == false) {
      FlagCheckResult dis = FlagCheckResult(
        ok: false,
        errorMessage:
            "Display with ID: '${selectedConfig.videoOptions.displayId}' is not available for this device.",
        overrideFlag: const DisplayIdOverride(),
      );

      result.add(dis);
    }

    if (videoCodec == true) {
      FlagCheckResult vidCodec = FlagCheckResult(ok: true);
      result.add(vidCodec);
    } else if (videoCodec == false) {
      FlagCheckResult vidCodec = FlagCheckResult(
        ok: false,
        errorMessage:
            "Codec: '${selectedConfig.videoOptions.videoCodec}' is not available for this device.",
        overrideFlag: const VideoCodecOverride(),
      );

      result.add(vidCodec);
    }

    if (videoEncoder == true) {
      FlagCheckResult vidEncoder = FlagCheckResult(ok: true);
      result.add(vidEncoder);
    } else if (videoEncoder == false) {
      FlagCheckResult vidEncoder = FlagCheckResult(
        ok: false,
        errorMessage:
            "Encoder: '${selectedConfig.videoOptions.videoEncoder}' is not available for this device.",
        overrideFlag: const VideoCodecOverride(),
      );

      result.add(vidEncoder);
    }

    if (duplicateAudio == true) {
      FlagCheckResult dup = FlagCheckResult(ok: true);
      result.add(dup);
    } else if (duplicateAudio == false) {
      FlagCheckResult dup = FlagCheckResult(
        ok: false,
        errorMessage: 'Audio duplicate only available for Android 13 and up.',
      );

      result.add(dup);
    }

    if (audioCodec == true) {
      FlagCheckResult audCodec = FlagCheckResult(ok: true);
      result.add(audCodec);
    } else if (audioCodec == false) {
      FlagCheckResult audCodec = FlagCheckResult(
        ok: false,
        errorMessage:
            "Codec: '${selectedConfig.audioOptions.audioCodec}' is not available for this device.",
        overrideFlag: const VideoCodecOverride(),
      );

      result.add(audCodec);
    }

    if (audioEncoder == true) {
      FlagCheckResult audEncoder = FlagCheckResult(ok: true);
      result.add(audEncoder);
    } else if (audioEncoder == false) {
      FlagCheckResult audEncoder = FlagCheckResult(
        ok: false,
        errorMessage:
            "Encoder: '${selectedConfig.audioOptions.audioEncoder}' is not available for this device.",
        overrideFlag: const VideoCodecOverride(),
      );

      result.add(audEncoder);
    }

    return result;
  }
}
