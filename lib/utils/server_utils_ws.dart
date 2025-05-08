import 'dart:convert';
import 'dart:io';

import 'package:encrypt_decrypt_plus/encrypt_decrypt/xor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/companion_server/client_payload.dart';
import 'package:scrcpygui/models/companion_server/data/config_payload.dart';
import 'package:scrcpygui/models/companion_server/data/device_payload.dart';
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
        if (!authenticatedSockets.contains(socket)) {
          try {
            logger.i('Authenticating client: $clientAddress');
            // final expectedKey = ref.read(companionServerProvider).secret;
            // final receivedKey = XOR().xorDecode(utf8.decode(data));

            final expectedKey = 'pass';
            final receivedKey = 'pass';

            if (receivedKey != expectedKey) {
              logger.w('Authentication failed: $clientAddress');
              socket.write('Invalid API Key');
              await socket.close();
              return;
            } else {
              logger.i('Authentication successful: $clientAddress');
              authenticatedSockets.add(socket);
              final devices = ref.read(adbProvider);
              socket.write(ServerPayload(
                      type: ServerPayloadType.devices,
                      payload: jsonEncode(
                          devices.map((d) => d.toPayload()).toList()))
                  .toJson());

              final configs = ref.read(configsProvider);
              socket.write(
                ServerPayload(
                        type: ServerPayloadType.configs,
                        payload: jsonEncode(
                            configs.map((c) => c.toPayload()).toList()))
                    .toJson(),
              );

              final instances = ref.read(scrcpyInstanceProvider);
              socket.write(ServerPayload(
                      type: ServerPayloadType.runnings,
                      payload: jsonEncode(
                          instances.map((i) => i.toPayload()).toList()))
                  .toJson());

              final appConfigPairs = ref.read(appConfigPairProvider);
              socket.write(ServerPayload(
                      type: ServerPayloadType.pairs,
                      payload: jsonEncode(
                          appConfigPairs.map((p) => p.toPayload()).toList()))
                  .toJson());
            }
          } on Exception catch (e) {
            logger.w('Authentication failed: $clientAddress');
            socket.write(e);
            await socket.close();
            return;
          }
        }

        print(utf8.decode(data));

        // final payload = ClientPayload.fromJson(utf8.decode(data));
        // await _handleRequest(ref, socket: socket, payload: payload);
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
    await payload.toAction(ref);
  }

  startServer(WidgetRef ref) async {
    try {
      await _bindServer();

      serverSocket!.listen(
        (socket) => _onData(ref, socket),
        onDone: () => serverSocket!.close(),
        onError: (error) => logger.e('Server error', error: error.toString()),
        cancelOnError: true,
      );
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
