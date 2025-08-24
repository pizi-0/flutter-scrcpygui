import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/device_info_model.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/result/wireless_connect_result.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_camera.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_display.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_encoder.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/command_runner.dart';

import '../models/adb_devices.dart';
import 'const.dart';

class AdbUtils {
  static Future<List<AdbDevices>> connectedDevices(String workDir,
      {bool showLog = true}) async {
    List<AdbDevices> res = [];

    try {
      final adbDeviceRes =
          await CommandRunner.runAdbCommand(workDir, args: ['devices']);

      final connected = adbDeviceRes.stdout
          .toString()
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();

      connected.removeAt(0);

      final devices = await getAdbInfos(workDir, connected: connected);
      res = devices.where((e) => e.status).toList();
    } on ProcessException catch (_) {
      rethrow;
    }

    return res;
  }

  static void autoSelectDevice(WidgetRef ref) {
    final connected = ref.read(adbProvider);
    final device = ref.read(selectedDeviceProvider);

    if (device == null) {
      if (connected.isNotEmpty) {
        Set<String> serialNos = connected.map((e) => e.serialNo).toSet();

        if (serialNos.length == 1) {
          ref.read(selectedDeviceProvider.notifier).state = connected.first;
        }
      }
    }
  }

  // static Future<ScrcpyInfo> getScrcpyDetailsFor(
  //     String workDir, AdbDevices dev) async {
  //   String buildVersion = '';
  //   final res = await CommandRunner.runAdbCommand(workDir, args: [
  //     '-s',
  //     dev.id,
  //     'shell',
  //     'getprop',
  //     'ro.product.build.version.release'
  //   ]);

  //   if (res.stdout.toString().trim().isNotEmpty) {
  //     buildVersion = res.stdout.toString().trim();
  //   } else {
  //     final res = await CommandRunner.runAdbCommand(workDir,
  //         args: ['-s', dev.id, 'shell', 'getprop', 'ro.build.version.release']);
  //     buildVersion = res.stdout.toString().trim();
  //   }

  //   final info = await CommandRunner.runScrcpyCommand(
  //     workDir,
  //     dev,
  //     args: [
  //       '--list-encoders',
  //       '--list-displays',
  //       '--list-cameras',
  //       '--list-apps'
  //     ],
  //   );

  //   final cameraInfo = _getCameraInfo(info.stdout);
  //   final videoEncoderInfo = _getVideoEncoders(info.stdout);
  //   final audioEncoderInfo = _getAudioEncoders(info.stdout);
  //   final displayInfo = getDisplays(info.stdout);
  //   final appsList = getAppsList(info.stdout);

  //   return ScrcpyInfo(
  //     device: dev,
  //     buildVersion: buildVersion,
  //     cameras: cameraInfo,
  //     displays: displayInfo,
  //     videoEncoders: videoEncoderInfo,
  //     audioEncoder: audioEncoderInfo,
  //     appList: appsList,
  //   );
  // }

  static Future<DeviceInfo> getDeviceInfoFor(
      String workDir, AdbDevices dev) async {
    String buildVersion = '';
    final res = await CommandRunner.runAdbCommand(workDir, args: [
      '-s',
      dev.id,
      'shell',
      'getprop',
      'ro.product.build.version.release'
    ]);

    if (res.stdout.toString().trim().isNotEmpty) {
      buildVersion = res.stdout.toString().trim();
    } else {
      final res = await CommandRunner.runAdbCommand(workDir,
          args: ['-s', dev.id, 'shell', 'getprop', 'ro.build.version.release']);
      buildVersion = res.stdout.toString().trim();
    }

    final info = await CommandRunner.runScrcpyCommand(
      workDir,
      dev,
      args: [
        '--list-encoders',
        '--list-displays',
        '--list-cameras',
        '--list-apps'
      ],
    );

    final cameraInfo = _getCameraInfo(info.stdout);
    final videoEncoderInfo = _getVideoEncoders(info.stdout);
    final audioEncoderInfo = _getAudioEncoders(info.stdout);
    final displayInfo = getDisplays(info.stdout);
    final appsList = getAppsList(info.stdout);

    return DeviceInfo(
      serialNo: dev.serialNo,
      deviceName: dev.modelName,
      buildVersion: buildVersion,
      cameras: cameraInfo,
      displays: displayInfo,
      videoEncoders: videoEncoderInfo,
      audioEncoder: audioEncoderInfo,
      appList: appsList,
    );
  }

  static Future<void> disconnectWirelessDevice(
      String workDir, AdbDevices dev) async {
    await CommandRunner.runAdbCommand(workDir, args: ['disconnect', dev.id]);
  }

  //using ip
  static Future<WiFiResult> connectWithIp(String workDir,
      {required String ipport}) async {
    ProcessResult? res;

    res = await CommandRunner.runAdbCommand(workDir, args: ['connect', ipport])
        .timeout(
      30.seconds,
      onTimeout: () {
        logger.i('Connecting $ipport, timed-out');
        return ProcessResult(pid, exitCode, 'timed-out', stderr);
      },
    );

    //stop unauth
    if (res.stdout.toString().contains('authenticate')) {
      logger.i('Unauthenticated, check phone');
      await CommandRunner.runAdbCommand(workDir, args: ['disconnect', ipport]);

      return WiFiResult(success: false, errorMessage: res.stdout);
    }

    return WiFiResult(
      success: !res.stdout.toString().contains('empty address') &&
          !res.stdout.toString().contains('failed') &&
          !res.stdout.toString().contains('timed-out') &&
          !res.stdout.toString().contains('cannot connect') &&
          !res.stdout.toString().contains('Connection refused'),
      errorMessage: res.stdout,
    );
  }

  //using mdns
  static Future<WiFiResult> connectWithMdns(WidgetRef ref,
      {required String id, required String from}) async {
    final workDir = ref.read(execDirProvider);
    ProcessResult? res;

    debugPrint('Connecting $id from $from');

    res = await CommandRunner.runAdbCommand(workDir, args: ['connect', id])
        .timeout(
      30.seconds,
      onTimeout: () {
        logger.i('Connecting $id, timed-out');
        return ProcessResult(pid, exitCode, 'timed-out', stderr);
      },
    );

    //stop unauth
    if (res.stdout.toString().contains('authenticate')) {
      logger.i('Unauthenticated, check phone');
      await CommandRunner.runAdbCommand(workDir,
          args: ['disconnect', '$id.$adbMdns']);

      return WiFiResult(success: false, errorMessage: res.stdout);
    }

    return WiFiResult(
      success: !res.stdout.toString().contains('failed') &&
          !res.stdout.toString().contains('timed-out') &&
          !res.stdout.toString().contains('cannot resolve host'),
      errorMessage: res.stdout,
    );
  }

  static Future<void> tcpip5555(String workDir, String id) async {
    logger.i('Setting tcp 5555 for $id');

    try {
      final res = await CommandRunner.runAdbCommand(workDir,
          args: ['-s', id, 'tcpip', '5555']);

      logger.i(res.stdout);
    } on Exception catch (e) {
      logger.e('Error setting tcp 5555 for $id', error: e);
    }
  }

  //wireless pair
  static Future<String> pairWithCode(
      String deviceName, String code, WidgetRef ref) async {
    final workDir = ref.read(execDirProvider);

    final res = await CommandRunner.runAdbCommand(workDir,
        args: ['pair', deviceName, code]);

    debugPrint('Out: ${res.stdout},\nErr: ${res.stderr}');

    return res.stdout;
  }

  static Future<void> pairWithQr(
      String deviceName, String code, WidgetRef ref) async {
    final workDir = ref.read(execDirProvider);

    await CommandRunner.runAdbCommand(workDir,
        args: ['pair', deviceName, code]);
  }

  static Future<String> getIpForUSB(String workDir, AdbDevices dev) async {
    String? ip;
    try {
      logger.i('Getting ip for ${dev.id}');

      final res = await CommandRunner.runAdbCommand(workDir,
          args: ['-s', (dev.serialNo), 'shell', 'ip', 'route']);

      final res2 = res.stdout.toString().splitLines();

      final res3 = res2.lastWhere((e) => e.contains('wlan0'));

      final res4 = res3.split(' ').lastWhere((e) => e.isIpv4 || e.isIpv6);

      ip = res4.trim();
    } on Exception catch (e) {
      logger.e('Error getting ip for ${dev.id}', error: e);
      ip = '';
    }

    return ip;
  }

  static Future<List<String>> getScrcpyServerPIDs() async {
    List<String> adbPIDs = [];

    try {
      logger.i('Get running scrcpy server');
      final res = (await Process.run('bash', [
        '-c',
        ' ${Platform.isMacOS ? 'export PATH=/usr/bin:\$PATH; ' : ''}pgrep -f scrcpy-server'
      ]))
          .stdout
          .toString()
          .split('\n');

      res.removeLast();

      adbPIDs = res.map((e) => e.trim()).toList();
    } on Exception catch (e) {
      logger.e('Error getting running scrcpy servers', error: e);
    }

    return adbPIDs;
  }
}

List<ScrcpyCamera> _getCameraInfo(String res) {
  RegExp idRegex = RegExp(r'--camera-id=(\d+)');
  RegExp descRegex = RegExp(r'\(([^,]+),');
  RegExp resolutionRegex = RegExp(r'(\d+x\d+)');
  RegExp fpsRegex = RegExp(r'fps=\[([^\]]+)\]');

  List<ScrcpyCamera> cameras = [];

  final cameraInfo = res
      .toString()
      .splitLines()
      .where((e) => e.contains('--camera-id='))
      .toList();

  for (final info in cameraInfo) {
    try {
      final id = idRegex.firstMatch(info)?.group(1);
      final desc = descRegex.firstMatch(info)?.group(1);
      final resolution = resolutionRegex.firstMatch(info)?.group(1);
      final fpsRaw = fpsRegex.firstMatch(info)?.group(1);
      List<String> fps =
          fpsRaw != null ? fpsRaw.split(',').map((e) => e.trim()).toList() : [];

      ScrcpyCamera camera = ScrcpyCamera(
        id: id ?? 'null',
        desc: desc ?? '',
        sizes: [resolution ?? ''],
        fps: fps,
      );
      cameras.add(camera);
    } on Exception catch (e) {
      logger.e('Error getting camera info from scrcpy', error: e);
    }
  }

  return cameras;
}

List<VideoEncoder> _getVideoEncoders(String res) {
  RegExp codecRegex = RegExp(r'--video-codec=([^\s]+)');
  RegExp encoderRegex = RegExp(r'--video-encoder=([^\s]+)');
  List<VideoEncoder> videoEncoders = [];
  final encoderInfo = res
      .toString()
      .splitLines()
      .where((i) => i.contains('--video-codec='))
      .toList();

  for (final info in encoderInfo) {
    try {
      final codecMatch = codecRegex.firstMatch(info);
      final encoderMatch = encoderRegex.firstMatch(info);
      final codec = codecMatch?.group(1);
      final encoder = encoderMatch?.group(1);
      if (codec == null || encoder == null) continue;
      if (videoEncoders.where((e) => e.codec == codec).isNotEmpty) {
        videoEncoders.firstWhere((e) => e.codec == codec).encoder.add(encoder);
      } else {
        videoEncoders.add(VideoEncoder(codec: codec, encoder: [encoder]));
      }
    } on Exception catch (e) {
      logger.e('Error getting video encoders info from scrcpy', error: e);
    }
  }

  return videoEncoders;
}

List<AudioEncoder> _getAudioEncoders(String res) {
  RegExp codecRegex = RegExp(r'--audio-codec=([^\s]+)');
  RegExp encoderRegex = RegExp(r'--audio-encoder=([^\s]+)');
  List<AudioEncoder> audioEncoder = [];

  final encoderInfo = res
      .toString()
      .splitLines()
      .where((i) => i.contains('--audio-codec='))
      .toList();

  for (final info in encoderInfo) {
    try {
      final codecMatch = codecRegex.firstMatch(info);
      final encoderMatch = encoderRegex.firstMatch(info);
      final codec = codecMatch?.group(1);
      final encoder = encoderMatch?.group(1);
      if (codec == null || encoder == null) continue;
      if (audioEncoder.where((e) => e.codec == codec).isNotEmpty) {
        audioEncoder.firstWhere((e) => e.codec == codec).encoder.add(encoder);
      } else {
        audioEncoder.add(AudioEncoder(codec: codec, encoder: [encoder]));
      }
    } on Exception catch (e) {
      logger.e('Error getting audio encoders info from scrcpy', error: e);
    }
  }

  return audioEncoder;
}

List<ScrcpyDisplay> getDisplays(String res) {
  RegExp idRegex = RegExp(r'(?<=--display-id=)\d+');
  RegExp resolutionRegex = RegExp(r'\((\d+x\d+)\)');
  List<ScrcpyDisplay> displays = [];

  try {
    final displayInfo = res
        .toString()
        .splitLines()
        .where((i) => i.contains('--display-id='))
        .toList();

    for (final info in displayInfo) {
      final id = idRegex.stringMatch(info);
      final resolutionMatch = resolutionRegex.firstMatch(info);
      final resolution = resolutionMatch?.group(1);
      if (id != null && resolution != null) {
        displays.add(ScrcpyDisplay(id: id, resolution: resolution));
      }
    }
  } on Exception catch (e) {
    logger.e('Error getting display info from scrcpy', error: e);
  }

  return displays;
}

List<ScrcpyApp> getAppsList(String res) {
  List<ScrcpyApp> apps = [];

  final split = res.split('[server] INFO: List of apps:');

  final cleaned = split.last
      .trim()
      .splitLines()
      .where((e) => e.trim().startsWith('-') || e.trim().startsWith('*'))
      .map((e) => e.trimAll.replaceLast(' ', 'split').split('split'))
      .toList();

  apps = cleaned
      .where((c) => !c.contains(adbMdns))
      .map(
        (e) => ScrcpyApp(
            name: e.first.replaceAtIndex(index: 0, replacement: '').trim(),
            packageName: e.last),
      )
      .toList();

  return apps;
}

Future<List<AdbDevices>> getAdbInfos(String workDir,
    {required List<String> connected}) async {
  List<AdbDevices> devices = [];
  for (var e in connected) {
    String? serialNo;
    String? modelName;

    final d = e.split('	').toList();
    final id = d[0];
    final status = d[1].trim() != 'offline' && d[1].trim() != 'unauthorized';

    try {
      if (status) {
        ProcessResult modelNameRes = await Process.run(
                Platform.isWindows ? '$workDir\\adb.exe' : eadb,
                ['-s', id, 'shell', 'getprop', 'ro.product.model'],
                workingDirectory: workDir)
            .timeout(20.seconds,
                onTimeout: () =>
                    ProcessResult(pid, 124, 'timed-out', 'timed-out'));

        modelName = modelNameRes.stdout.toString().trim();
      }

      if (id.contains(':') || id.contains(adbMdns)) {
        //get serial no if status != offline or unauth
        if (status) {
          final serialNoRes = await Process.run(
                  Platform.isWindows ? '$workDir\\adb.exe' : eadb,
                  ['-s', id, 'shell', 'getprop', 'ro.boot.serialno'],
                  workingDirectory: workDir)
              .timeout(20.seconds,
                  onTimeout: () =>
                      ProcessResult(pid, exitCode, '', 'timed-out'));

          serialNo = serialNoRes.stdout.toString().trim();
        }
      } else {
        serialNo = id;
      }

      devices.add(
        AdbDevices(
          id: id,
          modelName: modelName ?? '',
          status: status,
          serialNo: serialNo ?? '',
        ),
      );
    } on Exception catch (e) {
      logger.e('Error getting info for $id from adb', error: e);
    }
  }

  return devices;
}
