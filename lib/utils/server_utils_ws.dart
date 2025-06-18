import 'dart:convert';
import 'dart:io';

import 'package:encrypt_decrypt_plus/encrypt_decrypt/xor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/companion_server/client_payload.dart';
import 'package:scrcpygui/models/companion_server/data/auth_payload.dart';
import 'package:scrcpygui/models/companion_server/authenticated_client.dart';
import 'package:scrcpygui/models/companion_server/data/config_payload.dart';
import 'package:scrcpygui/models/companion_server/data/device_payload.dart';
import 'package:scrcpygui/models/companion_server/data/error_payload.dart';
import 'package:scrcpygui/models/companion_server/data/instance_payload.dart';
import 'package:scrcpygui/models/companion_server/data/pairs_payload.dart';
import 'package:scrcpygui/models/companion_server/server_payload.dart';
import 'package:scrcpygui/providers/companion_server_state_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:string_extensions/string_extensions.dart';

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
  Set<AuthdClient> authenticatedSockets = {};

  _bindServer(WidgetRef ref) async {
    try {
      final deviceIp = await _getDeviceIp();

      final companionSettings = ref.read(companionServerProvider);

      serverSocket = await ServerSocket.bind(
          deviceIp.address, companionSettings.port.toInt() ?? 8080);

      final ip = serverSocket?.address.address ?? '0.0.0.0';
      final port = serverSocket?.port.toString() ?? '8080';

      ref.read(companionServerStateProvider.notifier).setServerState(
        isRunning: true,
        ip: ip,
        port: port,
        clients: [],
      );

      logger.i('Server bound on $ip:$port');
    } on Exception catch (e) {
      logger.e('Failed to bind server', error: e.toString());
      ref
          .read(companionServerStateProvider.notifier)
          .setServerState(isRunning: false, ip: null, port: null, clients: []);
      rethrow;
    }
  }

  _onData(WidgetRef ref, Socket socket) {
    final clientAddress = socket.remoteAddress.address;
    logger.i('Client connected: $clientAddress');
    final blocklist = ref.read(companionServerProvider).blocklist;

    if (blocklist.where((b) => b.clientAddress == clientAddress).isNotEmpty) {
      logger.i('Client blocked: $clientAddress');

      socket.write(
        '${ServerPayload(type: ServerPayloadType.error, payload: ErrorPayload(type: ErrorType.blocked, message: 'You have been blocked.').toJson()).toJson()}\n',
      );

      socket.close();
      return;
    }

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
        authenticatedSockets
            .removeWhere((authd) => authd.clientAddress == clientAddress);

        ref
            .read(companionServerStateProvider.notifier)
            .setServerState(clients: authenticatedSockets.toList());
        logger.i('Client disconnected: $clientAddress');
      },
      onError: (error) {
        authenticatedSockets.removeWhere(
            (authd) => authd.socket.remoteAddress.address == clientAddress);

        ref
            .read(companionServerStateProvider.notifier)
            .setServerState(clients: authenticatedSockets.toList());

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
          payload: ErrorPayload(
                  type: ErrorType.request, message: e.toString().trim())
              .toJson(),
        ).toJson()}\n',
      );
    }
  }

  Future<bool> _authenticate(
      WidgetRef ref, Socket socket, List<int> data) async {
    final clientAddress = socket.remoteAddress.address;
    if (authenticatedSockets.where((authd) => authd.socket == socket).isEmpty) {
      try {
        final json = utf8.decode(data);

        final auth = AuthPayload.fromJson(json);

        logger.i('Authenticating client: $clientAddress');
        final expectedKey = ref.read(companionServerProvider).secret;
        final receivedKey = XOR().xorDecode(auth.apikey);

        // final expectedKey = 'pass';
        // final receivedKey = 'pass';

        if (receivedKey != expectedKey) {
          logger.w('Authentication failed: $clientAddress');
          socket.write(
              '${ServerPayload(type: ServerPayloadType.error, payload: ErrorPayload(message: 'Invalid API Key', type: ErrorType.invalidAuth).toJson()).toJson()}\n');
          await socket.close();
          return false;
        } else {
          logger.i('Authentication successful: $clientAddress');
          authenticatedSockets.add(AuthdClient(socket, auth));
          ref
              .read(companionServerStateProvider.notifier)
              .setServerState(clients: authenticatedSockets.toList());

          // Send initial data
          final devices = ref.read(adbProvider);
          final configs = ref.read(configsProvider);
          final instances = ref.read(scrcpyInstanceProvider);
          final appConfigPairs = ref.read(appConfigPairProvider);

          final initialData = jsonEncode([
            ServerPayload(
                type: ServerPayloadType.devices,
                payload:
                    jsonEncode(devices.map((d) => d.toPayload(ref)).toList())),
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
                payload:
                    jsonEncode(instances.map((r) => r.toPayload()).toList())),
          ]);

          socket.write(
            '${ServerPayload(type: ServerPayloadType.initialData, payload: initialData).toJson()}\n',
          );
        }
        return false;
      } on Exception catch (e) {
        logger.w('Authentication failed: $clientAddress', error: e);
        socket.write(
            '${ServerPayload(type: ServerPayloadType.error, payload: ErrorPayload(message: e.toString(), type: ErrorType.invalidAuth).toJson()).toJson()}\n');
        await socket.close();
        return false;
      }
    } else {
      return true;
    }
  }

  startServer(WidgetRef ref) async {
    try {
      await _bindServer(ref);

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
          for (final authd in authenticatedSockets) {
            authd.socket.write(
              '${ServerPayload(
                type: ServerPayloadType.devices,
                payload: jsonEncode(next.map((e) => e.toPayload(ref)).toList()),
              ).toJson()}\n',
            );
          }
        },
        fireImmediately: false,
      );

      ref.listenManual(
        configsProvider,
        (previous, next) {
          for (final authd in authenticatedSockets) {
            authd.socket.write(
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
          for (final authd in authenticatedSockets) {
            authd.socket.write(
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
          for (final authd in authenticatedSockets) {
            authd.socket.write(
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

      logger.i('Server started');
    } catch (e) {
      logger.e('Failed to start server', error: e.toString());
      await serverSocket?.close();
      ref.read(companionServerStateProvider.notifier).setServerState(
        isRunning: false,
        ip: null,
        port: null,
        clients: [],
      );

      authenticatedSockets.clear();
      rethrow;
    }
  }

  stopServer(WidgetRef ref) async {
    try {
      await serverSocket!.close();

      for (final authd in authenticatedSockets) {
        authd.socket.close();
      }

      authenticatedSockets.clear();

      ref.read(companionServerStateProvider.notifier).setServerState(
        isRunning: false,
        ip: null,
        port: null,
        clients: [],
      );
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
