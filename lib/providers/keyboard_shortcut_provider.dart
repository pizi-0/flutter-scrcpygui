import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/keyboard_shortcuts.dart';

class KeyboardShortcutNotifier extends Notifier<List<Shortcut>> {
  @override
  build() {
    return defaultShortcuts;
  }

  void setShortcuts(List<Shortcut> shortcuts) {
    state = shortcuts;
  }

  void addShortcut(Shortcut newShortcut) {
    state = [...state, newShortcut];
  }

  void modifyShortcut(Shortcut newShortcut) {
    final index = state.indexWhere((sc) => sc.id == newShortcut.id);
    List<Shortcut> updatedList = List.from(state);

    if (index != -1) {
      updatedList.removeAt(index);
      updatedList.insert(index, newShortcut);
      state = updatedList;
    }
  }

  void removeShortcut(Shortcut shortcut) {
    state = state.where((sc) => sc.id != shortcut.id).toList();
  }
}

final keyboardShortcutProvider =
    NotifierProvider<KeyboardShortcutNotifier, List<Shortcut>>(
        () => KeyboardShortcutNotifier());
