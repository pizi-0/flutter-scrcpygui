import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/config_override_button.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../db/db.dart';
import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/app_config_pair_provider.dart';
import '../../../../../providers/app_grid_settings_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../providers/device_info_provider.dart';
import '../../../../../providers/missing_icon_provider.dart';
import '../../../../../providers/version_provider.dart';
import '../../../../../utils/command_runner.dart';
import '../device_control_page.dart';
import 'app_grid_icon.dart';
import 'big_control_page.dart';

class AppGrid extends ConsumerStatefulWidget {
  final AdbDevices device;

  final ScrollController? scrollController;
  const AppGrid({super.key, required this.device, this.scrollController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppGridState();
}

class _AppGridState extends ConsumerState<AppGrid> {
  TextEditingController appSearchController = TextEditingController();
  ScrollController appScrollController = ScrollController();
  bool gettingApp = false;

  @override
  void initState() {
    appSearchController.addListener(updateList);
    ref.listenManual(
      missingIconProvider,
      (previous, next) {
        if (next.isEmpty) {
          ref.read(showMissingIconProvider.notifier).state = false;
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    appScrollController.dispose();
    appSearchController.dispose();
    appSearchController.removeListener(updateList);
    super.dispose();
  }

  void updateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final device = widget.device;
    final overrides = ref.watch(configOverridesProvider);
    final gridSettings = ref.watch(appGridSettingsProvider);

    final devicePairs = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == device.serialNo)
        .toList();

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhere((info) => info.serialNo == device.serialNo);

    final appsList = deviceInfo.appList
        .where((app) => devicePairs.where((dp) => dp.app == app).isEmpty)
        .toList();

    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    devicePairs.sort(
        (a, b) => a.app.name.toLowerCase().compareTo(b.app.name.toLowerCase()));

    final deviceAppslist = devicePairs.map((p) => p.app).toList();

    final filteredDeviceAppslist = deviceAppslist
        .where((app) =>
            app.name
                .toLowerCase()
                .contains(appSearchController.text.toLowerCase()) ||
            app.packageName
                .toLowerCase()
                .contains(appSearchController.text.toLowerCase()))
        .toList();

    final filteredAppslist = appsList
        .where((app) =>
            app.name
                .toLowerCase()
                .contains(appSearchController.text.toLowerCase()) ||
            app.packageName
                .toLowerCase()
                .contains(appSearchController.text.toLowerCase()))
        .toList();

    final missingIcons = ref.watch(missingIconProvider);
    final showMissingIcon = ref.watch(showMissingIconProvider);

    return PgSectionCardNoScroll(
      cardPadding: EdgeInsets.zero,
      label: el.loungeLoc.launcher.label,
      labelButton: IconButton.ghost(
        enabled: !gettingApp,
        onPressed: _onRefreshApp,
        density: ButtonDensity.iconDense,
        icon: Icon(Icons.refresh_rounded),
      ),
      labelTrail: OverrideButton(
        buttonVariance: overrides.isNotEmpty
            ? ButtonStyle.primaryIcon(density: ButtonDensity.iconDense)
            : ButtonStyle.ghostIcon(density: ButtonDensity.iconDense),
      ),
      expandContent: true,
      content: Stack(
        children: [
          gettingApp
              ? Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : CustomScrollView(
                  controller: widget.scrollController ?? appScrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(8, 90, 8, 8),
                    ),
                    if (filteredAppslist.isEmpty &&
                        filteredDeviceAppslist.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                            child: Text(el.loungeLoc.info.emptySearch)
                                .textSmall
                                .muted),
                      ),
                    if (showMissingIcon) ...[
                      SliverPadding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.muted,
                                borderRadius: theme.borderRadiusSm,
                              ),
                              child: Text(el.loungeLoc.appTile.missingIcon(
                                      count: '${missingIcons.length}'))
                                  .textSmall),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                        sliver: SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: gridSettings.gridExtent,
                            mainAxisExtent: gridSettings.gridExtent,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: missingIcons.length,
                          itemBuilder: (context, index) {
                            final app = missingIcons[index];

                            return AppGridIcon(
                                key: ValueKey(app.packageName),
                                app: app,
                                device: widget.device);
                          },
                        ),
                      )
                    ] else ...[
                      if (filteredDeviceAppslist.isNotEmpty) ...[
                        SliverPadding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                          sliver: SliverToBoxAdapter(
                            child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.muted,
                                  borderRadius: theme.borderRadiusSm,
                                ),
                                child:
                                    Text(el.loungeLoc.appTile.sections.pinned)
                                        .textSmall),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: gridSettings.gridExtent,
                              mainAxisExtent: gridSettings.gridExtent,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: filteredDeviceAppslist.length,
                            itemBuilder: (context, index) {
                              final app = filteredDeviceAppslist[index];

                              return AppGridIcon(
                                  key: ValueKey(app.packageName),
                                  app: app,
                                  device: widget.device);
                            },
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                        ),
                      ],
                      if (filteredAppslist.isNotEmpty) ...[
                        if (deviceAppslist.isNotEmpty)
                          SliverPadding(
                            padding:
                                EdgeInsetsGeometry.symmetric(horizontal: 8),
                            sliver: SliverToBoxAdapter(
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.muted,
                                    borderRadius: theme.borderRadiusSm,
                                  ),
                                  child:
                                      Text(el.loungeLoc.appTile.sections.apps)
                                          .textSmall),
                            ),
                          ),
                        SliverPadding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: gridSettings.gridExtent,
                              mainAxisExtent: gridSettings.gridExtent,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: filteredAppslist.length,
                            itemBuilder: (context, index) {
                              final app = filteredAppslist[index];

                              return AppGridIcon(
                                  key: ValueKey(app.packageName),
                                  app: app,
                                  device: widget.device);
                            },
                          ),
                        )
                      ]
                    ]
                  ],
                ),
          AppGridHeader(
            appSearchController: appSearchController,
          ),
        ],
      ),
    );
  }

  Future<void> _onRefreshApp() async {
    gettingApp = true;
    setState(() {});

    var dev = widget.device;
    final workDir = ref.read(execDirProvider);
    var deviceInfo = ref
        .read(infoProvider)
        .firstWhere((info) => info.serialNo == dev.serialNo);

    final res = await CommandRunner.runScrcpyCommand(workDir, dev,
        args: ['--list-apps']);

    final applist = getAppsList(res.stdout);

    deviceInfo = deviceInfo.copyWith(appList: applist);

    ref.read(infoProvider.notifier).addOrEditDeviceInfo(deviceInfo);

    await Db.saveDeviceInfos(ref.read(infoProvider));

    gettingApp = false;
    setState(() {});
  }
}

class AppGridHeader extends ConsumerStatefulWidget {
  final TextEditingController appSearchController;
  const AppGridHeader({super.key, required this.appSearchController});

  @override
  ConsumerState<AppGridHeader> createState() => _AppGridHeaderState();
}

class _AppGridHeaderState extends ConsumerState<AppGridHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final gridSettings = ref.watch(appGridSettingsProvider);
    final gridSettingsNotifier = ref.read(appGridSettingsProvider.notifier);
    final missingIcons = ref.watch(missingIconProvider);
    final allConfigs = ref.watch(configsProvider);
    final config = ref.watch(controlPageConfigProvider);
    final showMissingIcon = ref.watch(showMissingIconProvider);

    return OutlinedContainer(
      surfaceOpacity: theme.surfaceOpacity,
      surfaceBlur: theme.surfaceBlur,
      borderStyle: BorderStyle.none,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: theme.colorScheme.muted, width: 1.5),
        )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Select<ScrcpyConfig>(
                    filled: true,
                    placeholder: OverflowMarquee(
                        duration: 2.seconds,
                        delayDuration: 0.5.seconds,
                        child: Text(el.loungeLoc.placeholders.config)),
                    value: config,
                    onChanged: (value) {
                      ref.read(controlPageConfigProvider.notifier).state =
                          value;
                      ref
                          .read(appGridSettingsProvider.notifier)
                          .setLastUsedConfig(value?.id);
                      Db.saveAppGridSettings(ref.read(appGridSettingsProvider));
                    },
                    popup: SelectPopup(
                      items: SelectItemList(
                          children: allConfigs
                              .where((c) => !c.windowOptions.noWindow)
                              .where((c) => !ref
                                  .read(hiddenConfigsProvider)
                                  .contains(c.id))
                              .map((c) => SelectItemButton(
                                  value: c,
                                  child: OverflowMarquee(
                                      duration: 3.seconds,
                                      delayDuration: 0.5.seconds,
                                      child: Text(c.configName))))
                              .toList()),
                    ).call,
                    itemBuilder: (context, value) => OverflowMarquee(
                        duration: 2.seconds,
                        delayDuration: 0.5.seconds,
                        child: Text(value.configName)),
                  ),
                ),
                Expanded(
                  child: TextField(
                    padding: EdgeInsets.all(7),
                    filled: true,
                    placeholder: Text(el.loungeLoc.placeholders.search),
                    focusNode: searchBoxFocusNode,
                    controller: widget.appSearchController,
                    features: [
                      if (widget.appSearchController.text.isEmpty)
                        InputFeature.leading(Icon(Icons.search_rounded)),
                      if (widget.appSearchController.text.isNotEmpty)
                        InputFeature.trailing(IconButton(
                            variance: ButtonVariance.link,
                            onPressed: () {
                              widget.appSearchController.clear();
                              controlPageKeyboardListenerNode.requestFocus();

                              setState(() {});
                            },
                            density: ButtonDensity.compact,
                            icon: Icon(Icons.close_rounded)))
                    ],
                    onSubmitted: (value) {
                      controlPageKeyboardListenerNode.requestFocus();
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 8,
              children: [
                if (missingIcons.isNotEmpty)
                  Toggle(
                    style: ButtonStyle.ghost(density: ButtonDensity.dense),
                    value: showMissingIcon,
                    onChanged: (value) => ref
                        .read(showMissingIconProvider.notifier)
                        .update((state) => !state),
                    child: showMissingIcon
                        ? Text(el.loungeLoc.appTile.sections.apps)
                        : Text(el.loungeLoc.appTile
                            .missingIcon(count: '${missingIcons.length}')),
                  ),
                Spacer(),
                Tooltip(
                  tooltip: TooltipContainer(
                          child: gridSettings.hideName
                              ? Text(el.loungeLoc.tooltip.showAppName)
                              : Text(el.loungeLoc.tooltip.hideAppName))
                      .call,
                  child: Toggle(
                      style: ButtonStyle.ghost(density: ButtonDensity.dense),
                      value: gridSettings.hideName,
                      onChanged: (value) =>
                          gridSettingsNotifier.toggleHideName(),
                      child: gridSettings.hideName
                          ? Icon(Icons.visibility_off_rounded).iconSmall()
                          : Icon(Icons.visibility_rounded).iconSmall()),
                ),
                ButtonGroup(
                  children: [
                    IconButton(
                      icon: Icon(Icons.zoom_out_rounded),
                      density: ButtonDensity.iconDense,
                      onPressed: gridSettings.gridExtent == 50
                          ? null
                          : () {
                              gridSettingsNotifier
                                  .modifyExtent(gridSettings.gridExtent - 5);
                              Db.saveAppGridSettings(
                                  ref.read(appGridSettingsProvider));
                            },
                      variance: ButtonStyle.outline(),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded),
                      density: ButtonDensity.iconDense,
                      onPressed: gridSettings.gridExtent == 80
                          ? null
                          : () {
                              gridSettingsNotifier.modifyExtent(80);
                              Db.saveAppGridSettings(
                                  ref.read(appGridSettingsProvider));
                            },
                      variance: ButtonStyle.outline(),
                    ),
                    IconButton(
                      icon: Icon(Icons.zoom_in_rounded),
                      density: ButtonDensity.iconDense,
                      variance: ButtonStyle.outline(),
                      onPressed: gridSettings.gridExtent == 110
                          ? null
                          : () {
                              gridSettingsNotifier
                                  .modifyExtent(gridSettings.gridExtent + 5);
                              Db.saveAppGridSettings(
                                  ref.read(appGridSettingsProvider));
                            },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
