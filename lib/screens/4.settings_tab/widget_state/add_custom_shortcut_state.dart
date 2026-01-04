// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/models/tasks/task_model.dart';
import 'package:scrcpygui/models/tasks/task_type_ids.dart';
import 'package:scrcpygui/utils/const.dart';

import '../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../models/tasks/task_type.dart';

class AddShortcutDialogState {
  final List<ToRun>? toRuns;
  final AdbDevices? device;
  final ScrcpyConfig? config;
  final ToRun toRun;
  final int currentStep;
  final HotKey? hotKey;
  final ConnectionPref connectionPref;

  AddShortcutDialogState({
    this.device,
    this.config,
    this.toRuns,
    required this.toRun,
    required this.currentStep,
    this.hotKey,
    this.connectionPref = ConnectionPref.noPreference,
  });

  AddShortcutDialogState copyWith({
    AdbDevices? device,
    ScrcpyConfig? config,
    ToRun? toRun,
    List<ToRun>? toRuns,
    int? currentStep,
    HotKey? hotKey,
    ConnectionPref? connectionPref,
  }) {
    return AddShortcutDialogState(
      device: device,
      config: config ?? this.config,
      toRun: toRun ?? this.toRun,
      toRuns: toRuns ?? this.toRuns,
      currentStep: currentStep ?? this.currentStep,
      hotKey: hotKey ?? this.hotKey,
      connectionPref: connectionPref ?? this.connectionPref,
    );
  }
}

abstract interface class EnumWithString {
  final String name;

  const EnumWithString(this.name);
}

enum ConnectionPref implements EnumWithString {
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
      toRun: StartScrcpyTask(),
      toRuns: [],
      currentStep: 0,
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step, device: state.device);
  }

  void setToRun(ToRun toRun) {
    state = state.copyWith(
        toRun: toRun, device: null, config: defaultMirror, hotKey: null);
  }

  void setToRuns(List<ToRun> toRuns) {
    state = state.copyWith(toRuns: toRuns, device: null, hotKey: null);
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

extension BuildShortcutFromDialogState on AddShortcutDialogState {
  Shortcut? buildShortcut() {
    if (hotKey == null) return null;

    switch (toRun.taskId) {
      case TaskId.startScrcpy:
        final t = toRun as StartScrcpyTask;
        final task = Tasks(
          toRun: [
            t.copyWith(
                configId: config?.id,
                serialNo: device?.serialNo,
                preferWireless: connectionPref == ConnectionPref.preferWireless)
          ],
        );

        return Shortcut(hotKey: hotKey!, task: task);

      case TaskId.stopScrcpy:
        final t = toRun as StopScrcpyTask;
        final task = Tasks(
          toRun: [t.copyWith(deviceId: device?.serialNo)],
        );

        return Shortcut(hotKey: hotKey!, task: task);

      case TaskId.runTasksList:
        if (toRuns == null) return null;
        final task = Tasks(toRun: toRuns!);

        return Shortcut(hotKey: hotKey!, task: task);

      default:
        return null;
    }
  }
}
