import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/add_custom_shortcut_dialog.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/change_combination_dialog.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/keyboard_shortcuts.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../providers/keyboard_shortcut_provider.dart';

class ShortcutSection extends ConsumerStatefulWidget {
  const ShortcutSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortcutSectionState();
}

class _ShortcutSectionState extends ConsumerState<ShortcutSection> {
  BoxConstraints trailingConstraints =
      BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30);

  @override
  Widget build(BuildContext context) {
    final shortcuts = ref.watch(keyboardShortcutProvider);

    return PgSectionCard(
      label: 'Keyboard Shortcuts',
      labelTrail: Row(
        spacing: 8,
        children: [
          IconButton.ghost(
            density: ButtonDensity.iconDense,
            icon: Icon(Icons.add_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddCustomShortcutDialog(),
              );
            },
          ),
          SizedBox(height: 10, child: VerticalDivider()),
          Switch(value: false, onChanged: (value) {}),
        ],
      ),
      children: [
        PgListTile(
          title: 'Start scrcpy',
          subtitle: 'Starts scrcpy with the last used configuration',
          showSubtitle: true,
          trailing: KeyDisplay(shortcut: shortcuts[0]),
          trailingConstraints: trailingConstraints,
        ),
        Divider(),
        PgListTile(
          title: 'Stop last scrcpy',
          subtitle: 'Stops the last running scrcpy instance',
          showSubtitle: true,
          trailing: KeyDisplay(shortcut: shortcuts[1]),
          trailingConstraints: trailingConstraints,
        ),
        if (shortcuts.length > 2) ...[
          Divider(),
          _buildUserDefinedShortcuts(shortcuts),
        ]
      ],
    );
  }

  Widget _buildUserDefinedShortcuts(List<Shortcut> shortcuts) {
    final userDefinedShortcuts = shortcuts
        .where((sc) =>
            defaultShortcuts.where((def) => def.hotKey == sc.hotKey).isEmpty)
        .toList();

    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final shortcut = userDefinedShortcuts[index];
          return PgListTile(
            title: 'Start: ${shortcut.id}',
            trailingConstraints: trailingConstraints,
            trailing: KeyDisplay(shortcut: shortcut, userDefined: true),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: userDefinedShortcuts.length);
  }
}

class KeyDisplay extends ConsumerStatefulWidget {
  final Shortcut shortcut;
  final bool userDefined;
  const KeyDisplay(
      {super.key, required this.shortcut, this.userDefined = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeyDisplayState();
}

class _KeyDisplayState extends ConsumerState<KeyDisplay> {
  HotKey? recorded;

  @override
  Widget build(BuildContext context) {
    final trigger = widget.shortcut.hotKey.logicalKey;
    final alt =
        widget.shortcut.hotKey.modifiers?.contains(HotKeyModifier.alt) ?? false;
    final control =
        widget.shortcut.hotKey.modifiers?.contains(HotKeyModifier.control) ??
            false;
    final meta =
        widget.shortcut.hotKey.modifiers?.contains(HotKeyModifier.meta) ??
            false;
    final shift =
        widget.shortcut.hotKey.modifiers?.contains(HotKeyModifier.shift) ??
            false;

    return Row(
      children: [
        Expanded(
          child: GhostButton(
            density: ButtonDensity.compact,
            onPressed: _modifyshortcut,
            child: KeyboardDisplay.fromActivator(
              activator: SingleActivator(
                trigger,
                alt: alt,
                control: control,
                meta: meta,
                shift: shift,
              ),
            ).xSmall,
          ),
        ),
        _trailingButton()
      ],
    );
  }

  Widget _trailingButton() {
    if (!widget.userDefined) {
      if (defaultShortcuts
          .where((def) => def.toJson() == widget.shortcut.toJson())
          .isEmpty) {
        return IconButton.ghost(
          density: ButtonDensity.iconDense,
          icon: Icon(Icons.restore).iconSmall(),
          onPressed: () => ShortcutUtils.resetShortcut(ref, widget.shortcut),
        );
      }

      return SizedBox.shrink();
    } else {
      return IconButton.ghost(
        density: ButtonDensity.iconDense,
        icon: Icon(Icons.delete_outline_rounded).iconSmall(),
        onPressed: () async {},
      );
    }
  }

  Future<void> _modifyshortcut() async {
    Shortcut? shortcut = await showDialog(
      context: context,
      builder: (context) => ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
        child: ChangeShortcutComb(shortcut: widget.shortcut),
      ),
    );

    if (shortcut != null) {
      ShortcutUtils.modifyShortcut(ref, shortcut);
    }
  }
}
