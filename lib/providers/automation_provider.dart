import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/automation.dart';

class AutoConnectNotifier extends StateNotifier<List<ConnectAutomation>> {
  AutoConnectNotifier(super.state) {
    super.state = [];
  }

  setList(List<ConnectAutomation> autoConnects) {
    state = autoConnects;
  }

  add(ConnectAutomation data) {
    if (!state.contains(data)) {
      state = [...state, data];
    }
  }

  remove(String deviceId) {
    state = [...state.where((e) => e.deviceIp != deviceId)];
  }
}

class AutoLaunchNotifier extends StateNotifier<List<ConfigAutomation>> {
  AutoLaunchNotifier(super.state) {
    super.state = [];
  }

  setList(List<ConfigAutomation> autoLaunches) {
    state = autoLaunches;
  }

  add(ConfigAutomation data) {
    if (!state.contains(data)) {
      state = [...state, data];
    }
  }

  remove(String deviceId) {
    state = [...state.where((e) => e.deviceId != deviceId)];
  }
}

final autoConnectProvider =
    StateNotifierProvider<AutoConnectNotifier, List<ConnectAutomation>>(
        (ref) => AutoConnectNotifier([]));

final autoLaunchProvider =
    StateNotifierProvider<AutoLaunchNotifier, List<ConfigAutomation>>(
        (ref) => AutoLaunchNotifier([]));
