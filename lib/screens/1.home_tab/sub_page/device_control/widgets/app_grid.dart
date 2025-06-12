import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/app_icon_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../db/db.dart';
import '../../../../../models/adb_devices.dart';
import '../../../../../models/app_config_pair.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import '../../../../../providers/app_config_pair_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/navigation_shell.dart';
import '../device_control_page.dart';
import 'big_control_page.dart';

class AppGrid extends ConsumerStatefulWidget {
  final AdbDevices device;
  const AppGrid({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppGridState();
}

class _AppGridState extends ConsumerState<AppGrid> {
  TextEditingController appSearchController = TextEditingController();
  ScrollController appScrollController = ScrollController();
  double sidebarWidth = 52;

  @override
  void initState() {
    super.initState();
    sidebarWidth = _findSidebarWidth();
  }

  @override
  void dispose() {
    super.dispose();
    appSearchController.dispose();
    appScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final allConfigs = ref.watch(configsProvider);
    final config = ref.watch(controlPageConfigProvider);

    final devicePairs = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == device.id)
        .toList();

    final appsList = (device.info?.appList ?? [])
        .where((app) => devicePairs.where((dp) => dp.app == app).isEmpty)
        .toList();

    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    devicePairs.sort(
        (a, b) => a.app.name.toLowerCase().compareTo(b.app.name.toLowerCase()));

    final finalList = [...devicePairs.map((p) => p.app), ...appsList];

    final filteredList = finalList
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    final size = MediaQuery.sizeOf(context);

    return PgSectionCardNoScroll(
      constraints: BoxConstraints(maxWidth: (size.width - sidebarWidth) * 0.5),
      label: el.loungeLoc.launcher.label,
      expandContent: true,
      content: Column(
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
                    ref.read(controlPageConfigProvider.notifier).state = value;
                  },
                  popup: SelectPopup(
                    items: SelectItemList(
                        children: allConfigs
                            .where((c) => !c.windowOptions.noWindow)
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
                  controller: appSearchController,
                  onChanged: (value) => setState(() {}),
                  features: [
                    if (appSearchController.text.isEmpty)
                      InputFeature.leading(Icon(Icons.search_rounded)),
                    if (appSearchController.text.isNotEmpty)
                      InputFeature.trailing(IconButton(
                          variance: ButtonVariance.link,
                          onPressed: () {
                            appSearchController.clear();
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
          Divider(),
          Expanded(
            child: CustomScrollView(
              controller: appScrollController,
              slivers: [
                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                        child: Text(el.loungeLoc.info.emptySearch)
                            .textSmall
                            .muted),
                  ),
                if (filteredList.isNotEmpty)
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisExtent: 40,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final app = filteredList[index];

                      return AppGridTile(
                          ref: ref, app: app, device: widget.device);
                    },
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _findSidebarWidth() {
    final box = sidebarKey.currentContext?.findRenderObject();

    if (box != null) {
      return (box as RenderBox).size.width;
    } else {
      return 52;
    }
  }
}

class AppGridTile extends ConsumerStatefulWidget {
  const AppGridTile({
    super.key,
    required this.ref,
    required this.device,
    required this.app,
  });

  final WidgetRef ref;
  final AdbDevices device;
  final ScrcpyApp app;

  @override
  ConsumerState<AppGridTile> createState() => _AppGridTileState();
}

class _AppGridTileState extends ConsumerState<AppGridTile> {
  bool loading = false;
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = ref.watch(controlPageConfigProvider);
    final allConfigs = ref.watch(configsProvider);
    final devicePair = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == widget.device.id)
        .toList();

    final isPinned = devicePair.where((p) => p.app == widget.app).isNotEmpty;

    var configForPinned =
        devicePair.firstWhereOrNull((p) => p.app == widget.app)?.config;

    final isMissingConfig = isPinned &&
        allConfigs.where((c) => c.id == configForPinned?.id).isEmpty;

    if (!isMissingConfig) {
      configForPinned =
          allConfigs.firstWhereOrNull((c) => c.id == configForPinned?.id);
    }

    return Tooltip(
      tooltip: TooltipContainer(
          child: Text(
        isMissingConfig
            ? el.loungeLoc.tooltip
                .missingConfig(config: configForPinned?.configName ?? '')
            : isPinned
                ? 'On: ${configForPinned?.configName}'
                : widget.app.packageName,
        textAlign: TextAlign.center,
      )).call,
      child: ContextMenu(
        items: [
          if (config == null && !isPinned) ...[
            MenuLabel(
                leading: Icon(
                  Icons.warning_rounded,
                  color: theme.colorScheme.destructive,
                ),
                child: Text(el.loungeLoc.appTile.contextMenu.selectConfig)),
            MenuDivider(),
          ],
          if (!isPinned)
            MenuButton(
              enabled: config != null,
              onPressed: (context) async {
                controlPageKeyboardListenerNode.requestFocus();
                ref.read(appConfigPairProvider.notifier).addOrEditPair(
                    AppConfigPair(
                        deviceId: widget.device.id,
                        app: widget.app,
                        config: config!));

                await Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
              },
              leading: Icon(Icons.push_pin_rounded),
              child: Text(el.loungeLoc.appTile.contextMenu
                  .pin(config: config?.configName ?? '')),
            ),
          if (isPinned)
            MenuButton(
              enabled: config != null || isPinned,
              onPressed: (context) async {
                controlPageKeyboardListenerNode.requestFocus();
                final config = devicePair
                    .firstWhereOrNull((p) => p.app == widget.app)
                    ?.config;

                ref.read(appConfigPairProvider.notifier).removePair(
                    AppConfigPair(
                        deviceId: widget.device.id,
                        app: widget.app,
                        config: config!));

                await Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
              },
              leading: Icon(Icons.push_pin_rounded),
              child: Text(el.loungeLoc.appTile.contextMenu.unpin),
            ),
          MenuDivider(),
          MenuButton(
            enabled:
                enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
            onPressed: (context) => _startScrcpy(
                isPinned: isPinned,
                devicePair: devicePair,
                configForPinned: configForPinned!),
            leading: Icon(Icons.play_arrow_rounded),
            child: Text(el.loungeLoc.appTile.contextMenu.forceClose),
          ),
          MenuButton(
            enabled:
                enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
            onPressed: (context) =>
                IconScraper.getIconUrl(widget.app.packageName),
            leading: Icon(Icons.play_arrow_rounded),
            child: Text('get icon'),
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            Button(
              onHover: (value) {
                hover = value;
                setState(() {});
              },
              style: isPinned ? ButtonStyle.secondary() : ButtonStyle.outline(),
              // enabled: enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
              onPressed:
                  !enabled(isMissingConfig: isMissingConfig, isPinned: isPinned)
                      ? null
                      : () => _startScrcpy(
                          isPinned: isPinned,
                          devicePair: devicePair,
                          configForPinned: configForPinned),
              child: hover
                  ? OverflowMarquee(
                      duration: 2.seconds,
                      delayDuration: 0.5.seconds,
                      child: Text(
                        widget.app.name,
                      ).textAlignment(TextAlign.center),
                    )
                  : Text(
                      widget.app.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ).textAlignment(TextAlign.center),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                isPinned
                    ? isMissingConfig
                        ? Icons.warning_rounded
                        : Icons.push_pin_rounded
                    : Icons.more_vert_rounded,
                color: isMissingConfig ? theme.colorScheme.destructive : null,
              ).iconXSmall().paddingOnly(right: 4),
            ),
            if (loading)
              Positioned.fill(
                  child: Container(
                color: theme.colorScheme.background.withAlpha(200),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ))
          ],
        ),
      ),
    );
  }

  bool enabled({required bool isMissingConfig, required bool isPinned}) {
    final config = ref.watch(controlPageConfigProvider);

    if (isMissingConfig || loading || (!isPinned && config == null)) {
      return false;
    } else {
      return true;
    }
  }

  _startScrcpy(
      {required bool isPinned,
      required List<AppConfigPair> devicePair,
      ScrcpyConfig? configForPinned}) async {
    final config = ref.watch(controlPageConfigProvider);

    loading = true;
    setState(() {});

    controlPageKeyboardListenerNode.requestFocus();
    final selectedConfig = isPinned ? configForPinned ?? config : config;

    await ScrcpyUtils.newInstance(
      widget.ref,
      selectedConfig: selectedConfig!.copyWith(
          appOptions: selectedConfig.appOptions
              .copyWith(selectedApp: widget.app, forceClose: true)),
      selectedDevice: widget.device,
      customInstanceName: '${widget.app.name} (${selectedConfig.configName})',
    );

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }
}
