/*
  [EXPERIMENTAL]
*/

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

import '../providers/adb_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../providers/version_provider.dart';

class ServerUtils {
  static Future<void> handleRequest(WidgetRef ref, HttpRequest request) async {
    final path = request.uri.path;
    final method = request.method;

    try {
      switch (method) {
        case 'GET':
          switch (path) {
            case '/devices':
              await _handleDevicesList(ref, request);
              break;

            case '/configs':
              await _handleConfigsList(ref, request);
              break;

            default:
              _notFound(request);
          }
          break;

        case 'POST':
          switch (path) {
            case '/disconnect':
              await _handleDisconnectDevices(ref, request);
              break;

            case '/scrcpy/start':
              await _handleScrcpyStart(ref, request);
              break;

            case '/scrcpy/stop':
              await _handleScrcpyStop(ref, request);
              break;

            default:
              _notFound(request);
          }

          break;

        default:
          request.response.statusCode = HttpStatus.methodNotAllowed;
      }
    } catch (e) {
      logger.e(e);
      request.response.statusCode = HttpStatus.internalServerError;
    } finally {
      await request.response.close();
    }
  }

  static _handleDevicesList(WidgetRef ref, HttpRequest request) async {
    final devices = ref.read(adbProvider);

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(devices));
  }

  static _handleDisconnectDevices(WidgetRef ref, HttpRequest request) async {
    final workDir = ref.read(execDirProvider);
    final devices = ref.read(adbProvider);
    final id = request.uri.queryParameters['id'];

    print(id);

    if (id == null) {
      request.response.statusCode = HttpStatus.badRequest;
      return;
    } else {
      final devMap = {for (var d in devices) d.id: d};
      final device = devMap[id];

      if (device == null) {
        request.response.statusCode = HttpStatus.notFound;
        return;
      } else {
        await AdbUtils.disconnectWirelessDevice(workDir, device);
        request.response.statusCode = HttpStatus.ok;
      }
    }
  }

  static _handleConfigsList(WidgetRef ref, HttpRequest request) async {
    final configs = ref.read(configsProvider);

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(configs));
  }

  static _handleScrcpyStart(WidgetRef ref, HttpRequest request) async {
    final devices = ref.read(adbProvider);
    final configs = ref.read(configsProvider);

    final deviceId = request.uri.queryParameters['deviceId'];
    final configId = request.uri.queryParameters['configId'];

    if (deviceId != null && configId != null) {
      final devMap = {for (var d in devices) d.id: d};
      final device = devMap[deviceId];

      final configMap = {for (var c in configs) c.id: c};
      final config = configMap[configId];

      if (device != null && config != null) {
        await ScrcpyUtils.newInstance(ref,
            selectedConfig: config, selectedDevice: device);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
    } else {
      request.response.statusCode = HttpStatus.badRequest;
    }
  }

  static _handleScrcpyStop(WidgetRef ref, HttpRequest request) async {
    final instances = ref.read(scrcpyInstanceProvider);
    final scrcpyPID = request.uri.queryParameters['scrcpyPID'];

    final instancesMap = {for (var i in instances) i.scrcpyPID: i};
    final instance = instancesMap[scrcpyPID];

    if (instance != null) {
      await ScrcpyUtils.killServer(instance);
      request.response.statusCode = HttpStatus.ok;
    } else {
      request.response.statusCode = HttpStatus.notFound;
    }
  }

  static void _notFound(HttpRequest request) {
    request.response.statusCode = HttpStatus.notFound;
    request.response.write(jsonEncode({'error': 'Not Found'}));
  }

  static Future<InternetAddress?> getDeviceIp() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list(
          includeLoopback: false, // Exclude 127.0.0.1
          type: InternetAddressType.IPv4 // Only interested in IPv4
          );
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLinkLocal) {
            logger.i(
                'Found suitable specific IP on ${interface.name}: ${addr.address}');
            return addr;
          }
        }
      }
      logger.w(
          'Could not find a suitable non-loopback IPv4 address. Falling back to anyIPv4.');

      return InternetAddress.anyIPv4;
    } catch (e, s) {
      logger.e('Error getting network interfaces/IP address:',
          error: e, stackTrace: s);
      return null;
    }
  }
}
