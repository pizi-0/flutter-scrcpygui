// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/utils/const.dart';

import '../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../models/tasks/task_type.dart';

class AddShortcutDialogState {
  final AdbDevices? device;
  final ScrcpyConfig? config;
  final TaskType taskType;
  final int currentStep;
  final HotKey? hotKey;
  final ConnectionPref connectionPref;

  AddShortcutDialogState({
    this.device,
    this.config,
    required this.taskType,
    required this.currentStep,
    this.hotKey,
    this.connectionPref = ConnectionPref.noPreference,
  });

  AddShortcutDialogState copyWith({
    AdbDevices? device,
    ScrcpyConfig? config,
    TaskType? taskType,
    int? currentStep,
    HotKey? hotKey,
    ConnectionPref? connectionPref,
  }) {
    return AddShortcutDialogState(
      device: device,
      config: config ?? this.config,
      taskType: taskType ?? this.taskType,
      currentStep: currentStep ?? this.currentStep,
      hotKey: hotKey ?? this.hotKey,
      connectionPref: connectionPref ?? this.connectionPref,
    );
  }
}

abstract interface class ConnectionPrefStringEnum {
  final String name;

  const ConnectionPrefStringEnum(this.name);
}

enum ConnectionPref implements ConnectionPrefStringEnum {
  noPreference('Any'),
  preferWireless('Prefer Wireless'),
  preferWired('Prefer Wired');

  @override
  final String name;

  const ConnectionPref(this.name);
}

class AddShortcutDialogStateNotifier
    extends AutoDisposeNotifier<AddShortcutDialogState> {
  @override
  build() {
    return AddShortcutDialogState(
      device: null,
      config: defaultMirror,
      taskType: StartScrcpyTask(),
      currentStep: 0,
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step, device: state.device);
  }

  void setTaskType(TaskType taskType) {
    state = state.copyWith(
        taskType: taskType, device: null, config: defaultMirror, hotKey: null);
  }

  void setConfig(ScrcpyConfig config) {
    state = state.copyWith(config: config, device: state.device);
  }

  void setDevice(AdbDevices? device) {
    state = state.copyWith(
      device: device,
      connectionPref:
          device == null ? ConnectionPref.noPreference : state.connectionPref,
    );
  }

  void setConnectionPref(ConnectionPref pref) {
    state = state.copyWith(device: state.device, connectionPref: pref);
  }

  void setHotKey(HotKey hotKey) {
    state = state.copyWith(hotKey: hotKey, device: state.device);
  }
}

final addShortcutDialogStateProvider = AutoDisposeNotifierProvider<
    AddShortcutDialogStateNotifier,
    AddShortcutDialogState>(() => AddShortcutDialogStateNotifier());
