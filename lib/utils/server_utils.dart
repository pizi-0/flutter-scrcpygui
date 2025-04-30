/*
  [EXPERIMENTAL]
*/

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/app_config_pair.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/server_settings_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

import '../providers/adb_provider.dart';
import '../providers/app_config_pair_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../providers/version_provider.dart';

class ServerUtils {
  static final ServerUtils _instance = ServerUtils._internal();

  factory ServerUtils() {
    return _instance;
  }

  ServerUtils._internal();

  HttpServer? _server;
  bool _isServerRunning = false;
  InternetAddress? _boundAddress;
  int? _boundPort;

  bool isServerRunning() => _isServerRunning;
  InternetAddress? get ipAddress => _boundAddress;
  int? get boundPort => _boundPort;

  String? get serverUrl => _boundAddress != null && _boundPort != null
      ? 'http://${_boundAddress!.address}:$_boundPort'
      : null;

  Future<bool> startServer(WidgetRef ref, {int port = 8080}) async {
    final ipAddress = await getDeviceIp();
    if (ipAddress == null) {
      logger.e('Failed to get IP address for server binding');
    }

    try {
      _server = await HttpServer.bind(ipAddress, port);
      _boundAddress = _server!.address;
      _boundPort = _server!.port;

      logger.i('HTTP Server listening on $serverUrl');
      _isServerRunning = true;

      _server!.listen(
        (HttpRequest request) =>
            ServerUtils.handleRequest(ref, request), // Use static handler
        onError: (e, s) {
          logger.e('Server listen error:', error: e, stackTrace: s);
          _isServerRunning = false;
          _server = null; // Clear instance on error
        },
        onDone: () {
          logger.i('HTTP Server stopped listening.');
          _isServerRunning = false;
          _server = null; // Clear instance when done
        },
        cancelOnError: true,
      );
      return true;
    } catch (e, s) {
      logger.e('Failed to bind or start HTTP server:', error: e, stackTrace: s);
      _isServerRunning = false;
      _server = null;
      return false;
    }
    // ...
  }

  Future<void> stop() async {
    if (!_isServerRunning && _server == null) {
      logger.w('Server stop requested but not running or already stopped.');
      return;
    }
    try {
      await _server?.close(force: true);
      logger.i('HTTP Server stopped successfully.');
    } catch (e, s) {
      logger.e('Error stopping HTTP server:', error: e, stackTrace: s);
    } finally {
      _server = null;
      _boundAddress = null;
      _boundPort = null;

      if (_isServerRunning) {
        _isServerRunning = false;
      }
    }
  }

  static Future<void> handleRequest(WidgetRef ref, HttpRequest request) async {
    final path = request.uri.path;
    final method = request.method;
    final query = request.uri.query;

    final expectedKey = ref.read(companionServerProvider).secret;
    final receivedKey = request.headers.value('x-api-key');

    logger.i(
        'Request received: $method $path $query. From ${request.connectionInfo?.remoteAddress.address}.');

    logger.t('API Key authentication required.');

    if (receivedKey == null || receivedKey != expectedKey) {
      logger.w(
          'Authentication failed: Invalid or missing API Key from ${request.connectionInfo?.remoteAddress.address}.');

      request.response.statusCode = HttpStatus.unauthorized;

      try {
        await request.response.close();
      } catch (_) {}
      return;
    }

    logger.t('API Key authentication successful.');

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

            case '/running':
              await _handleInstanceList(ref, request);
              break;

            case '/pinned-apps':
              await _handlePinnedAppsList(ref, request);
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

            case '/scrcpy/start/pinned-app':
              await _handlePinnedAppStart(ref, request);
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

  static _handleConfigsList(WidgetRef ref, HttpRequest request) async {
    final configs = ref.read(configsProvider);

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(configs));
  }

  static _handleInstanceList(WidgetRef ref, HttpRequest request) async {
    final instances = ref.read(scrcpyInstanceProvider);
    final query = request.uri.queryParameters;

    if (query['deviceId'] != null) {
      final deviceId = query['deviceId'];
      final List<Map<String, String>> result =
          instances.where((i) => i.device.id == deviceId).map((e) {
        return {
          'pid': e.scrcpyPID,
          'name': e.instanceName,
          'deviceId': e.device.id
        };
      }).toList();

      request.response
        ..statusCode = HttpStatus.ok
        ..write(jsonEncode(result));
      return;
    }

    final List<Map<String, String>> result = instances.map((i) {
      return {
        'pid': i.scrcpyPID,
        'name': i.instanceName,
        'device': i.device.id
      };
    }).toList();

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(result));
  }

  static _handlePinnedAppsList(WidgetRef ref, HttpRequest request) async {
    final appConfigPairs = ref.read(appConfigPairProvider);
    final configsList = ref.read(configsProvider);
    final configsMap = {for (var c in configsList) c.id: c};

    final query = request.uri.queryParameters;
    final deviceId = query['deviceId'];

    if (deviceId == null) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(jsonEncode({'error': 'Missing deviceId parameter'}));
      return;
    }

    final List<AppConfigPair> result = appConfigPairs
        .where((pair) =>
            pair.deviceId == deviceId && configsMap[pair.config.id] != null)
        .toList();

    final maps = result.map((pair) {
      return {'hashCode': pair.hashCode, ...pair.toMap()};
    }).toList();

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(maps));
  }

  static _handleDisconnectDevices(WidgetRef ref, HttpRequest request) async {
    final workDir = ref.read(execDirProvider);
    final devices = ref.read(adbProvider);
    final id = request.uri.queryParameters['id'];

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

  static _handlePinnedAppStart(WidgetRef ref, HttpRequest request) async {
    final devices = ref.read(adbProvider);
    final appConfigPairs = ref.read(appConfigPairProvider);
    final appConfigPairsMap = {
      for (var pair in appConfigPairs) pair.hashCode: pair
    };
    final query = request.uri.queryParameters;
    final pairHash = query['pair'];

    if (pairHash == null) {
      request.response.statusCode = HttpStatus.badRequest;
      return;
    }

    final pair = appConfigPairsMap[int.parse(pairHash)]!;
    final device = devices.firstWhereOrNull((d) => d.id == pair.deviceId);

    if (device != null) {
      await ScrcpyUtils.newInstance(ref,
          selectedConfig: pair.config.copyWith(
              appOptions:
                  (pair.config.appOptions).copyWith(selectedApp: pair.app)),
          selectedDevice: device);
    }
  }

  static _handleScrcpyStop(WidgetRef ref, HttpRequest request) async {
    final instances = ref.read(scrcpyInstanceProvider);
    final scrcpyPID = request.uri.queryParameters['pid'];

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
