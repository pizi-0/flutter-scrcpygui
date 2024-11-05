import 'dart:io';
import 'dart:isolate';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/process_output.dart';
import 'package:scrcpygui/models/result/wireless_connect_result.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_camera.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_display.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_encoder.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';

import '../models/adb_devices.dart';
import '../providers/adb_provider.dart';
import '../providers/toast_providers.dart';
import '../widgets/simple_toast/simple_toast_item.dart';

class AdbUtils {
  static final String _shell = Platform.environment['SHELL'] ?? 'bash';

  static Future<bool> adbInstalled() async {
    final res = await Isolate.run(() => Process.run('bash', [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}which adb'
        ]));

    debugPrint(
      ProcessOutput(
        command: 'which adb',
        stdout: res.stdout,
        stderr: res.stderr,
        exitCode: res.exitCode,
      ).toString(),
    );

    return res.stdout.toString().isNotEmpty;
  }

  static Future<List<AdbDevices>> connectedDevices(
      {bool showLog = true}) async {
    List<AdbDevices> devices = [];
    final adbDeviceRes = await Isolate.run(() => Process.run(
          'bash',
          [
            '-c',
            '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb devices'
          ],
        ));

    if (showLog) {
      debugPrint(ProcessOutput(
        command: 'adb devices',
        stdout: adbDeviceRes.stdout,
        stderr: adbDeviceRes.stderr,
        exitCode: adbDeviceRes.exitCode,
      ).toString());
    }

    final connected = adbDeviceRes.stdout
        .toString()
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    connected.removeAt(0);

    for (var e in connected) {
      String? serialNo;
      String? modelName;

      final d = e.split('	').toList();
      final id = d[0];
      final status = d[1].trim() != 'offline' && d[1].trim() != 'unauthorized';

      if (status) {
        ProcessResult modelNameRes = await Process.run(_shell, [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb -s $id shell getprop ro.product.model'
        ]).timeout(2.seconds,
            onTimeout: () => ProcessResult(pid, 124, 'timed-out', 'timed-out'));

        if (showLog) {
          debugPrint(
            ProcessOutput(
              command: 'adb -s $id shell getprop ro.product.model',
              stdout: modelNameRes.stdout,
              stderr: modelNameRes.stderr,
              exitCode: modelNameRes.exitCode,
            ).toString(),
          );
        }
        modelName = modelNameRes.stdout.toString().trim();
      }

      if (id.contains(':')) {
        //get serial no if status != offline or unauth
        if (status) {
          final serialNoRes = await Process.run(_shell, [
            '-c',
            '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb -s $id shell getprop ro.boot.serialno'
          ]).timeout(2.seconds,
              onTimeout: () => ProcessResult(pid, exitCode, '', 'timed-out'));

          if (showLog) {
            debugPrint(
              ProcessOutput(
                command: 'adb -s $id shell getprop ro.boot.serialno',
                stdout: serialNoRes.stdout,
                stderr: serialNoRes.stderr,
                exitCode: serialNoRes.exitCode,
              ).toString(),
            );
          }

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
    }

    return devices.where((e) => e.status).toList();
  }

  static Future<ScrcpyInfo> getScrcpyDetailsFor(AdbDevices dev) async {
    final buildVersion = await Process.run('bash', [
      '-c',
      '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb -s ${dev.id} shell getprop ro.product.build.version.release'
    ]);

    final info = await Process.run('bash', [
      '-c',
      '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}scrcpy -s ${dev.id} --list-encoders --list-displays --list-cameras'
    ]);

    debugPrint(ProcessOutput(
      command:
          'scrcpy -s ${dev.id} --list-encoders --list-displays --list-cameras ',
      stdout: info.stdout,
      stderr: info.stderr,
      exitCode: info.exitCode,
    ).toString());

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

  static Future<void> disconnectWirelessDevice(AdbDevices dev) async {
    ProcessResult disconnectRes = await Isolate.run(() => Process.run('bash', [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb disconnect ${dev.id}'
        ]));

    debugPrint(ProcessOutput(
      command: 'adb disconnect ${dev.id}',
      stdout: disconnectRes.stdout,
      stderr: disconnectRes.stderr,
      exitCode: exitCode,
    ).toString());
  }

  static Future<void> saveWirelessDeviceHistory(
      WidgetRef ref, String ip) async {
    final connected = await AdbUtils.connectedDevices();

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

    ref.read(adbProvider.notifier).setConnected(connected);

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

  static Future<WiFiResult> connectWifiDebugging({required String ip}) async {
    ProcessResult? res;

    if (!ip.contains(':')) {
      res = await Process.run('bash', [
        '-c',
        '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb connect $ip:5555'
      ]).timeout(
        5.seconds,
        onTimeout: () {
          return ProcessResult(pid, exitCode, 'timed-out', stderr);
        },
      );
    } else {
      res = await Process.run('bash', [
        '-c',
        '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb connect $ip'
      ]).timeout(
        5.seconds,
        onTimeout: () {
          return ProcessResult(pid, exitCode, 'timed-out', stderr);
        },
      );

      //stop unauth
      if (res.stdout.toString().contains('authenticate')) {
        await Process.run('bash', [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb disconnect $ip'
        ]);

        return WiFiResult(success: false, errorMessage: res.stdout);
      }

      //on success, change to tcp 5555 if not already
      if ((!res.stdout.toString().contains('failed') ||
              !res.stdout.toString().contains('timed-out')) &&
          !ip.contains(':5555')) {
        await tcpip5555(ip);

        final adb = await connectedDevices();

        if (adb.where((d) => d.id == ip).isNotEmpty) {
          await Process.run('bash', [
            '-c',
            '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb disconnect $ip'
          ]);
        }

        res = await Process.run('bash', [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb connect ${ip.split(':').first.append(':5555')}'
        ]).timeout(
          5.seconds,
          onTimeout: () {
            return ProcessResult(pid, exitCode, 'timed-out', stderr);
          },
        );

        debugPrint('OUT: ${res.stdout}, ERR: ${res.stderr}');
      }

      //try with 5555 if given port is err
      if (res.stdout.toString().contains('failed')) {
        final newIp = ip.replaceAll(RegExp(r':\d+$'), ':5555');

        res = await Process.run('bash', [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb connect $newIp'
        ]).timeout(
          5.seconds,
          onTimeout: () {
            return ProcessResult(pid, exitCode, 'timed-out', stderr);
          },
        );
      }

      //bad port
      if (res.stdout.toString().contains('bad port')) {
        final newIp = ip.split(':').first.toString();

        res = await Process.run('bash', [
          '-c',
          '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb connect $newIp'
        ]).timeout(
          5.seconds,
          onTimeout: () {
            return ProcessResult(pid, exitCode, 'timed-out', stderr);
          },
        );
      }
    }

    return WiFiResult(
      success: !res.stdout.toString().contains('failed') &&
          !res.stdout.toString().contains('timed-out'),
      errorMessage: res.stdout,
    );
  }

  static Future<void> tcpip5555(String id) async {
    final res = await Process.run('bash', [
      '-c',
      '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb -s $id tcpip 5555'
    ]);

    debugPrint(ProcessOutput(
      command: 'adb -s $id tcpip 5555',
      stdout: res.stdout,
      stderr: res.stderr,
      exitCode: res.exitCode,
    ).toString());
  }

  static Future<String> getIpForUSB(AdbDevices dev) async {
    String? ip;
    final res = await Process.run('bash', [
      '-c',
      '${Platform.isMacOS ? 'export PATH=/usr/local/bin:\$PATH; ' : ''}adb -s ${dev.serialNo} shell ip route'
    ]);

    final res2 = res.stdout.toString().splitLines();

    final res3 = res2.lastWhere((e) => e.contains('wlan0'));

    final res4 = res3.split(' ').lastWhere((e) => e.isIpv4 || e.isIpv6);

    ip = res4.trim();

    return ip;
  }

  static Future<List<String>> getScrcpyServerPIDs() async {
    List<String> adbPIDs = [];

    final res = (await Process.run('bash', [
      '-c',
      ' ${Platform.isMacOS ? 'export PATH=/usr/bin:\$PATH; ' : ''}pgrep -f scrcpy-server'
    ]))
        .stdout
        .toString()
        .split('\n');

    res.removeLast();

    adbPIDs = res.map((e) => e.trim()).toList();

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

  static Future<List<AdbDevices>> getAutoConnectDevices() async {
    List<AdbDevices> res = [];
    final prefs = await SharedPreferences.getInstance();

    final saved = prefs.getStringList(PKEY_AUTO_CONNECT_DEVICES) ?? [];

    res = saved.map((e) => AdbDevices.fromJson(e)).toList();

    return res;
  }

  static Future<void> saveAutoConnectDevices(List<AdbDevices> devs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        PKEY_AUTO_CONNECT_DEVICES, devs.map((e) => e.toJson()).toList());
  }

  static Future<void> pingAutoConnectDevices(WidgetRef ref) async {
    final autoDevices = ref.read(autoConnectDevicesProvider);
    final connectedDevices = ref.read(adbProvider);

    for (final d in autoDevices) {
      final ping = Ping(d.id.split(':').first);

      final res = (await ping.stream.first).error;

      if (res == null) {
        if (!connectedDevices.contains(d)) {
          await connectWifiDebugging(ip: d.id);
        }
      }
    }
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
  }

  return cameras;
}

List<VideoEncoder> _getVideoEncoders(String res) {
  RegExp codecRegex = RegExp(r'(?<=--video-codec=)\w+');
  RegExp encoderRegex = RegExp(r"(?<=--video-encoder=')(.*)(?=')");
  List<VideoEncoder> videoEncoders = [];
  final encoderInfo = res
      .toString()
      .splitLines()
      .where((i) => i.contains('--video-codec='))
      .toList();

  for (final info in encoderInfo) {
    final codec = codecRegex.stringMatch(info);
    final encoder = encoderRegex.stringMatch(info);
    if (videoEncoders.where((e) => e.codec.contains(codec!)).isNotEmpty) {
      videoEncoders
          .firstWhere((e) => e.codec.contains(codec!))
          .encoder
          .add(encoder!);
    } else {
      videoEncoders.add(VideoEncoder(codec: codec!, encoder: [encoder!]));
    }
  }

  return videoEncoders;
}

List<AudioEncoder> _getAudioEncoders(String res) {
  RegExp codecRegex = RegExp(r'(?<=--audio-codec=)\w+');
  RegExp encoderRegex = RegExp(r"(?<=--audio-encoder=')(.*)(?=')");
  List<AudioEncoder> audioEncoder = [];

  final encoderInfo = res
      .toString()
      .splitLines()
      .where((i) => i.contains('--audio-codec='))
      .toList();

  for (final info in encoderInfo) {
    final codec = codecRegex.stringMatch(info);
    final encoder = encoderRegex.stringMatch(info);
    if (audioEncoder.where((e) => e.codec.contains(codec!)).isNotEmpty) {
      audioEncoder
          .firstWhere((e) => e.codec.contains(codec!))
          .encoder
          .add(encoder!);
    } else {
      audioEncoder.add(AudioEncoder(codec: codec!, encoder: [encoder!]));
    }
  }

  return audioEncoder;
}

List<ScrcpyDisplay> _getDisplays(String res) {
  RegExp idRegex = RegExp(r'(?<=--display-id=)\d+');
  RegExp resolutionRegex = RegExp(r'\d+x\d+');
  List<ScrcpyDisplay> displays = [];

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

  return displays;
}
