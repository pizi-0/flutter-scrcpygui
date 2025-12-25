import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/keyboard_shortcut_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/shortcut_actions_ids.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../db/db.dart';
import '../../providers/adb_provider.dart';
import 'keyboard_shortcuts.dart';

bool running = false;

class ShortcutUtils {
  static Future<void> registerAllShortcuts(WidgetRef ref) async {
    await hotKeyManager.unregisterAll();

    final shortcuts = await _loadShortcutFromDb();

    for (var s in shortcuts) {
      debugPrint('Registering hotkey: ${s.hotKey.toJson()}');
      await hotKeyManager.register(
        s.hotKey,
        keyDownHandler: (hotKey) => _getActionForHotkey(ref, s),
      );
    }

    ref.read(keyboardShortcutProvider.notifier).setShortcuts(shortcuts);
  }

  static Future<void> addShortcut(WidgetRef ref, Shortcut shortcut) async {
    debugPrint('Adding hotkey: ${shortcut.hotKey.toJson()}');
    await hotKeyManager.register(
      shortcut.hotKey,
      keyDownHandler: (hotKey) async {
        await _getActionForHotkey(ref, shortcut);
      },
    );

    ref.read(keyboardShortcutProvider.notifier).addShortcut(shortcut);
    await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
  }

  static Future<void> removeShortcut(WidgetRef ref, Shortcut shortcut) async {
    debugPrint('Removing hotkey: ${shortcut.hotKey.toJson()}');
    await hotKeyManager.unregister(shortcut.hotKey);

    ref.read(keyboardShortcutProvider.notifier).removeShortcut(shortcut);
    await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
  }

  static Future<void> modifyShortcut(WidgetRef ref, Shortcut shortcut) async {
    debugPrint('Modifying hotkey: ${shortcut.hotKey.toJson()}');
    await hotKeyManager.unregister(ref
        .read(keyboardShortcutProvider)
        .firstWhere((sc) => sc.id == shortcut.id)
        .hotKey);

    await hotKeyManager.register(
      shortcut.hotKey,
      keyDownHandler: (hotKey) => _getActionForHotkey(ref, shortcut),
    );

    ref.read(keyboardShortcutProvider.notifier).modifyShortcut(shortcut);
    await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
  }

  static Future<void> resetShortcut(WidgetRef ref, Shortcut shortcut) async {
    await hotKeyManager.unregister(shortcut.hotKey);

    final toReset =
        defaultShortcuts.firstWhereOrNull((def) => def.id == shortcut.id);

    if (toReset != null) {
      await hotKeyManager.register(
        toReset.hotKey,
        keyDownHandler: (hotKey) => _getActionForHotkey(ref, toReset),
      );

      ref.read(keyboardShortcutProvider.notifier).modifyShortcut(toReset);
      await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
    }
  }

  static Future<void> _getActionForHotkey(
      WidgetRef ref, Shortcut shortcut) async {
    if (!running) {
      running = true;
      final connectedDevices = ref.read(adbProvider);
      final allConfigs = ref.read(configsProvider);
      final selectedDevice =
          ref.read(selectedDeviceProvider) ?? connectedDevices.firstOrNull;
      final selectedConfig = ref.read(selectedConfigProvider) ?? defaultMirror;

      switch (shortcut.hotKey.identifier) {
        case HK_START_SCRCPY:
          if (selectedDevice != null) {
            await ScrcpyUtils.newInstance(ref,
                selectedDevice: selectedDevice, selectedConfig: selectedConfig);
          }

        case HK_STOP_SCRCPY:
          final runningInstance = ref.read(scrcpyInstanceProvider);

          if (runningInstance.isNotEmpty) {
            await ScrcpyUtils.killServer(runningInstance.last);
          }
        case HK_START_CUSTOM_CONFIG:
          final customConfig = allConfigs.firstWhereOrNull(
              (config) => config.id == shortcut.extra?.configId);
          final customDevice = connectedDevices.firstWhereOrNull(
                  (device) => device.id == shortcut.extra?.deviceId) ??
              selectedDevice;

          if (customConfig != null) {
            await ScrcpyUtils.newInstance(ref,
                selectedDevice: customDevice, selectedConfig: customConfig);
          }

        default:
          null;
      }

      running = false;
    }
  }

  static Future<List<Shortcut>> _loadShortcutFromDb() async {
    List<Shortcut> shortcuts = await Db.getShortcuts();
    return shortcuts;
  }
}
