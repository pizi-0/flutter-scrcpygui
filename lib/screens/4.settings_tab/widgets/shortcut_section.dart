import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/add_custom_shortcut_dialog.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/change_combination_dialog.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/keyboard_shortcuts.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/shortcut_actions_ids.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/shortcut_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../providers/adb_provider.dart';
import '../../../providers/config_provider.dart';
import '../../../providers/keyboard_shortcut_provider.dart';

class ShortcutSection extends ConsumerStatefulWidget {
  const ShortcutSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortcutSectionState();
}

class _ShortcutSectionState extends ConsumerState<ShortcutSection> {
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
        ShortcutWidget(
          title: 'Start scrcpy',
          subtitle: 'Starts scrcpy with the last used configuration',
          shortcut: shortcuts[0],
        ),
        Divider(),
        ShortcutWidget(
          title: 'Stop last scrcpy',
          subtitle: 'Stops the last running scrcpy instance',
          shortcut: shortcuts[1],
        ),
        if (shortcuts.length > defaultShortcuts.length) ...[
          Row(
            spacing: 16,
            children: [
              Expanded(child: Divider()),
              Text('Custom').xSmall,
              Expanded(child: Divider()),
            ],
          ),
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
        return ShortcutWidget(
          shortcut: shortcut,
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: userDefinedShortcuts.length,
    );
  }
}

class ShortcutWidget extends ConsumerStatefulWidget {
  final String? title;
  final String? subtitle;
  final Shortcut shortcut;

  const ShortcutWidget({
    super.key,
    this.title,
    this.subtitle,
    required this.shortcut,
  });

  @override
  ConsumerState<ShortcutWidget> createState() => _ShortcutWidgetState();
}

class _ShortcutWidgetState extends ConsumerState<ShortcutWidget> {
  BoxConstraints trailingConstraints =
      BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30);

  @override
  Widget build(BuildContext context) {
    final disabled = ref
        .watch(disabledKeyboardShortcutProvider)
        .contains(widget.shortcut.id);

    return PgListTile(
      title: _getCustomTitle(),
      dimTitle: disabled,
      subtitle: widget.subtitle,
      showSubtitle: true,
      trailing: KeyDisplay(shortcut: widget.shortcut),
      trailingConstraints: trailingConstraints,
    );
  }

  String _getCustomTitle() {
    switch (widget.shortcut.id) {
      case HK_START_CUSTOM_CONFIG:
        final connectedDevices = ref.read(adbProvider);
        final allConfigs = ref.read(configsProvider);

        final config = allConfigs.firstWhereOrNull(
            (config) => config.id == widget.shortcut.extra?.configId);
        final device = connectedDevices.firstWhereOrNull(
            (device) => device.id == widget.shortcut.extra?.deviceId);

        final info = ref
            .read(infoProvider)
            .firstWhereOrNull((info) => info.serialNo == device?.serialNo);

        return 'Start: ${config?.configName} on ${info?.deviceName}';

      default:
        return widget.title ?? '';
    }
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
    final theme = Theme.of(context);
    return Row(
      spacing: 8,
      children: [
        GhostButton(
          density: ButtonDensity.dense,
          onPressed: _modifyshortcut,
          child: Row(
            spacing: 2,
            children: [
              for (HotKeyModifier modifier
                  in widget.shortcut.hotKey.modifiers ?? [])
                OutlinedContainer(
                  borderRadius: theme.borderRadiusSm,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(modifier.name.capitalize).xSmall,
                ),
              OutlinedContainer(
                borderRadius: theme.borderRadiusSm,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(widget.shortcut.hotKey.physicalKey.keyLabel).xSmall,
              ),
            ],
          ),
        ),
        Spacer(),
        _trailingButton()
      ],
    );
  }

  Widget _trailingButton() {
    if (!widget.userDefined) {
      if (defaultShortcuts
          .where((def) => def.hotKey == widget.shortcut.hotKey)
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
    final res = await showDialog(
      context: context,
      builder: (context) => ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
        child: ChangeShortcutComb(shortcut: widget.shortcut),
      ),
    );

    if (res is HKEditResult) {
      await ShortcutUtils.modifyShortcut(ref,
          newShortcut: res.shortcut, oldShortcut: widget.shortcut);

      if (res.isDisabled) {
        await ShortcutUtils.disableShortcut(ref, res.shortcut);
      } else {
        final registered = hotKeyManager.registeredHotKeyList;

        if (!registered.contains(res.shortcut.hotKey)) {
          await ShortcutUtils.enableShortcut(ref, res.shortcut);
        }
      }
    }
  }
}
