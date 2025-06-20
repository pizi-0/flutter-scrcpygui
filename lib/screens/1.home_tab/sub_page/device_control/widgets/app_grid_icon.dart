// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/app_grid_settings_provider.dart';
import 'package:scrcpygui/providers/missing_icon_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:path/path.dart' as p;

import '../../../../../db/db.dart';
import '../../../../../models/adb_devices.dart';
import '../../../../../models/app_config_pair.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import '../../../../../providers/app_config_pair_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/app_icon_utils.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../device_control_page.dart';

class AppGridIcon extends ConsumerStatefulWidget {
  const AppGridIcon({
    super.key,
    required this.device,
    required this.app,
  });

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

    final noIconApps = ref.read(missingIconProvider);
    File? existingIcon = await IconDb.getIconFile(widget.app.packageName);
    File? fetchedIcon;

    if (existingIcon != null) {
      if (noIconApps.contains(widget.app)) {
        ref.read(missingIconProvider.notifier).removeApp(widget.app);
      }
      if (mounted) {
        setState(() {
          _iconFile = existingIcon;
        });
      }
      return;
    }

    // If not found locally, try to fetch it
    if (!noIconApps.contains(widget.app)) {
      fetchedIcon = await IconDb.fetchAndSaveIcon(widget.app.packageName);
      if (fetchedIcon == null) {
        ref.read(missingIconProvider.notifier).addApp(widget.app);
      }
    }

    if (mounted) {
      setState(() {
        _iconFile = fetchedIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overrides = ref.watch(configOverridesProvider);
    final config = ref.watch(controlPageConfigProvider);
    final gridSettings = ref.watch(appGridSettingsProvider);
    final allConfigs = ref.watch(configsProvider);
    final devicePair = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == widget.device.serialNo)
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
        Formats.webp,
        Formats.png,
        Formats.ico,
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
      onPerformDrop: _onPerformDrop,
      child: ContextMenu(
        items: _buildContextMenu(isMissingConfig, isPinned, config, theme,
            devicePair, configForPinned, overrides),
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
                onLongPressStart: (details) => _startScrcpy(
                    isPinned: isPinned,
                    devicePair: devicePair,
                    forceClose: true,
                    configForPinned: configForPinned),
                onTertiaryTapUp: config == null
                    ? null
                    : (details) => _startScrcpy(
                        isPinned: isPinned,
                        devicePair: devicePair,
                        configForPinned: config),
                onTertiaryLongPress: () => _startScrcpy(
                    isPinned: isPinned,
                    devicePair: devicePair,
                    configForPinned: config),
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
                                      key: UniqueKey(),
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
                          if (!gridSettings.hideName)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: hover
                                  ? OverflowMarquee(
                                      child: Text(widget.app.name).fontSize(12))
                                  : Text(
                                      widget.app.name,
                                      maxLines: 1,
                                    )
                                      .textAlignment(TextAlign.center)
                                      .fontSize(12),
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
                    child: Tooltip(
                      tooltip: TooltipContainer(
                              child: Text('On ${configForPinned?.configName}'))
                          .call,
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                    )),
              if (!enabled(
                  isMissingConfig: isMissingConfig, isPinned: isPinned))
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(200),
                      borderRadius: theme.borderRadiusLg),
                  child: isMissingConfig
                      ? Tooltip(
                          tooltip: TooltipContainer(
                                  child: Text(
                                      'Missing config: ${configForPinned?.configName}'))
                              .call,
                          child: Icon(
                            Icons.warning_rounded,
                            color: theme.colorScheme.destructive,
                            size: 30,
                          ),
                        )
                      : SizedBox.shrink(),
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

  List<MenuItem> _buildContextMenu(
      bool isMissingConfig,
      bool isPinned,
      ScrcpyConfig? config,
      ThemeData theme,
      List<AppConfigPair> devicePair,
      ScrcpyConfig? configForPinned,
      List<ScrcpyOverride> overrides) {
    return [
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
            enabled:
                enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
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
                  final file = await IconDb.getIconFile(widget.app.packageName);
                  await file?.delete();
                }
              }

              if (mounted) {
                _iconFile = fetchedIcon;

                if (_iconFile == null) {
                  ref.read(missingIconProvider.notifier).addApp(widget.app);
                }

                setState(() {});
              }
            },
            leading: Icon(Icons.refresh_rounded),
            child: Text('Reset Icon'),
          ),
        ],
        child: isPinned
            ? Text('${widget.app.name} (${configForPinned?.configName})')
            : Text(widget.app.name),
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
                    deviceId: widget.device.serialNo,
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
            final config =
                devicePair.firstWhereOrNull((p) => p.app == widget.app)?.config;

            ref.read(appConfigPairProvider.notifier).removePair(AppConfigPair(
                deviceId: widget.device.serialNo,
                app: widget.app,
                config: config!));

            await Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
          },
          leading: Icon(Icons.push_pin_rounded),
          child: Text(el.loungeLoc.appTile.contextMenu.unpin),
        ),
      MenuDivider(),
      MenuLabel(child: Text('Start').muted),
      if (isPinned && config != null && configForPinned?.id != config.id)
        MenuButton(
          enabled:
              enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
          onPressed: (context) => _startScrcpy(
              isPinned: isPinned,
              devicePair: devicePair,
              configForPinned: config),
          leading: Icon(Icons.play_arrow_rounded),
          child: Text('Start on: ${config.configName}'),
        ),
      MenuButton(
        enabled: enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
        subMenu: isPinned && config != null && configForPinned?.id != config.id
            ? [
                MenuButton(
                  enabled: enabled(
                      isMissingConfig: isMissingConfig, isPinned: isPinned),
                  onPressed: (context) => _startScrcpy(
                      isPinned: isPinned,
                      devicePair: devicePair,
                      forceClose: true,
                      configForPinned: configForPinned),
                  leading: Icon(Icons.play_arrow_rounded),
                  child: Text('On: ${configForPinned?.configName}'),
                ),
                MenuButton(
                  enabled: enabled(
                      isMissingConfig: isMissingConfig, isPinned: isPinned),
                  onPressed: (context) => _startScrcpy(
                      isPinned: isPinned,
                      devicePair: devicePair,
                      forceClose: true,
                      configForPinned: config),
                  leading: Icon(Icons.play_arrow_rounded),
                  child: Text('On: ${config.configName}'),
                ),
              ]
            : null,
        onPressed: !isPinned && config == null
            ? null
            : (context) => _startScrcpy(
                isPinned: isPinned,
                devicePair: devicePair,
                forceClose: true,
                configForPinned: configForPinned),
        leading: Icon(Icons.play_arrow_rounded),
        child: Text(el.loungeLoc.appTile.contextMenu.forceClose),
      ),
      if (overrides.isNotEmpty)
        MenuButton(
          enabled:
              enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
          onPressed: (context) => _startScrcpy(
            isPinned: isPinned,
            devicePair: devicePair,
            configForPinned: configForPinned,
            withOverrides: overrides.isNotEmpty,
          ),
          leading: Icon(Icons.play_arrow_rounded),
          child: Text('Start with overrides'),
        ),
    ];
  }

  Future<Uint8List?>? readFile(DropItem item, FileFormat format) {
    final c = Completer<Uint8List?>();
    final progress = item.dataReader?.getFile(format, (file) async {
      try {
        final all = await file.readAll();
        c.complete(all);
      } catch (e) {
        c.completeError(e);
      }
    }, onError: (e) {
      c.completeError(e);
    });
    if (progress == null) {
      c.complete(null);
    }

    return c.future;
  }

  Future<void> _onPerformDrop(PerformDropEvent event) async {
    File? imageFile;
    final iconDir = await IconDb.getIconsDirectory();

    setState(() {
      _onDropHover = false;
      processingIcon = true;
    });

    final icon = event.session.items.first;

    final supportedImageFormats = [
      Formats.webp,
      Formats.png,
      Formats.ico,
    ];

    for (final format in supportedImageFormats) {
      final c = Completer<File?>();
      if (icon.canProvide(format)) {
        final byte = await readFile(icon, format);

        if (byte == null) {
          continue;
        }

        final file =
            File(p.join(iconDir.path, '${widget.app.packageName}.png'));
        final finalFile = await file.writeAsBytes(byte, flush: true);
        c.complete(finalFile);
        imageFile = finalFile;

        if (_iconFile != null) {
          await FileImage(_iconFile!).evict();
          _iconFile = null;
        }
        _iconFile = imageFile;
        if (ref.read(missingIconProvider).contains(widget.app)) {
          ref.read(missingIconProvider.notifier).removeApp(widget.app);
        }
        break;
      }
    }

    if (imageFile == null) {
      showDialog(
        context: context,
        builder: (context) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: appWidth),
          child: AlertDialog(
            title: Text('Unsupported format'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PgSectionCardNoScroll(
                  label: 'Supported formats:',
                  content: Text('webp, png, ico'),
                ),
                PgSectionCardNoScroll(
                  label: 'Detected format:',
                  content:
                      Text(event.session.items.first.platformFormats.join(' ')),
                ),
              ],
            ),
            actions: [
              SecondaryButton(
                  onPressed: () => context.pop(),
                  child: Text(el.buttonLabelLoc.close))
            ],
          ),
        ),
      );
    }

    processingIcon = false;
    setState(() {});
  }

  bool enabled({required bool isMissingConfig, required bool isPinned}) {
    final config = ref.watch(controlPageConfigProvider);

    if (isMissingConfig || loading || (!isPinned && config == null)) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _startScrcpy(
      {required bool isPinned,
      required List<AppConfigPair> devicePair,
      ScrcpyConfig? configForPinned,
      bool withOverrides = false,
      bool forceClose = false}) async {
    final config = ref.watch(controlPageConfigProvider);

    loading = true;
    setState(() {});

    controlPageKeyboardListenerNode.requestFocus();
    final selectedConfig = isPinned ? configForPinned ?? config : config;

    if (withOverrides) {
      final overrides = ref.read(configOverridesProvider);
      final overridden =
          ScrcpyUtils.handleOverrides(overrides, selectedConfig!);

      await ScrcpyUtils.newInstance(
        ref,
        selectedConfig: overridden.copyWith(
            appOptions: selectedConfig.appOptions
                .copyWith(selectedApp: widget.app, forceClose: forceClose)),
        selectedDevice: widget.device,
        customInstanceName: '${widget.app.name} (${selectedConfig.configName})',
      );
    } else {
      await ScrcpyUtils.newInstance(
        ref,
        selectedConfig: selectedConfig!.copyWith(
            appOptions: selectedConfig.appOptions
                .copyWith(selectedApp: widget.app, forceClose: forceClose)),
        selectedDevice: widget.device,
        customInstanceName: '${widget.app.name} (${selectedConfig.configName})',
      );
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }
}
