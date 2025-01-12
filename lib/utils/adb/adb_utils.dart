import 'dart:io';
import 'dart:isolate';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/result/wireless_connect_result.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_camera.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_display.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_encoder.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb/_adb_utils.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../models/adb_devices.dart';
import '../../providers/adb_provider.dart';
import '../../providers/toast_providers.dart';
import '../../widgets/simple_toast/simple_toast_item.dart';
import '../const.dart';

class AdbUtils {
  static Future<List<AdbDevices>> connectedDevices(String workDir,
      {bool showLog = true}) async {
    final adbDeviceRes =
        await Process.run(eadb, ['devices'], workingDirectory: workDir);

    final connected = adbDeviceRes.stdout
        .toString()
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    connected.removeAt(0);

    final devices = await getAdbInfos(workDir, connected: connected);

    return devices.where((e) => e.status).toList();
  }

  static Future<ScrcpyInfo> getScrcpyDetailsFor(
      String workDir, AdbDevices dev) async {
    final buildVersion = await Process.run(
      eadb,
      ['-s', dev.id, 'shell', 'getprop', 'ro.product.build.version.release'],
      workingDirectory: workDir,
    );

    final info = await Process.run(escrcpy,
        ['-s', dev.id, '--list-encoders', '--list-displays', '--list-cameras'],
        workingDirectory: workDir, environment: shellEnv);

    final cameraInfo = _getCameraInfo(info.stdout);
    final videoEncoderInfo = _getVideoEncoders(info.stdout);
    final audioEncoderInfo = _getAudioEncoders(info.stdout);
    final displayInfo = _getDisplays(info.stdout);

    return ScrcpyInfo(
      device: dev,
      buildVersion: buildVersion.stdout.toString().trim(),
      cameras: cameraInfo,
      displays: displayInfo,
      videoEncoders: videoEncoderInfo,
      audioEncoder: audioEncoderInfo,
    );
  }

  static Future<void> disconnectWirelessDevice(
      String workDir, AdbDevices dev) async {
    try {
      logger.i('Disconnecting ${dev.id}');
      await Isolate.run(() =>
          Process.run(eadb, ['disconnect', dev.id], workingDirectory: workDir));
    } on Exception catch (e) {
      logger.e('Error diconnecting ${dev.id}', error: e);
    }
  }

  static Future<void> saveWirelessDeviceHistory(
      WidgetRef ref, String ip) async {
    final workDir = ref.read(execDirProvider);
    final connected = await AdbUtils.connectedDevices(workDir);

    final currentHx = [...ref.read(wirelessDevicesHistoryProvider)];

    final toSave = connected.firstWhere((c) {
      return c.id.split(':').first == ip.split(':').first;
    });

    final named = ref.read(savedAdbDevicesProvider);

    if (named.where((d) => d.serialNo == toSave.serialNo).isNotEmpty) {
      final dev = named.firstWhere((d) => d.serialNo == toSave.serialNo);
      ref.read(toastProvider.notifier).addToast(SimpleToastItem(
            icon: Icons.link_rounded,
            message: '${dev.name!.toUpperCase()} connected',
            toastStyle: SimpleToastStyle.success,
            key: UniqueKey(),
          ));
    } else {
      ref.read(toastProvider.notifier).addToast(SimpleToastItem(
            icon: Icons.link_rounded,
            message: '${toSave.serialNo.toUpperCase()} connected',
            toastStyle: SimpleToastStyle.success,
            key: UniqueKey(),
          ));
    }

    final savedDevices = ref.read(savedAdbDevicesProvider);

    ref.read(adbProvider.notifier).setConnected(connected, savedDevices);

    bool toSaveExists =
        currentHx.where((h) => h.serialNo == toSave.serialNo).isNotEmpty;

    if (!toSaveExists) {
      currentHx.add(toSave);

      ref.read(wirelessDevicesHistoryProvider.notifier).state = currentHx;
      AdbUtils.saveWirelessHistory(currentHx);
    } else {
      int idx = currentHx.indexWhere((h) => h.serialNo == toSave.serialNo);

      currentHx.removeAt(idx);
      currentHx.insert(idx, toSave);

      ref.read(wirelessDevicesHistoryProvider.notifier).state = currentHx;
      AdbUtils.saveWirelessHistory(currentHx);
    }
  }

  //using ip
  static Future<WiFiResult> connectWithIp(String workDir,
      {required String ip}) async {
    ProcessResult? res;

    res = await Process.run(eadb, ['connect', '$ip:5555'],
            workingDirectory: workDir)
        .timeout(
      30.seconds,
      onTimeout: () {
        logger.i('Connecting $ip, timed-out');
        return ProcessResult(pid, exitCode, 'timed-out', stderr);
      },
    );

    //stop unauth
    if (res.stdout.toString().contains('authenticate')) {
      logger.i('Unauthenticated, check phone');
      await Process.run(eadb, ['disconnect', '$ip:5555'],
          workingDirectory: workDir);

      return WiFiResult(success: false, errorMessage: res.stdout);
    }

    return WiFiResult(
      success: !res.stdout.toString().contains('failed') &&
          !res.stdout.toString().contains('timed-out'),
      errorMessage: res.stdout,
    );
  }

  //using mdns
  static Future<WiFiResult> connectWithMdns(WidgetRef ref,
      {required String id}) async {
    final workDir = ref.read(execDirProvider);
    ProcessResult? res;

    res = await Process.run(eadb, ['connect', id], workingDirectory: workDir)
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
      await Process.run(eadb, ['disconnect', '$id.$adbMdns'],
          workingDirectory: workDir);

      return WiFiResult(success: false, errorMessage: res.stdout);
    }

    return WiFiResult(
      success: !res.stdout.toString().contains('failed') &&
          !res.stdout.toString().contains('timed-out'),
      errorMessage: res.stdout,
    );
  }

  static Future<void> tcpip5555(String workDir, String id) async {
    logger.i('Setting tcp 5555 for $id');

    try {
      await Process.run(eadb, ['-s', id, 'tcpip', '5555'],
          workingDirectory: workDir);
    } on Exception catch (e) {
      logger.e('Error setting tcp 5555 for $id', error: e);
    }
  }

  static Future<String> getIpForUSB(String workDir, AdbDevices dev) async {
    String? ip;
    try {
      logger.i('Getting ip for ${dev.id}');

      final res = await Process.run(
          eadb, ['-s', (dev.serialNo), 'shell', 'ip', 'route'],
          workingDirectory: workDir);

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

  static Future<void> saveAdbDevice(List<AdbDevices> dev) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        PKEY_SAVED_DEVICES, dev.map((e) => e.toJson()).toList());
    // prefs.remove(PKEY_SAVED_DEVICES);
  }

  static Future<List<AdbDevices>> getSavedAdbDevice() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove(PKEY_SAVED_DEVICES);
    final jsons = prefs.getStringList(PKEY_SAVED_DEVICES) ?? [];

    return jsons.map((e) => AdbDevices.fromJson(e)).toList();
  }

  static Future<void> saveWirelessHistory(List<AdbDevices> devs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        PKEY_WIRELESS_DEVICE_HX, devs.map((d) => d.toJson()).toList());
  }

  static Future<List<AdbDevices>> getWirelessHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStr =
        prefs.getStringList(PKEY_WIRELESS_DEVICE_HX) ?? [];

    return historyStr.map((s) => AdbDevices.fromJson(s)).toList();
  }

  static Future<void> saveAutoConnectDevices(List<AdbDevices> devs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        PKEY_AUTO_CONNECT_DEVICES, devs.map((e) => e.toJson()).toList());
  }
}

List<ScrcpyCamera> _getCameraInfo(String res) {
  RegExp idRegex = RegExp(r'(?<=--camera-id=)\d+');
  RegExp descRegex = RegExp(r'(?<=\()\w+(?=,)');
  RegExp resolutionRegex = RegExp(r'\d+x\d+');
  RegExp fpsRegex = RegExp(r'(?<=\[)\d+, \d+(?=])');

  List<ScrcpyCamera> cameras = [];

  final cameraInfo = res
      .toString()
      .splitLines()
      .where((e) => e.contains('--camera-id='))
      .toList();

  for (final info in cameraInfo) {
    try {
      final id = idRegex.stringMatch(info);
      final desc = descRegex.stringMatch(info);
      final resolution = resolutionRegex.stringMatch(info);
      final fps = fpsRegex.stringMatch(info);
      ScrcpyCamera camera = ScrcpyCamera(
        id: id ?? 'null',
        desc: desc!,
        sizes: [resolution!],
        fps: fps?.split(',').map((e) => e.trim()).toList() ?? [],
      );
      cameras.add(camera);
    } on Exception catch (e) {
      logger.e('Error getting camera info from scrcpy', error: e);
    }
  }

  return cameras;
}

List<VideoEncoder> _getVideoEncoders(String res) {
  RegExp codecRegex = RegExp(r'(?<=--video-codec=)\w+');
  RegExp encoderRegex = RegExp(r"(?<=--video-encoder=)(.*)(?= )");
  List<VideoEncoder> videoEncoders = [];
  final encoderInfo = res
      .toString()
      .splitLines()
      .where((i) => i.contains('--video-codec='))
      .toList();

  for (final info in encoderInfo) {
    try {
      final codec = codecRegex.stringMatch(info);
      final encoder = encoderRegex.stringMatch(info)!.split(' ').first;
      if (videoEncoders.where((e) => e.codec.contains(codec!)).isNotEmpty) {
        videoEncoders
            .firstWhere((e) => e.codec.contains(codec!))
            .encoder
            .add(encoder);
      } else {
        videoEncoders.add(VideoEncoder(codec: codec!, encoder: [encoder]));
      }
    } on Exception catch (e) {
      logger.e('Error getting video encoders info from scrcpy', error: e);
    }
  }

  return videoEncoders;
}

List<AudioEncoder> _getAudioEncoders(String res) {
  RegExp codecRegex = RegExp(r'(?<=--audio-codec=)\w+');
  RegExp encoderRegex = RegExp(r"(?<=--audio-encoder=)(.*)(?= )");
  List<AudioEncoder> audioEncoder = [];

  final encoderInfo = res
      .toString()
      .splitLines()
      .where((i) => i.contains('--audio-codec='))
      .toList();

  for (final info in encoderInfo) {
    try {
      final codec = codecRegex.stringMatch(info);
      final encoder = encoderRegex.stringMatch(info)!.split(' ').first;
      if (audioEncoder.where((e) => e.codec.contains(codec!)).isNotEmpty) {
        audioEncoder
            .firstWhere((e) => e.codec.contains(codec!))
            .encoder
            .add(encoder);
      } else {
        audioEncoder.add(AudioEncoder(codec: codec!, encoder: [encoder]));
      }
    } on Exception catch (e) {
      logger.e('Error getting audio encoders info from scrcpy', error: e);
    }
  }

  return audioEncoder;
}

List<ScrcpyDisplay> _getDisplays(String res) {
  RegExp idRegex = RegExp(r'(?<=--display-id=)\d+');
  RegExp resolutionRegex = RegExp(r'\d+x\d+');
  List<ScrcpyDisplay> displays = [];

  try {
    final displayInfo = res
        .toString()
        .splitLines()
        .where((i) => i.contains('--display-id='))
        .toList();

    for (final info in displayInfo) {
      final id = idRegex.stringMatch(info);
      final resolution = resolutionRegex.stringMatch(info);

      displays.add(ScrcpyDisplay(id: id!, resolution: resolution!));
    }
  } on Exception catch (e) {
    logger.e('Error getting display info from scrcpy', error: e);
  }

  return displays;
}
