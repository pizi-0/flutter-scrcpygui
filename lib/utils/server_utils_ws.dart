import 'dart:convert';
import 'dart:io';

import 'package:encrypt_decrypt_plus/encrypt_decrypt/xor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/companion_server/client_payload.dart';
import 'package:scrcpygui/models/companion_server/data/config_payload.dart';
import 'package:scrcpygui/models/companion_server/data/device_payload.dart';
import 'package:scrcpygui/models/companion_server/data/error_payload.dart';
import 'package:scrcpygui/models/companion_server/data/instance_payload.dart';
import 'package:scrcpygui/models/companion_server/data/pairs_payload.dart';
import 'package:scrcpygui/models/companion_server/server_payload.dart';
import 'package:scrcpygui/utils/const.dart';

import '../providers/adb_provider.dart';
import '../providers/app_config_pair_provider.dart';
import '../providers/config_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../providers/server_settings_provider.dart';

class ServerUtilsWs {
  static final ServerUtilsWs _instance = ServerUtilsWs._internal();

  factory ServerUtilsWs() {
    return _instance;
  }

  ServerUtilsWs._internal();

  ServerSocket? serverSocket;
  bool _isServerRunning = false;
  InternetAddress? _endpoint;
  int? _port;
  Set<Socket> authenticatedSockets = {};

  bool get isServerRunning => _isServerRunning;
  InternetAddress get endpoint => _endpoint ?? InternetAddress('0.0.0.0');
  int get port => _port ?? 8080;

  _bindServer() async {
    try {
      final deviceIp = await _getDeviceIp();

      serverSocket = await ServerSocket.bind(deviceIp.address, port);
      _endpoint = serverSocket!.address;
      _port = serverSocket!.port;

      logger.i('Server bound on ws://${endpoint.address}:$port');
    } on Exception catch (e) {
      logger.e('Failed to bind server', error: e.toString());
      _isServerRunning = false;
      rethrow;
    }
  }

  _onData(WidgetRef ref, Socket socket) {
    final clientAddress = socket.remoteAddress.address;
    logger.i('Client connected: $clientAddress');

    socket.listen(
      (data) async {
        final authd = await _authenticate(ref, socket, data);

        if (!authd) {
          return;
        }

        try {
          final payload = ClientPayload.fromJson(utf8.decode(data));
          await _handleRequest(ref, socket: socket, payload: payload);
        } on Exception catch (e) {
          logger.e('Error handling request: $e');
        }
      },
      onDone: () {
        authenticatedSockets.removeWhere((sock) =>
            sock.remoteAddress.address == socket.remoteAddress.address);
        logger.i('Client disconnected: $clientAddress');
      },
      onError: (error) {
        authenticatedSockets.removeWhere((sock) =>
            sock.remoteAddress.address == socket.remoteAddress.address);
        logger.e('Client error', error: error.toString());
      },
    );
  }

  _handleRequest(WidgetRef ref,
      {required Socket socket, required ClientPayload payload}) async {
    try {
      await payload.toAction(ref);
    } on Exception catch (e) {
      socket.write(
        '${ServerPayload(
          type: ServerPayloadType.error,
          payload: ErrorPayload(message: e.toString().trim()).toJson(),
        ).toJson()}\n',
      );
    }
  }

  Future<bool> _authenticate(
      WidgetRef ref, Socket socket, List<int> data) async {
    final clientAddress = socket.remoteAddress.address;
    if (!authenticatedSockets.contains(socket)) {
      try {
        logger.i('Authenticating client: $clientAddress');
        final expectedKey = ref.read(companionServerProvider).secret;
        final receivedKey = XOR().xorDecode(utf8.decode(data));

        // final expectedKey = 'pass';
        // final receivedKey = 'pass';

        if (receivedKey != expectedKey) {
          logger.w('Authentication failed: $clientAddress');
          socket.write('Invalid API Key');
          await socket.close();
          return false;
        } else {
          logger.i('Authentication successful: $clientAddress');
          authenticatedSockets.add(socket);

          // Send initial data
          final devices = ref.read(adbProvider);
          final configs = ref.read(configsProvider);
          final instances = ref.read(scrcpyInstanceProvider);
          final appConfigPairs = ref.read(appConfigPairProvider);

          final initialData = '${jsonEncode([
                ServerPayload(
                    type: ServerPayloadType.devices,
                    payload:
                        jsonEncode(devices.map((d) => d.toPayload()).toList())),
                ServerPayload(
                    type: ServerPayloadType.configs,
                    payload:
                        jsonEncode(configs.map((c) => c.toPayload()).toList())),
                ServerPayload(
                    type: ServerPayloadType.pairs,
                    payload: jsonEncode(
                        appConfigPairs.map((p) => p.toPayload()).toList())),
                ServerPayload(
                    type: ServerPayloadType.runnings,
                    payload: jsonEncode(
                        instances.map((r) => r.toPayload()).toList())),
              ])}\n';

          socket.write(
            ServerPayload(
                    type: ServerPayloadType.initialData, payload: initialData)
                .toJson(),
          );
        }
        return false;
      } on Exception catch (e) {
        logger.w('Authentication failed: $clientAddress');
        socket.write(e);
        await socket.close();
        return false;
      }
    } else {
      return true;
    }
  }

  startServer(WidgetRef ref) async {
    try {
      await _bindServer();

      serverSocket!.listen(
        (socket) => _onData(ref, socket),
        onDone: () => serverSocket!.close(),
        onError: (error) {
          serverSocket!.close();
          logger.e('Server error', error: error.toString());
        },
        cancelOnError: true,
      );

      ref.listenManual(
        adbProvider,
        (previous, next) {
          for (final sock in authenticatedSockets) {
            sock.write(
              '${ServerPayload(
                type: ServerPayloadType.devices,
                payload: jsonEncode(next.map((e) => e.toPayload()).toList()),
              ).toJson()}\n',
            );
          }
        },
        fireImmediately: false,
      );

      ref.listenManual(
        configsProvider,
        (previous, next) {
          for (final sock in authenticatedSockets) {
            sock.write(
              '${ServerPayload(
                type: ServerPayloadType.configs,
                payload: jsonEncode(next.map((e) => e.toPayload()).toList()),
              ).toJson()}\n',
            );
          }
        },
        fireImmediately: false,
      );

      ref.listenManual(
        appConfigPairProvider,
        (previous, next) {
          for (final sock in authenticatedSockets) {
            sock.write(
              '${ServerPayload(
                type: ServerPayloadType.pairs,
                payload: jsonEncode(next.map((e) => e.toPayload()).toList()),
              ).toJson()}\n',
            );
          }
        },
        fireImmediately: false,
      );

      ref.listenManual(
        scrcpyInstanceProvider,
        (previous, next) async {
          for (final sock in authenticatedSockets) {
            sock.write(
              '${ServerPayload(
                type: ServerPayloadType.runnings,
                payload: jsonEncode(next.map((e) => e.toPayload()).toList()),
              ).toJson()}\n',
            );
          }
        },
        fireImmediately: false,
        onError: (error, stackTrace) => logger.e(error),
      );

      _isServerRunning = true;
      logger.i('Server started');
    } catch (e) {
      logger.e('Failed to start server', error: e.toString());
      await serverSocket?.close();
      _isServerRunning = false;
      _endpoint = null;
      _port = null;
      authenticatedSockets.clear();
    }
  }

  stopServer() async {
    try {
      await serverSocket!.close();
      _isServerRunning = false;
      _endpoint = null;
      _port = null;

      for (final sock in authenticatedSockets) {
        sock.close();
      }

      authenticatedSockets.clear();
    } catch (e) {
      logger.e('Failed to stop server', error: e.toString());
    }
  }
}

Future<InternetAddress> _getDeviceIp() async {
  List<NetworkInterface> interfaces =
      await NetworkInterface.list(type: InternetAddressType.IPv4);

  for (final interface in interfaces) {
    for (final address in interface.addresses) {
      if (address.type == InternetAddressType.IPv4 && !address.isLinkLocal) {
        logger.i('Device IP: ${address.address}');
        return address;
      }
    }
  }

  throw Exception('No IPv4 address found');
}
