import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_manager/config_manager.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/config_filter_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../db/db.dart';
import '../../../../../models/config_list_screen_state.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../../../../../widgets/custom_ui/pg_select.dart' as pg;
import '../../bottom_bar/widgets/config_combobox_item.dart';
import 'config_override_button.dart';
import 'connection_error_dialog.dart';
import 'config_list/config_list_header.dart';
import 'config_list/config_list_tile.dart';

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
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  child: ReorderableList(
                    itemBuilder: (context, index) {
                      return _reorderableConfigListTIle(index, filteredConfigs);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            spacing: reorder ? 8 : 0,
            children: [
              AnimatedContainer(
                duration: 100.milliseconds,
                width: reorder ? 20 : 0,
                child: FittedBox(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_indicator_rounded)),
                  ),
                ),
              ),
              Expanded(
                  child: ConfigListTile(
                      conf: reorder
                          ? reorderList[index]
                          : filteredConfigs[index])),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(),
        )
      ],
    );
  }

  void _onNewConfigPressed() {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final allDevices = ref.read(adbProvider);

    if (allDevices.isNotEmpty) {
      if (selectedDevice != null) {
        final newconfig = newConfig.copyWith(id: const Uuid().v4());
        ref.read(configScreenConfig.notifier).setConfig(newconfig);
        context.push('/home/config-settings');
      } else {
        ref.read(selectedDeviceProvider.notifier).state = allDevices.first;
        if (mounted) {
          _onNewConfigPressed();
        }
      }
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
