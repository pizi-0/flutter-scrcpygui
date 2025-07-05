import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart'
    show NumExtension, PaddingX;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_manager/config_manager.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/config_filter_button.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

import '../../../../../db/db.dart';
import '../../../../../models/config_list_screen_state.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/directory_utils.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../../../../../widgets/custom_ui/pg_select.dart' as pg;
import '../../bottom_bar/widgets/config_combobox_item.dart';
import '../../bottom_bar/widgets/config_delete_dialog.dart';
import '../../bottom_bar/widgets/config_detail_dialog.dart';
import 'config_override_button.dart';
import 'connection_error_dialog.dart';

final configDropdownKey = GlobalKey<pg.SelectState>();

// for isMobile
class ConfigListSmall extends ConsumerStatefulWidget {
  const ConfigListSmall({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfigListSmallState();
}

class ConfigListSmallState extends ConsumerState<ConfigListSmall> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(selectedConfigProvider);
    final overrides = ref.watch(configOverridesProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    final filteredConfigs = ref.watch(filteredConfigsProvider);

    return PgSectionCard(
      label: el.configLoc.label(count: '${filteredConfigs.length}'),
      labelButton: Row(
        children: [
          ConfigFilterButton(),
          Tooltip(
            tooltip:
                TooltipContainer(child: Text(el.configManagerLoc.title)).call,
            child: IconButton.ghost(
              icon: Icon(Icons.settings_rounded).iconSmall(),
              onPressed: () => context.go('/home/${ConfigManager.route}'),
            ),
          )
        ],
      ),
      labelTrail: IconButton.ghost(
        leading: Text(el.configLoc.new$),
        icon: const Icon(Icons.add),
        onPressed: _onNewConfigPressed,
      ),
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: pg.Select(
                key: configDropdownKey,
                onChanged: filteredConfigs.isEmpty
                    ? null
                    : (value) => ref
                        .read(selectedConfigProvider.notifier)
                        .state = value as ScrcpyConfig,
                filled: true,
                placeholder: Text(el.configLoc.empty),
                value: config,
                popup: SelectPopup(
                  items: SelectItemList(
                    children: filteredConfigs
                        .map((conf) => SelectItemButton(
                            value: conf,
                            child: IntrinsicHeight(
                                child: ConfigDropDownItem(config: conf))))
                        .toList(),
                  ),
                ).call,
                itemBuilder: (context, value) => Text(value.configName),
              ),
            ),
            ButtonGroup(
              children: [
                Tooltip(
                  tooltip: TooltipContainer(
                    child: Text('* Right click to start with overrides'),
                  ).call,
                  child: PrimaryButton(
                    onPressed: loading ? null : _start,
                    onSecondaryTapUp: (d) =>
                        loading ? null : _start(withOverrides: true),
                    onLongPressStart: (details) =>
                        loading ? null : _start(withOverrides: true),
                    child: loading
                        ? const CircularProgressIndicator().iconLarge()
                        : Text(
                            '${el.configLoc.start}${overrides.isNotEmpty ? ' *' : ''}'),
                  ),
                ),
                OverrideButton(),
              ],
            )
          ],
        )
      ],
    );
  }

  void _onNewConfigPressed() {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedDevice != null) {
      final newconfig = newConfig.copyWith(id: const Uuid().v4());
      ref.read(configScreenConfig.notifier).setConfig(newconfig);
      context.push('/home/config-settings');
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ErrorDialog(
            title: el.noDeviceDialogLoc.title,
            content: [Text(el.noDeviceDialogLoc.contentsNew)]),
      );
    }
  }

  Future<void> _start({bool withOverrides = false}) async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final selectedConfig = ref.read(selectedConfigProvider);
    final overrides = ref.read(configOverridesProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: Text(el.noConfigDialogLoc.title),
          content: Text(el.noConfigDialogLoc.contents),
          actions: [
            SecondaryButton(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      if (selectedDevice == null) {
        if (ref.read(adbProvider).length == 1) {
          ref.read(selectedDeviceProvider.notifier).state =
              ref.read(adbProvider).first;

          _start();
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => ErrorDialog(
              title: el.noDeviceDialogLoc.title,
              content: [
                Text(el.noDeviceDialogLoc.contentsStart),
              ],
            ),
          );
        }
      } else {
        loading = true;
        setState(() {});

        if (withOverrides) {
          final overridden =
              ScrcpyUtils.handleOverrides(overrides, selectedConfig);

          await ScrcpyUtils.newInstance(
            ref,
            selectedConfig: overridden,
            customInstanceName: selectedConfig.appOptions.selectedApp != null
                ? '${selectedConfig.appOptions.selectedApp!.name} (${selectedConfig.configName})'
                : '',
          );
        } else {
          await ScrcpyUtils.newInstance(
            ref,
            selectedConfig: selectedConfig,
            customInstanceName: selectedConfig.appOptions.selectedApp != null
                ? '${selectedConfig.appOptions.selectedApp!.name} (${selectedConfig.configName})'
                : '',
          );
        }

        await Db.saveLastUsedConfig(selectedConfig);

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    }
  }
}

// for isDesktop || isTablet
class ConfigListBig extends ConsumerStatefulWidget {
  const ConfigListBig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfigListBigState();
}

class ConfigListBigState extends ConsumerState<ConfigListBig> {
  bool loading = false;

  List<ScrcpyConfig> reorderList = [];

  @override
  Widget build(BuildContext context) {
    final filteredConfigs = ref.watch(filteredConfigsProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final reorder = ref.watch(configListStateProvider).reorder;

    reorderList = [...filteredConfigs];

    return PgSectionCardNoScroll(
      label: el.configLoc.label(count: '${filteredConfigs.length}'),
      expandContent: true,
      cardPadding: EdgeInsets.all(0),
      labelTrail: IconButton.ghost(
        density: ButtonDensity.dense,
        icon: const Icon(Icons.add),
        leading: Text(el.configLoc.new$),
        onPressed: _onNewConfigPressed,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          ConfigListHeader(reordered: reorderList),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: ReorderableList(
                      itemBuilder: (context, index) {
                        return _reorderableConfigListTIle(
                            index, filteredConfigs);
                      },
                      itemCount:
                          reorder ? reorderList.length : filteredConfigs.length,
                      onReorder: (oldIndex, newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = reorderList.removeAt(oldIndex);
                        reorderList.insert(newIndex, item);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reorderableConfigListTIle(
      int index, List<ScrcpyConfig> filteredConfigs) {
    final reorder = ref.watch(configListStateProvider).reorder;

    return Column(
      key: reorder
          ? ValueKey(reorderList[index].id)
          : ValueKey(filteredConfigs[index].id),
      spacing: 8,
      children: [
        Row(
          spacing: reorder ? 8 : 0,
          children: [
            AnimatedContainer(
              duration: 100.milliseconds,
              width: reorder ? 20 : 0,
              child: FittedBox(
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: ReorderableDragStartListener(
                      index: index, child: Icon(Icons.drag_indicator_rounded)),
                ),
              ),
            ),
            Expanded(
                child: ConfigListTile(
                    conf:
                        reorder ? reorderList[index] : filteredConfigs[index])),
          ],
        ),
        if (reorder && index != reorderList.length - 1) const Divider(),
        if (!reorder && index != filteredConfigs.length - 1) const Divider()
      ],
    );
  }

  void _onNewConfigPressed() {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedDevice != null) {
      final newconfig = newConfig.copyWith(id: const Uuid().v4());
      ref.read(configScreenConfig.notifier).setConfig(newconfig);
      context.push('/home/config-settings');
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ErrorDialog(
            title: el.noDeviceDialogLoc.title,
            content: [Text(el.noDeviceDialogLoc.contentsNew)]),
      );
    }
  }
}

class ConfigListHeader extends ConsumerStatefulWidget {
  final List<ScrcpyConfig> reordered;
  const ConfigListHeader({
    super.key,
    this.reordered = const [],
  });

  @override
  ConsumerState<ConfigListHeader> createState() => _ConfigListState();
}

class _ConfigListState extends ConsumerState<ConfigListHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = ref.watch(configTags);
    final headerState = ref.watch(configListStateProvider);
    final overrides = ref.watch(configOverridesProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.border,
          ),
        ),
        color: theme.colorScheme.border.withAlpha(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: headerState.isOpen ? 8 : 0,
          children: [
            ButtonGroup(
              children: [
                Button(
                  style: headerState.filtering
                      ? ButtonStyle.primary(density: ButtonDensity.dense)
                      : ButtonStyle.secondary(density: ButtonDensity.dense),
                  onPressed: () {
                    ref.read(configListStateProvider.notifier).state =
                        headerState.copyWith(
                            filtering: !headerState.filtering,
                            reorder: false,
                            override: false);
                  },
                  onSecondaryTapUp: (details) =>
                      ref.read(configTags.notifier).clearTag(),
                  child: tags.isNotEmpty
                      ? Text('Filter (${tags.length})')
                      : Text('Filter'),
                ),
                Button(
                  style: headerState.reorder
                      ? ButtonStyle.primary(density: ButtonDensity.dense)
                      : ButtonStyle.secondary(density: ButtonDensity.dense),
                  onPressed: () {
                    ref.read(configListStateProvider.notifier).state =
                        headerState.copyWith(
                            filtering: false,
                            reorder: !headerState.reorder,
                            override: false);

                    ref.read(configTags.notifier).clearTag();
                  },
                  child: Text(el.buttonLabelLoc.reorder),
                ),
                Button(
                  style: headerState.override
                      ? ButtonStyle.primary(density: ButtonDensity.dense)
                      : ButtonStyle.secondary(density: ButtonDensity.dense),
                  onPressed: () {
                    ref.read(configListStateProvider.notifier).state =
                        headerState.copyWith(
                            filtering: false,
                            reorder: false,
                            override: !headerState.override);
                  },
                  onSecondaryTapUp: (details) {
                    ref.read(configOverridesProvider.notifier).clearOverride();
                  },
                  child: overrides.isEmpty
                      ? Text('Override')
                      : Text('Override (${overrides.length})'),
                ),
              ],
            ),
            if (headerState.isOpen)
              ZoomIn(duration: 200.milliseconds, child: Divider()),
            AnimatedContainer(
              duration: 200.milliseconds,
              height: headerState.isOpen ? 25 : 0,
              child: AnimatedSwitcher(
                duration: 200.milliseconds,
                child: _switcherChild(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _switcherChild() {
    final headerState = ref.watch(configListStateProvider);
    final configs = ref.watch(configsProvider);

    switch (headerState) {
      case ConfigListState(filtering: true):
        return ConfigFilterButtonBig(key: const ValueKey('filter'));
      case ConfigListState(reorder: true):
        return Row(
          key: const ValueKey('reorder'),
          spacing: 8,
          children: [
            Chip(
              style: ButtonStyle.destructiveIcon(),
              child: Icon(Icons.close_rounded).iconSmall(),
              onPressed: () => ref
                  .read(configListStateProvider.notifier)
                  .state = headerState.copyWith(reorder: false),
            ),
            Chip(
              style: ButtonStyle.primary(),
              onPressed: () async {
                for (final conf in widget.reordered) {
                  ref.read(configsProvider.notifier).removeConfig(conf);
                  ref.read(configsProvider.notifier).addConfig(conf);
                }

                ref
                    .read(configListStateProvider.notifier)
                    .update((state) => state.copyWith(reorder: false));

                await Db.saveConfigs(ref.read(configsProvider));
              },
              child: Text(el.buttonLabelLoc.save).small,
            ),
          ],
        );
      case ConfigListState(override: true):
        return OverrideWidgets();
      default:
        return const SizedBox.shrink(key: ValueKey('empty'));
    }
  }
}

class ConfigListTile extends ConsumerStatefulWidget {
  final ScrcpyConfig conf;
  final bool showStartButton;
  const ConfigListTile(
      {super.key, required this.conf, this.showStartButton = true});

  @override
  ConsumerState<ConfigListTile> createState() => _ConfigListTileState();
}

class _ConfigListTileState extends ConsumerState<ConfigListTile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PgListTile(
      title: widget.conf.configName,
      trailing: widget.showStartButton
          ? Row(
              children: [
                IconButton.ghost(
                  onPressed: loading
                      ? null
                      : () {
                          ref.read(selectedConfigProvider.notifier).state =
                              widget.conf;
                          _start();
                        },
                  icon: loading
                      ? SizedBox.square(
                          dimension: 20,
                          child: Center(child: CircularProgressIndicator()))
                      : const Icon(Icons.play_arrow_rounded),
                ),
              ],
            )
          : null,
      content: OutlinedContainer(
        borderRadius: theme.borderRadiusSm,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              IconButton.ghost(
                size: ButtonSize.small,
                onPressed: () => _onDetailPressed(widget.conf),
                icon: const Icon(Icons.info_rounded),
              ),
              if (widget.conf.isRecording)
                const VerticalDivider(indent: 10, endIndent: 10),
              if (widget.conf.isRecording)
                IconButton.ghost(
                  size: ButtonSize.small,
                  onPressed: () =>
                      DirectoryUtils.openFolder(widget.conf.savePath!),
                  icon: const Icon(Icons.folder),
                ),
              if (!defaultConfigs.contains(widget.conf))
                const VerticalDivider(indent: 10, endIndent: 10),
              if (!defaultConfigs.contains(widget.conf))
                IconButton.ghost(
                  size: ButtonSize.small,
                  onPressed: () => _onEditPressed(widget.conf),
                  icon: const Icon(Icons.edit_rounded),
                ),
              if (!defaultConfigs.contains(widget.conf))
                const VerticalDivider(indent: 10, endIndent: 10),
              if (!defaultConfigs.contains(widget.conf))
                IconButton.ghost(
                  size: ButtonSize.small,
                  onPressed: () => _onRemoveConfigPressed(widget.conf),
                  icon: const Icon(Icons.delete_rounded),
                ),
            ],
          ),
        ),
      ).paddingOnly(top: 8),
    );
  }

  Future<void> _start() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final selectedConfig = ref.read(selectedConfigProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: Text(el.noConfigDialogLoc.title),
          content: Text(el.noConfigDialogLoc.contents),
          actions: [
            SecondaryButton(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      if (selectedDevice == null) {
        if (ref.read(adbProvider).length == 1) {
          ref.read(selectedDeviceProvider.notifier).state =
              ref.read(adbProvider).first;

          _start();
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => ErrorDialog(
              title: el.noDeviceDialogLoc.title,
              content: [
                Text(el.noDeviceDialogLoc.contentsStart),
              ],
            ),
          );
        }
      } else {
        loading = true;
        setState(() {});
        await ScrcpyUtils.newInstance(ref, selectedConfig: selectedConfig);
        await Db.saveLastUsedConfig(selectedConfig);

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    }
  }

  void _onDetailPressed(ScrcpyConfig config) {
    configDropdownKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: config),
    );
  }

  Future<void> _onRemoveConfigPressed(ScrcpyConfig config) async {
    configDropdownKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: config),
    );
  }

  void _onEditPressed(ScrcpyConfig config) {
    ref.read(selectedConfigProvider.notifier).state = config;
    configDropdownKey.currentState?.closePopup();

    if (ref.read(selectedDeviceProvider) == null) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(el.noDeviceDialogLoc.title),
          content: Text(
            el.noDeviceDialogLoc.contentsEdit,
            textAlign: TextAlign.start,
          ),
          actions: [
            SecondaryButton(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      ref.read(configScreenConfig.notifier).setConfig(config);
      context.push('/home/config-settings');
    }
  }
}

class OverrideWidgets extends ConsumerStatefulWidget {
  const OverrideWidgets({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverrideWidgetsState();
}

class _OverrideWidgetsState extends ConsumerState<OverrideWidgets> {
  @override
  Widget build(BuildContext context) {
    final overrides = ref.watch(configOverridesProvider);

    return Row(
      spacing: 4,
      children: [
        Chip(
          style: overrides.isNotEmpty
              ? ButtonStyle.destructiveIcon()
              : ButtonStyle.secondary(),
          onPressed: overrides.isEmpty
              ? null
              : () =>
                  ref.read(configOverridesProvider.notifier).clearOverride(),
          child: Icon(overrides.isEmpty ? BootstrapIcons.gear : Icons.clear)
              .iconSmall(),
        ),
        Gap(0, crossAxisExtent: 4),
        ...ScrcpyOverride.values.map(
          (e) => Chip(
            style: overrides.contains(e) ? ButtonStyle.primary() : null,
            onPressed: () =>
                ref.read(configOverridesProvider.notifier).toggleOverride(e),
            child: Text(e.name.capitalize).small,
          ),
        )
      ],
    );
  }
}
