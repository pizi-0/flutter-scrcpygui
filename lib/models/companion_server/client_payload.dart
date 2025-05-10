// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrcpygui/utils/scrcpy_utils.dart';

import '../../providers/adb_provider.dart';
import '../../providers/app_config_pair_provider.dart';
import '../../providers/config_provider.dart';
import '../../providers/scrcpy_provider.dart';
import '../../providers/version_provider.dart';
import '../../utils/adb_utils.dart';

class ClientPayload {
  final ClientAction action;
  final String payload;

  ClientPayload({required this.action, required this.payload});

  Future<void> toAction(WidgetRef ref) async {
    switch (action) {
      case ClientAction.startScrcpy:
        await _startScrcpy(ref, payload);
        break;
      case ClientAction.startAppConfigPair:
        await _startAppConfigPair(ref, payload);
        break;
      case ClientAction.killScrcpy:
        await _killScrcpy(ref, payload);
        break;
      case ClientAction.connectDevice:
        await _connectDevice(ref, payload);
        break;
      case ClientAction.disconnectDevice:
        await _disconnectDevice(ref, payload);
        break;
    }
  }

  _startScrcpy(WidgetRef ref, String json) async {
    final deviceId = jsonDecode(json)['deviceId'];
    final configId = jsonDecode(json)['configId'];

    if (deviceId == null || configId == null) {
      throw Exception('Missing deviceId or configId');
    }

    final configMap = {for (var c in ref.read(configsProvider)) c.id: c};
    final deviceMap = {for (var d in ref.read(adbProvider)) d.id: d};

    final config = configMap[configId];
    final device = deviceMap[deviceId];

    if (config == null || device == null) {
      throw Exception('Config or device not found');
    }

    await ScrcpyUtils.newInstance(ref,
        selectedConfig: config, selectedDevice: device);
  }

  _startAppConfigPair(WidgetRef ref, String json) async {
    final hash = jsonDecode(json)['hash'];
    if (hash == null) {
      throw Exception('Missing hash');
    }

    final pair = ref
        .read(appConfigPairProvider)
        .firstWhereOrNull((pair) => pair.hashCode.toString() == hash);

    if (pair == null) {
      throw Exception('Pair not found');
    }

    final device = ref
        .read(adbProvider)
        .firstWhereOrNull((device) => device.id == pair.deviceId);
    if (device == null) {
      throw Exception('Device not found');
    }

    await ScrcpyUtils.newInstance(
      ref,
      selectedConfig: pair.config.copyWith(
          appOptions: (pair.config.appOptions).copyWith(selectedApp: pair.app)),
      selectedDevice: device,
      customInstanceName: '${pair.app.name} (${pair.config.configName})',
    );
  }

  _killScrcpy(WidgetRef ref, String json) async {
    final pid = jsonDecode(json)['pid'];
    if (pid == null) {
      throw Exception('Missing pid');
    }

    final instance = ref
        .read(scrcpyInstanceProvider)
        .firstWhereOrNull((instance) => instance.scrcpyPID == pid.toString());
    if (instance == null) {
      throw Exception('Instance not found');
    }

    await ScrcpyUtils.killServer(instance);
  }

  _connectDevice(WidgetRef ref, String json) async {
    final ip = jsonDecode(json)['ip'];
    if (ip == null) {
      throw Exception('Missing ip');
    }

    final res =
        await AdbUtils.connectWithIp(ref.read(execDirProvider), ipport: ip);

    if (!res.success) {
      throw Exception(res.errorMessage);
    }
  }

  _disconnectDevice(WidgetRef ref, String json) async {
    final deviceId = jsonDecode(json)['deviceId'];
    if (deviceId == null) {
      throw Exception('Missing deviceId');
    }

    final device = ref
        .read(adbProvider)
        .firstWhereOrNull((device) => device.id == deviceId);
    if (device == null) {
      throw Exception('Device not found');
    }

    await AdbUtils.disconnectWirelessDevice(ref.read(execDirProvider), device);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'action': ClientAction.values.indexOf(action).toString(),
      'payload': payload,
    };
  }

  factory ClientPayload.fromMap(Map<String, dynamic> map) {
    return ClientPayload(
      action: ClientAction.values[int.parse(map['action'] as String)],
      payload: map['payload'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientPayload.fromJson(String source) =>
      ClientPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum ClientAction {
  startScrcpy,
  startAppConfigPair,
  killScrcpy,
  connectDevice,
  disconnectDevice,
}
