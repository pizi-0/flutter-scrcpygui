import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/models/tasks/task_model.dart';
import 'package:scrcpygui/models/tasks/task_type.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/shortcut_actions_ids.dart';

HotKey defaultStartScrcpyHotKey = HotKey(
  identifier: HK_START_SCRCPY,
  key: LogicalKeyboardKey.keyZ,
  modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
);

HotKey defaultStopScrcpyHotKey = HotKey(
  identifier: HK_STOP_SCRCPY,
  key: LogicalKeyboardKey.keyX,
  modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
);

List<Shortcut> defaultShortcuts = [
  Shortcut(
    id: HK_START_SCRCPY,
    hotKey: defaultStartScrcpyHotKey,
    task: Tasks(
      id: HK_START_SCRCPY,
      toRun: [
        StartScrcpyTask(),
      ],
    ),
  ),
  Shortcut(
    id: HK_STOP_SCRCPY,
    hotKey: defaultStopScrcpyHotKey,
    task: Tasks(
      id: HK_STOP_SCRCPY,
      toRun: [
        StopScrcpyTask(),
      ],
    ),
  )
];
