// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/models/tasks/task_model.dart';
import 'package:scrcpygui/models/tasks/task_type_ids.dart';
import 'package:uuid/uuid.dart';

import '../../../models/tasks/task_type.dart';
import '../../../providers/adb_provider.dart';
import '../../../providers/config_provider.dart';
import '../../../utils/const.dart';

class AddShortcutDialogState {
  final int currentStep;
  final Shortcut shortcut;

  AddShortcutDialogState({
    required this.currentStep,
    required this.shortcut,
  });

  AddShortcutDialogState copyWith({
    Shortcut? shortcut,
    int? currentStep,
  }) {
    return AddShortcutDialogState(
      currentStep: currentStep ?? this.currentStep,
      shortcut: shortcut ?? this.shortcut,
    );
  }

  List<ToRun> get toRunList => shortcut.task.toRun;

  ScrcpyConfig? getConfig(WidgetRef ref) {
    final allConfigs = ref.watch(configsProvider);
    final config = allConfigs.firstWhere(
        (c) => c.id == (toRunList.first as StartScrcpyTask).configId,
        orElse: () => defaultMirror);
    return config;
  }

  AdbDevices? getDevice(WidgetRef ref) {
    final allDevices = ref.watch(adbProvider);

    final task = shortcut.task.toRun.first as StartScrcpyTask;

    final dev = allDevices.firstWhereOrNull((d) => d.serialNo == task.serialNo);

    return dev;
  }

  ConnectionPref getConnectionPref(WidgetRef ref) {
    final task = shortcut.task.toRun.first as StartScrcpyTask;

    final pref = (task.preferWireless ?? false)
        ? ConnectionPref.preferWireless
        : (task.preferWired ?? false)
            ? ConnectionPref.preferWired
            : ConnectionPref.noPreference;

    return pref;
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

class AddShortcutDialogStateNotifier extends Notifier<AddShortcutDialogState> {
  @override
  build() {
    return AddShortcutDialogState(
      currentStep: 0,
      shortcut: placeholderShortcut.copyWith(id: Uuid().v4()),
    );
  }

  void reset() {
    state = AddShortcutDialogState(
      currentStep: 0,
      shortcut: placeholderShortcut.copyWith(id: Uuid().v4()),
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void setShortcut(Shortcut shortcut) {
    state = state.copyWith(shortcut: shortcut);
  }

  void setToRunType(ToRun toRun) {
    state = state.copyWith(
        shortcut: state.shortcut.copyWith(task: Tasks(toRun: [toRun])));
  }

  void setConfig(ScrcpyConfig config) {
    final toRun = state.shortcut.task.toRun.first;

    switch (toRun.taskId) {
      case TaskId.startScrcpy:
        final t = toRun as StartScrcpyTask;
        state = state.copyWith(
            shortcut: state.shortcut.copyWith(
                task: state.shortcut.task.copyWith(
          toRun: [
            t.copyWith(
              configId: config.id,
              serialNo: t.serialNo,
              preferWireless: t.preferWireless,
              preferWired: t.preferWired,
            )
          ],
        )));

      default:
    }
  }

  void setDevice(AdbDevices? device) {
    final toRun = state.shortcut.task.toRun.first;

    switch (toRun.taskId) {
      case TaskId.startScrcpy:
        final t = toRun as StartScrcpyTask;
        StartScrcpyTask newT() {
          if (device == null) {
            return t.resetDevice();
          } else {
            return t.copyWith(
              configId: t.configId,
              serialNo: device.serialNo,
              preferWireless: t.preferWireless,
              preferWired: t.preferWired,
            );
          }
        }

        state = state.copyWith(
            shortcut: state.shortcut.copyWith(
                task: state.shortcut.task.copyWith(
          toRun: [newT()],
        )));

      default:
    }
  }

  void setHotkey(HotKey hotKey) {
    state = state.copyWith(shortcut: state.shortcut.copyWith(hotKey: hotKey));
  }

  void setConnectionPrefs(ConnectionPref pref) {
    final toRun = state.shortcut.task.toRun.first;

    switch (toRun.taskId) {
      case TaskId.startScrcpy:
        final t = toRun as StartScrcpyTask;

        state = state.copyWith(
            shortcut: state.shortcut.copyWith(
                task: state.shortcut.task.copyWith(toRun: [
          t.copyWith(
            preferWired: pref == ConnectionPref.preferWired,
            preferWireless: pref == ConnectionPref.preferWireless,
          )
        ])));

        break;
      default:
    }
  }
}

final addShortcutDialogStateProvider =
    NotifierProvider<AddShortcutDialogStateNotifier, AddShortcutDialogState>(
        () => AddShortcutDialogStateNotifier());

Shortcut placeholderShortcut = Shortcut(
  hotKey: HotKey(key: LogicalKeyboardKey.keyA),
  task: Tasks(
    toRun: [
      StartScrcpyTask(configId: defaultMirror.id),
    ],
  ),
);
