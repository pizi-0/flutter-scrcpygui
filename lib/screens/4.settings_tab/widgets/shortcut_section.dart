import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/models/settings_model/shortcut.dart';
import 'package:scrcpygui/models/tasks/task_type_ids.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/screens/4.settings_tab/widget_state/add_custom_shortcut_state.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/add_custom_shortcut_dialog.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/change_combination_dialog.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/keyboard_shortcuts.dart';
import 'package:scrcpygui/utils/keyboard_shortcut/shortcut_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../models/tasks/task_type.dart';
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
    final disabledShortcuts = ref.watch(disabledKeyboardShortcutProvider);

    return PgSectionCard(
      label: 'Keyboard Shortcuts',
      labelTrail: Row(
        spacing: 8,
        children: [
          IconButton.ghost(
            density: ButtonDensity.iconDense,
            icon: Icon(Icons.add_rounded),
            onPressed: () async {
              final res = await showDialog(
                context: context,
                builder: (context) => AddCustomShortcutDialog(),
              );

              ref.read(addShortcutDialogStateProvider.notifier).reset();

              if (res is HKEditResult) {
                final shortcut = res.shortcut;
                await ShortcutUtils.addShortcut(ref, shortcut);
              }
            },
          ),
          SizedBox(height: 10, child: VerticalDivider()),
          Switch(
            value: disabledShortcuts.length != shortcuts.length,
            onChanged: (value) {
              if (value) {
                for (var sc in shortcuts) {
                  ShortcutUtils.enableShortcut(ref, sc);
                }
              } else {
                for (var sc in shortcuts) {
                  ShortcutUtils.disableShortcut(ref, sc);
                }
              }
            },
          ),
        ],
      ),
      children: [
        ShortcutWidget(
          title: 'Start scrcpy',
          subtitle: 'Starts Default (Mirror) on currently selected device',
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
        .where((sc) => !defaultShortcuts.map((def) => def.id).contains(sc.id))
        .toList();

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        final shortcut = userDefinedShortcuts[index];
        return ShortcutWidget(shortcut: shortcut);
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

    final userDefined =
        !defaultShortcuts.map((def) => def.id).contains(widget.shortcut.id);

    return PgListTile(
      title: widget.title ?? _getCustomTitle(),
      dimTitle: disabled,
      subtitle: widget.subtitle ?? _getCustomSubtitle(),
      showSubtitle: true,
      trailing: KeyDisplay(shortcut: widget.shortcut, userDefined: userDefined),
      trailingConstraints: trailingConstraints,
    );
  }

  String _getCustomTitle() {
    final task = widget.shortcut.task;

    if (task.toRun.length > 1) {
      return 'Run tasks list';
    }

    switch (task.toRun.first.taskId) {
      case TaskId.startScrcpy:
        return 'Start scrcpy custom';
      case TaskId.stopScrcpy:
        return TaskId.stopScrcpy;

      default:
        return widget.shortcut.id;
    }
  }

  String _getCustomSubtitle() {
    final task = widget.shortcut.task;
    final allConfigs = ref.watch(configsProvider);
    final savedDevice = ref.watch(infoProvider);

    if (task.toRun.length > 1) {
      return 'Runs ${task.toRun.length} tasks';
    }

    switch (task.toRun.first.taskId) {
      case TaskId.startScrcpy:
        final toRun = task.toRun.first as StartScrcpyTask;
        final config =
            allConfigs.firstWhereOrNull((conf) => conf.id == toRun.configId) ??
                defaultMirror;

        final device =
            savedDevice.firstWhereOrNull((d) => d.serialNo == toRun.serialNo);

        return 'Starts [${config.configName}] on [${device?.deviceName ?? device?.serialNo ?? 'currently selected device'}]';
      case TaskId.stopScrcpy:
        return 'Stops scrcpy instances';

      default:
        return '';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      spacing: 8,
      children: [
        GhostButton(
          density: ButtonDensity.dense,
          onPressed: _modifyshortcut,
          onSecondaryTapDown: (details) {
            final data = ClipboardData(text: widget.shortcut.id);
            Clipboard.setData(data);
            showToast(
              showDuration: 1.5.seconds,
              context: context,
              location: ToastLocation.bottomCenter,
              builder: (context, overlay) => SurfaceCard(
                child: Basic(
                  title: Text('Copied shortcut ID to clipboard'),
                  trailing: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.lime,
                  ),
                ),
              ),
            );
          },
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
    final shortcut =
        defaultShortcuts.firstWhereOrNull((sc) => sc.id == widget.shortcut.id);

    if (shortcut != null) {
      if (shortcut.hotKey.isEqualTo(widget.shortcut.hotKey)) {
        return SizedBox.shrink();
      } else {
        return IconButton.ghost(
          icon: Icon(Icons.restore_rounded),
          onPressed: () => ShortcutUtils.resetShortcut(ref, widget.shortcut),
        );
      }
    } else {
      return IconButton.ghost(
        icon: Icon(Icons.delete_rounded),
        onPressed: () => ShortcutUtils.removeShortcut(ref, widget.shortcut),
      );
    }
  }

  Future<void> _modifyshortcut() async {
    dynamic res;

    if (widget.userDefined) {
      ref
          .read(addShortcutDialogStateProvider.notifier)
          .setShortcut(widget.shortcut);

      res = await showDialog(
        context: context,
        builder: (context) => ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
          child: AddCustomShortcutDialog(),
        ),
      );
      ref.read(addShortcutDialogStateProvider.notifier).reset();
    } else {
      res = await showDialog(
        context: context,
        builder: (context) => ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
          child: ChangeShortcutComb(shortcut: widget.shortcut),
        ),
      );
    }

    if (res is HKEditResult) {
      await ShortcutUtils.modifyShortcut(ref,
          newShortcut: res.shortcut, oldShortcut: widget.shortcut);

      if (res.isDisabled) {
        await ShortcutUtils.disableShortcut(ref, res.shortcut);
      } else {
        await ShortcutUtils.enableShortcut(ref, res.shortcut);
      }
    }
  }
}
