import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter/foundation.dart';
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
  final bool showCreateButton;
  final bool showConfigManagerButton;
  final bool showConfigFilterButton;
  final bool showOverrideButton;

  const ConfigListSmall(
      {super.key,
      this.showOverrideButton = true,
      this.showConfigManagerButton = true,
      this.showConfigFilterButton = true,
      this.showCreateButton = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfigListSmallState();
}

class ConfigListSmallState extends ConsumerState<ConfigListSmall> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(selectedConfigProvider);
    final overrides = ref.watch(configOverridesProvider);
    final hidden = ref.watch(hiddenConfigsProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    final filteredConfigs =
        ref.watch(filteredConfigsProvider).where((c) => !hidden.contains(c.id));

    return PgSectionCard(
      label: el.configLoc.label(count: '${filteredConfigs.length}'),
      labelButton: Row(
        children: [
          ConfigFilterButton(),
          if (widget.showConfigManagerButton)
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
                popupWidthConstraint: PopoverConstraint.intrinsic,
                key: configDropdownKey,
                onChanged: filteredConfigs.isEmpty
                    ? null
                    : (value) => ref
                        .read(selectedConfigProvider.notifier)
                        .state = value as ScrcpyConfig,
                filled: true,
                placeholder: Text(el.configLoc.empty),
                value: config,
                popup: SelectPopup.noVirtualization(
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
                  tooltip: widget.showOverrideButton
                      ? TooltipContainer(
                          child: Text('* Right click to start with overrides'),
                        ).call
                      : (context) => SizedBox.shrink(),
                  child: PrimaryButton(
                    onPressed: loading ? null : _start,
                    onSecondaryTapUp: (d) =>
                        loading || !widget.showOverrideButton
                            ? null
                            : _start(withOverrides: true),
                    onLongPressStart: (details) =>
                        loading || !widget.showOverrideButton
                            ? null
                            : _start(withOverrides: true),
                    child: loading
                        ? const CircularProgressIndicator().iconLarge()
                        : Text(
                            '${el.configLoc.start}${overrides.isNotEmpty && widget.showOverrideButton ? ' *' : ''}'),
                  ),
                ),
                if (widget.showOverrideButton) OverrideButton(),
              ],
            )
          ],
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
              ScrcpyUtils.handleOverrides(ref, overrides, selectedConfig);

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
  List<String> hidden = [];

  @override
  void initState() {
    final filteredConfigs = ref.read(filteredConfigsProvider);
    final hiddenConfigs = ref.read(hiddenConfigsProvider);

    reorderList = [...filteredConfigs];

    hidden = [...hiddenConfigs];

    ref.listenManual(
      filteredConfigsProvider,
      (previous, next) {
        final filteredConfigs = ref.read(filteredConfigsProvider);
        final hiddenConfigs = ref.read(hiddenConfigsProvider);

        reorderList = [...filteredConfigs];
        hidden = [...hiddenConfigs];

        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredConfigs = [
      ...ref.watch(filteredConfigsProvider).where((c) => !hidden.contains(c.id))
    ];

    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final edit = ref.watch(configListStateProvider).edit;

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
          ConfigListHeader(reordered: reorderList, hiddenList: hidden),
          Expanded(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  child: AnimatedSwitcher(
                    duration: 200.milliseconds,
                    child: filteredConfigs.isEmpty && !edit
                        ? Center(
                            child: Text(el.configLoc.empty).muted.textSmall,
                          )
                        : ReorderableList(
                            padding: EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final config = edit
                                  ? reorderList[index]
                                  : filteredConfigs.toList()[index];

                              return _reorderableConfigListTIle(config);
                            },
                            itemCount: edit
                                ? reorderList.length
                                : filteredConfigs.length,
                            onReorder: (oldIndex, newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item = reorderList.removeAt(oldIndex);
                              reorderList.insert(newIndex, item);
                              setState(() {});
                            },
                          ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reorderableConfigListTIle(ScrcpyConfig config) {
    final edit = ref.watch(configListStateProvider).edit;

    return Column(
      key: edit
          ? ValueKey(reorderList.firstWhere((c) => c.id == config.id).id)
          : ValueKey(config.id),
      spacing: 8,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            AnimatedSize(
              duration: 150.milliseconds,
              child: SizedBox(
                width: edit ? null : 0,
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: ReorderableDragStartListener(
                          index: reorderList.indexOf(config),
                          child:
                              Icon(Icons.drag_indicator_rounded).iconSmall()),
                    ),
                    IconButton.ghost(
                      onPressed: () {
                        if (hidden.contains(config.id)) {
                          hidden.remove(config.id);
                        } else {
                          hidden.add(config.id);
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        hidden.contains(config.id)
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: hidden.contains(config.id) ? Colors.red : null,
                      ).iconSmall(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ConfigListTile(
                showStartButton: !edit,
                conf: config,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: const Divider(),
        ),
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
