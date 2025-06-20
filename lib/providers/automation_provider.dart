import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/automation.dart';

class AutoConnectNotifier extends StateNotifier<List<ConnectAutomation>> {
  AutoConnectNotifier(super.state) {
    super.state = [];
  }

  void setList(List<ConnectAutomation> autoConnects) {
    state = autoConnects;
  }

  void add(ConnectAutomation data) {
    if (!state.contains(data)) {
      state = [...state, data];
    }
  }

  void remove(String deviceId) {
    state = [...state.where((e) => e.deviceIp != deviceId)];
  }
}

class AutoLaunchNotifier extends StateNotifier<List<ConfigAutomation>> {
  AutoLaunchNotifier(super.state) {
    super.state = [];
  }

  void setList(List<ConfigAutomation> autoLaunches) {
    state = autoLaunches;
  }

  void add(ConfigAutomation data) {
    if (!state.contains(data)) {
      state = [...state, data];
    }
  }

  void remove(String deviceId) {
    state = [...state.where((e) => e.deviceId != deviceId)];
  }
}

final autoConnectProvider =
    StateNotifierProvider<AutoConnectNotifier, List<ConnectAutomation>>(
        (ref) => AutoConnectNotifier([]));

final autoLaunchProvider =
    StateNotifierProvider<AutoLaunchNotifier, List<ConfigAutomation>>(
        (ref) => AutoLaunchNotifier([]));
