import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:path/path.dart' as p;
import 'package:scrcpygui/utils/app_icon_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

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
    final theme = Theme.of(context);
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

    final deviceAppslist = devicePairs.map((p) => p.app).toList();

    final finalList = [...deviceAppslist, ...appsList];

    final filteredList = finalList
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    final filteredDeviceAppslist = deviceAppslist
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    final filteredAppslist = appsList
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
                if (filteredDeviceAppslist.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted,
                          borderRadius: theme.borderRadiusSm,
                        ),
                        child: Text('Pinned').textSmall),
                  ),
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80,
                      mainAxisExtent: 80,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: filteredDeviceAppslist.length,
                    itemBuilder: (context, index) {
                      final app = filteredDeviceAppslist[index];

                      return AppGridIcon(
                          key: ValueKey(app.packageName),
                          ref: ref,
                          app: app,
                          device: widget.device);
                    },
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
                if (filteredAppslist.isNotEmpty) ...[
                  if (deviceAppslist.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted,
                            borderRadius: theme.borderRadiusSm,
                          ),
                          child: Text('Apps').textSmall),
                    ),
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80,
                      mainAxisExtent: 80,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: filteredAppslist.length,
                    itemBuilder: (context, index) {
                      final app = filteredAppslist[index];

                      return AppGridIcon(
                          key: ValueKey(app.packageName),
                          ref: ref,
                          app: app,
                          device: widget.device);
                    },
                  )
                ]
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
  File? _iconFile;
  bool _isIconLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrFetchIcon();
  }

  Future<void> _loadOrFetchIcon() async {
    if (!mounted) return;
    setState(() {
      _isIconLoading = true;
    });

    File? existingIcon = await IconDb.getIconFile(widget.app.packageName);
    if (existingIcon != null) {
      if (mounted) {
        setState(() {
          _iconFile = existingIcon;
          _isIconLoading = false;
        });
      }
      return;
    }

    // If not found locally, try to fetch it
    File? fetchedIcon = await IconDb.fetchAndSaveIcon(widget.app.packageName);
    if (mounted) {
      setState(() {
        _iconFile = fetchedIcon; // Will be null if fetch failed
        _isIconLoading = false;
      });
    }
  }

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
            onPressed: (context) async {
              controlPageKeyboardListenerNode.requestFocus();
              if (mounted) {
                setState(() {
                  _iconFile = null;
                  _isIconLoading = true;
                });
              }

              if (await IconDb.iconExists(widget.app.packageName)) {
                final iconFile =
                    await IconDb.getIconFile(widget.app.packageName);
                if (mounted) {
                  setState(() {
                    _iconFile = iconFile;
                    _isIconLoading = false;
                  });
                }

                return;
              }

              File? fetchedIcon =
                  await IconDb.fetchAndSaveIcon(widget.app.packageName);
              if (mounted) {
                setState(() {
                  _iconFile = fetchedIcon;
                  _isIconLoading = false;
                });
              }
            },
            leading: Icon(Icons.refresh_rounded),
            child: Text('Refresh Icon'),
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
              style: isPinned
                  ? ButtonStyle.secondary(density: ButtonDensity.compact)
                  : ButtonStyle.outline(density: ButtonDensity.compact),
              // enabled: enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
              onPressed:
                  !enabled(isMissingConfig: isMissingConfig, isPinned: isPinned)
                      ? null
                      : () => _startScrcpy(
                          isPinned: isPinned,
                          devicePair: devicePair,
                          configForPinned: configForPinned),
              child: Stack(
                children: [
                  if (_isIconLoading) ...[
                    const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())),
                  ] else if (_iconFile != null)
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: OutlinedContainer(
                        child: Image.file(_iconFile!, fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        }),
                      ),
                    ),
                  Container(
                    color: Colors.black.withAlpha(100),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: hover
                          ? Center(
                              child: OverflowMarquee(
                                duration: 2.seconds,
                                delayDuration: 0.5.seconds,
                                child: Text(
                                  widget.app.name,
                                ).textAlignment(TextAlign.center),
                              ),
                            )
                          : Center(
                              child: Text(
                                widget.app.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ).textAlignment(TextAlign.center),
                            ),
                    ),
                  ),
                ],
              ),
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
              )),
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

class AppGridIcon extends ConsumerStatefulWidget {
  const AppGridIcon({
    super.key,
    required this.ref,
    required this.device,
    required this.app,
  });

  final WidgetRef ref;
  final AdbDevices device;
  final ScrcpyApp app;

  @override
  ConsumerState<AppGridIcon> createState() => _AppGridIconState();
}

class _AppGridIconState extends ConsumerState<AppGridIcon> {
  bool loading = false;
  bool hover = false;
  bool _onDropHover = false;
  File? _iconFile;
  bool processingIcon = false;

  @override
  void initState() {
    super.initState();
    _loadOrFetchIcon();
  }

  Future<void> _loadOrFetchIcon() async {
    if (!mounted) return;

    File? existingIcon = await IconDb.getIconFile(widget.app.packageName);
    if (existingIcon != null) {
      if (mounted) {
        setState(() {
          _iconFile = existingIcon;
        });
      }
      return;
    }

    // If not found locally, try to fetch it
    File? fetchedIcon = await IconDb.fetchAndSaveIcon(widget.app.packageName);
    if (mounted) {
      setState(() {
        _iconFile = fetchedIcon;
      });
    }
  }

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

    return DropRegion(
      formats: [
        ...Formats.standardFormats,
        Formats.png,
        Formats.jpeg,
        Formats.ico,
        Formats.webp
      ],
      hitTestBehavior: HitTestBehavior.opaque,
      onDropOver: (p0) {
        setState(() {
          _onDropHover = true;
        });

        return p0.session.allowedOperations.firstOrNull ?? DropOperation.none;
      },
      onDropEnded: (p0) {
        setState(() {
          _onDropHover = false;
        });
      },
      onDropEnter: (p0) {},
      onDropLeave: (p0) {
        setState(() {
          _onDropHover = false;
        });
      },
      onPerformDrop: (p0) async {
        setState(() {
          _onDropHover = false;
          processingIcon = true;
        });

        final icon = p0.session.items.first;

        if (icon.canProvide(Formats.png) ||
            icon.canProvide(Formats.jpeg) ||
            icon.canProvide(Formats.ico) ||
            icon.canProvide(Formats.webp)) {
          if (_iconFile != null) {
            await FileImage(_iconFile!).evict();
            _iconFile = null;
            setState(() {});
          }

          p0.session.items.first.dataReader?.getFile(
            Formats.png,
            (value) async {
              final iconDir = await IconDb.getIconsDirectory();

              final byte = await value.readAll();
              final file =
                  File(p.join(iconDir.path, '${widget.app.packageName}.png'));

              final icon = await file.writeAsBytes(byte, flush: true);

              _iconFile = icon;
            },
          );
        } else {}

        if (mounted) {
          processingIcon = false;
          setState(() {});
        }
      },
      child: ContextMenu(
        items: [
          MenuButton(
            leading: Icon(Icons.info_rounded),
            subMenu: [
              MenuLabel(child: Text('Package name').muted),
              MenuButton(
                leading: Icon(Icons.copy_rounded),
                onPressed: (context) async {
                  final cp = ClipboardData(text: widget.app.packageName);
                  await Clipboard.setData(cp);
                },
                child: Text(widget.app.packageName),
              ),
              MenuDivider(),
              MenuButton(
                enabled: enabled(
                    isMissingConfig: isMissingConfig, isPinned: isPinned),
                onPressed: (context) async {
                  controlPageKeyboardListenerNode.requestFocus();

                  if (_iconFile != null) {
                    await FileImage(_iconFile!).evict();
                  }

                  if (mounted) {
                    setState(() {
                      _iconFile = null;
                    });
                  }

                  File? fetchedIcon =
                      await IconDb.fetchAndSaveIcon(widget.app.packageName);

                  if (fetchedIcon == null) {
                    if (await IconDb.iconExists(widget.app.packageName)) {
                      final file =
                          await IconDb.getIconFile(widget.app.packageName);
                      await file?.delete();
                    }
                  }

                  if (mounted) {
                    setState(() {
                      _iconFile = fetchedIcon;
                    });
                  }
                },
                leading: Icon(Icons.refresh_rounded),
                child: Text('Reset Icon'),
              ),
            ],
            child: Text(widget.app.name),
          ),
          MenuDivider(),
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
        ],
        child: AnimatedScale(
          duration: 200.milliseconds,
          scale: _onDropHover ? 1.2 : 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Button(
                onHover: (value) {
                  hover = value;
                  setState(() {});
                },
                enabled: enabled(
                    isMissingConfig: isMissingConfig, isPinned: isPinned),
                style: _iconFile == null
                    ? ButtonStyle.outline(density: ButtonDensity.compact)
                    : ButtonStyle.ghost(density: ButtonDensity.compact),
                onPressed: () => _startScrcpy(
                    isPinned: isPinned,
                    devicePair: devicePair,
                    configForPinned: configForPinned),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: _iconFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _iconFile!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SizedBox.shrink(),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      widget.app.name.substring(0, 2),
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: hover
                                ? OverflowMarquee(child: Text(widget.app.name))
                                : Text(
                                    widget.app.name,
                                    maxLines: 1,
                                  ).textAlignment(TextAlign.center).textSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isPinned)
                Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    )),
              if (!enabled(
                  isMissingConfig: isMissingConfig, isPinned: isPinned))
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(200),
                      borderRadius: theme.borderRadiusLg),
                ),
              if (loading || processingIcon)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(200),
                      borderRadius: theme.borderRadiusLg),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
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
