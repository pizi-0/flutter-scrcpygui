import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/providers/keyboard_shortcut_provider.dart';
import 'package:scrcpygui/utils/tasks_runner.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../db/db.dart';
import 'keyboard_shortcuts.dart';

// To prevent multiple shortcut actions running at the same time
bool running = false;

class ShortcutUtils {
  static Future<void> registerAllShortcuts(WidgetRef ref) async {
    await hotKeyManager.unregisterAll();

    final shortcuts = await _loadShortcutFromDb();
    final disabled = await Db.getDisabledShortcutIds();

    for (var s in shortcuts.where((sc) => !disabled.contains(sc.id))) {
      debugPrint('Registering hotkey: ${s.hotKey.toJson()}');
      await hotKeyManager.register(
        s.hotKey,
        keyDownHandler: (hotKey) => _getActionForHotkey(ref, s),
      );
    }

    ref.read(keyboardShortcutProvider.notifier).setShortcuts(shortcuts);
    ref
        .read(disabledKeyboardShortcutProvider.notifier)
        .setDisabledShortcut(disabled);
  }

  static Future<void> addShortcut(WidgetRef ref, Shortcut shortcut) async {
    debugPrint('Adding hotkey: ${shortcut.hotKey.toJson()}');
    await hotKeyManager.register(
      shortcut.hotKey,
      keyDownHandler: (hotKey) => _getActionForHotkey(ref, shortcut),
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

  static Future<void> disableShortcut(WidgetRef ref, Shortcut shortcut) async {
    debugPrint('Disabling hotkey: ${shortcut.hotKey.toJson()}');
    final registered = hotKeyManager.registeredHotKeyList;

    if (registered.contains(shortcut.hotKey)) {
      debugPrint('Unregistering hotkey: ${shortcut.hotKey.toJson()}');
      await hotKeyManager.unregister(shortcut.hotKey);
    }

    ref.read(disabledKeyboardShortcutProvider.notifier).add(shortcut.id);
    ref.read(keyboardShortcutProvider.notifier).modifyShortcut(shortcut);

    await Db.saveDisabledShortcutIds(
        ref.read(disabledKeyboardShortcutProvider));
    await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
  }

  static Future<void> enableShortcut(WidgetRef ref, Shortcut shortcut) async {
    debugPrint('Enabling hotkey: ${shortcut.hotKey.toJson()}');
    await hotKeyManager.register(shortcut.hotKey,
        keyDownHandler: (hotKey) => _getActionForHotkey(ref, shortcut));

    ref.read(disabledKeyboardShortcutProvider.notifier).remove(shortcut.id);
    ref.read(keyboardShortcutProvider.notifier).modifyShortcut(shortcut);

    await Db.saveDisabledShortcutIds(
        ref.read(disabledKeyboardShortcutProvider));
    await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
  }

  static Future<void> modifyShortcut(WidgetRef ref,
      {required Shortcut newShortcut, required Shortcut oldShortcut}) async {
    debugPrint(
        'Modifying hotkey: ${oldShortcut.hotKey.toJson()} to ${newShortcut.hotKey.toJson()}');

    final registered = hotKeyManager.registeredHotKeyList;

    final shouldUnregister = registered.contains(oldShortcut.hotKey);

    if (shouldUnregister) {
      debugPrint('Unregistering old hotkey: ${oldShortcut.hotKey.toJson()}');
      await hotKeyManager.unregister(ref
          .read(keyboardShortcutProvider)
          .firstWhere((sc) => sc.id == oldShortcut.id)
          .hotKey);
    }
  }

  static Future<void> resetShortcut(WidgetRef ref, Shortcut shortcut) async {
    final registered = hotKeyManager.registeredHotKeyList;

    final shouldUnregister = registered.contains(shortcut.hotKey);

    if (shouldUnregister) {
      await hotKeyManager.unregister(shortcut.hotKey);
    }

    final toReset =
        defaultShortcuts.firstWhereOrNull((def) => def.id == shortcut.id);

    if (toReset != null) {
      await hotKeyManager.register(
        toReset.hotKey,
        keyDownHandler: (hotKey) => _getActionForHotkey(ref, toReset),
      );

      ref.read(keyboardShortcutProvider.notifier).modifyShortcut(toReset);
      ref.read(disabledKeyboardShortcutProvider.notifier).remove(shortcut.id);
      await Db.saveShortcuts(ref.read(keyboardShortcutProvider));
      await Db.saveDisabledShortcutIds(
          ref.read(disabledKeyboardShortcutProvider));
    }
  }

  static Future<void> _getActionForHotkey(
      WidgetRef ref, Shortcut shortcut) async {
    if (!running) {
      running = true;
      await TasksRunner.runTask(ref, tasks: shortcut.task);
      running = false;
    }
  }

  static Future<List<Shortcut>> _loadShortcutFromDb() async {
    List<Shortcut> shortcuts = await Db.getShortcuts();
    return shortcuts;
  }
}
