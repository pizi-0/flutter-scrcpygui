import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter/material.dart' show kToolbarHeight;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/pinned_app_display.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:scrcpygui/widgets/navigation_shell.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../db/db.dart';
import '../../../../models/app_config_pair.dart';
import '../../../../models/device_key.dart';
import '../../../../providers/app_config_pair_provider.dart';
import '../../../../providers/version_provider.dart';
import '../../../../utils/scrcpy_utils.dart';

class DeviceControlPage extends ConsumerStatefulWidget {
  static const route = 'device-control';
  final AdbDevices device;
  const DeviceControlPage({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends ConsumerState<DeviceControlPage> {
  final FocusNode klNode = FocusNode(debugLabel: 'keyboard-listener');
  final FocusNode appSearchNode = FocusNode(debugLabel: 'app-search');
  TextEditingController appSearchController = TextEditingController();
  ScrollController appScroller = ScrollController();
  bool appScrollerAtTop = false;

  ScrcpyConfig? config;

  @override
  void initState() {
    super.initState();
    appScroller.addListener(() {
      appScrollerAtTop = appScroller.offset == 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    return KeyboardListener(
      focusNode: klNode,
      autofocus: true,
      onKeyEvent: (value) async {
        if (value.physicalKey == PhysicalKeyboardKey.slash) {
          if (!appSearchNode.hasFocus) {
            await Future.delayed(100.milliseconds);
            appSearchNode.requestFocus();
          }
        }

        if (value.physicalKey == PhysicalKeyboardKey.escape) {
          klNode.requestFocus();
        }
      },
      child: GestureDetector(
        onTap: () => klNode.requestFocus(),
        child: PgScaffoldCustom(
          onBack: context.pop,
          title: 'Lounge / ${device.name}',
          scaffoldBody: ResponsiveBuilder(
            builder: (context, sizingInfo) {
              double sidebarWidth = 52;

              if (sizingInfo.isTablet || sizingInfo.isDesktop) {
                sidebarWidth = _findSidebarWidth();
              }

              if (sizingInfo.isMobile) {
                sidebarWidth = 52;
              }
              bool wrapped = sizingInfo.screenSize.width >= ((appWidth * 2) + sidebarWidth + 40);

              if (!wrapped) {
                return SmallControlPage(device: device);
              } else {
                return BigControlPage(device: device);
              }
            },
          ),
        ),
      ),
    );
  }

  _findSidebarWidth() {
    final box = sidebarKey.currentContext?.findRenderObject();

    if (box != null) {
      return (box as RenderBox).size.width;
    } else {
      return 0;
    }
  }
}

class BigControlPage extends ConsumerStatefulWidget {
  final AdbDevices device;
  const BigControlPage({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BigControlPageState();
}

class _BigControlPageState extends ConsumerState<BigControlPage> {
  ScrcpyConfig? config;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final device = widget.device;
    final allConfigs = ref.watch(configsProvider);
    final appsList = device.info?.appList ?? [];
    appsList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          height: size.height - kToolbarHeight - 32,
          width: appWidth,
          child: _leftColumn(device),
        ),
        SizedBox(
          height: size.height - kToolbarHeight - 32,
          width: appWidth,
          child: PgSectionCardNoScroll(
            label: 'All apps',
            content: SizedBox(
              height: size.height - kToolbarHeight - 32 - 112,
              width: appWidth,
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Select<ScrcpyConfig>(
                          placeholder: Text('Config to start app on'),
                          value: config,
                          onChanged: (value) {
                            config = value;
                            setState(() {});
                          },
                          popup: SelectPopup(
                            items: SelectItemList(
                                children: allConfigs
                                    .map((c) => SelectItemButton(value: c, child: Text(c.configName)))
                                    .toList()),
                          ).call,
                          itemBuilder: (context, value) => Text(value.configName),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: appsList
                            .map((app) => AppListTile(
                                  app: app,
                                  config: config,
                                ))
                            .toList(),
                      ).separator(Divider()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _leftColumn(AdbDevices device) {
    return Column(
      spacing: 8,
      children: [
        ButtonControls(device: device),
        PgSectionCardNoScroll(label: 'Pinned apps', content: PinnedAppDisplay(device: device)),
      ],
    );
  }
}

class AppListTile extends StatefulWidget {
  final ScrcpyApp app;
  final ScrcpyConfig? config;

  const AppListTile({
    super.key,
    required this.app,
    required this.config,
  });

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final config = widget.config;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PgListTile(
        title: app.name,
        subtitle: app.packageName,
        showSubtitle: true,
        trailing: Row(
          children: [
            IconButton.ghost(icon: Icon(Icons.push_pin_rounded), onPressed: config == null ? null : () {}),
            IconButton.ghost(icon: Icon(Icons.play_arrow_rounded), onPressed: config == null ? null : () {}),
          ],
        ),
      ),
    );
  }
}

class SmallControlPage extends ConsumerStatefulWidget {
  const SmallControlPage({
    super.key,
    required this.device,
  });

  final AdbDevices device;

  @override
  ConsumerState<SmallControlPage> createState() => _SmallControlPageState();
}

class _SmallControlPageState extends ConsumerState<SmallControlPage> {
  ScrcpyApp? selectedApp;
  ScrcpyConfig? selectedConfig;
  bool loading = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appsList = widget.device.info?.appList ?? [];
    final allconfigs = ref.watch(configsProvider);
    final appConfigPairs =
        ref.watch(appConfigPairProvider.select((pair) => pair.where((p) => p.deviceId == widget.device.id)));

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        spacing: 8,
        children: [
          ButtonControls(device: widget.device),
          PgSectionCardNoScroll(label: 'Pinned apps', content: PinnedAppDisplay(device: widget.device)),
          PgSectionCard(
            label: el.appSection.title,
            children: [
              Text('${el.configLoc.start}:'),
              Select(
                filled: true,
                value: selectedApp,
                placeholder: Text(el.appSection.select.label),
                popupConstraints: BoxConstraints(maxHeight: appWidth - 100),
                onChanged: (app) {
                  selectedApp = app!;
                  setState(() {});
                },
                popup: SelectPopup.builder(
                  searchPlaceholder: Text('Search'),
                  builder: (context, searchQuery) {
                    return SelectItemList(
                      children: appsList
                          .where((app) => app.name.toLowerCase().contains(searchQuery?.toLowerCase() ?? ''))
                          .map((e) => SelectItemButton(value: e, child: Text(e.name)))
                          .toList(),
                    );
                  },
                ).call,
                itemBuilder: (context, value) => Text(value.name),
              ),
              Text('${el.deviceControlDialogLoc.onConfig.label}:'),
              Select(
                filled: true,
                itemBuilder: (context, value) => Text(value.configName),
                onChanged: selectedApp == null
                    ? null
                    : (config) {
                        selectedConfig = config as ScrcpyConfig?;

                        setState(() {});
                      },
                placeholder: Text(el.deviceControlDialogLoc.onConfig.ddPlaceholder),
                value: selectedConfig,
                popup: SelectPopup(
                  items: SelectItemList(
                    children: allconfigs
                        .where((e) => !e.windowOptions.noWindow)
                        .map((config) => SelectItemButton(
                              value: config,
                              child: Text(config.configName),
                            ))
                        .toList(),
                  ),
                ).call,
              ),
              if (selectedApp != null && selectedConfig != null && appConfigPairs.length < 6) Divider(),
              Row(
                spacing: 8,
                children: [
                  if (selectedApp != null && selectedConfig != null && appConfigPairs.length < 6)
                    Tooltip(
                      tooltip: const TooltipContainer(child: Text('Pin app/config pair')).call,
                      child: IconButton(
                        density: ButtonDensity.icon,
                        variance: ButtonVariance.secondary,
                        icon: Icon(Icons.push_pin).iconSmall(),
                        onPressed: () {
                          final pair =
                              AppConfigPair(deviceId: widget.device.id, app: selectedApp!, config: selectedConfig!);
                          ref.read(appConfigPairProvider.notifier).addOrEditPair(pair);
                          Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
                        },
                      ),
                    ),
                  Spacer(),
                  if (selectedApp != null && selectedConfig != null)
                    PrimaryButton(
                      onPressed: loading
                          ? null
                          : () async {
                              loading = true;
                              setState(() {});
                              await ScrcpyUtils.newInstance(
                                ref,
                                selectedDevice: widget.device,
                                selectedConfig: selectedConfig!.copyWith(
                                  appOptions: (selectedConfig!.appOptions).copyWith(selectedApp: selectedApp),
                                ),
                                customInstanceName: '${selectedApp!.name} (${selectedConfig!.configName})',
                              );

                              if (mounted) {
                                loading = false;
                                setState(() {});
                              }
                            },
                      child: loading ? CircularProgressIndicator() : Text(el.configLoc.start),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonControls extends ConsumerStatefulWidget {
  final AdbDevices device;
  const ButtonControls({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ButtonControlsState();
}

class _ButtonControlsState extends ConsumerState<ButtonControls> {
  @override
  Widget build(BuildContext context) {
    return PgSectionCardNoScroll(
      label: 'Controls',
      content: FittedBox(
        child: Row(
          spacing: 8,
          children: _buttonList(),
        ),
      ),
    );
  }

  _buttonList() {
    final workDir = ref.read(execDirProvider);
    return [
      DestructiveButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.power_settings_new_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.power),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.back),
        child: const Icon(Icons.arrow_back_rounded),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.home_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.home),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.history_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.recent),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.skip_previous_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.mediaPrevious),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.play_arrow_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.playPause),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.skip_next_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.mediaNext),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.volume_down_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.volumeDown),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.volume_up_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.volumeUp),
      ),
    ];
  }
}
