// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../providers/adb_provider.dart';
import '../../../../providers/config_provider.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/const.dart';
import '../../../../utils/scrcpy_utils.dart';
import '../../sub_page/config_screen/config_screen.dart';

final configKey = GlobalKey<ComboBoxState>(debugLabel: 'config list combo box');

class HomeBottomBar extends ConsumerStatefulWidget {
  const HomeBottomBar({super.key});

  @override
  ConsumerState<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends ConsumerState<HomeBottomBar> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final allconfigs = ref.watch(configsProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConfigCustom(
            title: 'Start scrcpy',
            child: HyperlinkButton(
                onPressed: _onNewConfigPressed,
                child: const Text('New config'))),
        Card(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: ComboBox(
                  key: configKey,
                  isExpanded: true,
                  placeholder: const Text('Select a config'),
                  value: selectedConfig,
                  onChanged: (value) {
                    ref.read(selectedConfigProvider.notifier).state = value;
                    setState(() {});
                  },
                  items: allconfigs
                      .map(
                        (c) => ComboBoxItem(
                            value: c, child: ConfigDropDownItem(config: c)),
                      )
                      .toList(),
                ),
              ),
              Button(
                onPressed: loading ? null : _start,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: loading
                      ? const SizedBox.square(
                          dimension: 18, child: ProgressRing())
                      : const Text('Start'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _onNewConfigPressed() {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedDevice != null) {
      final newconfig = newConfig.copyWith(id: const Uuid().v4());
      ref.read(configScreenConfig.notifier).state = newconfig;
      Navigator.pushNamed(context, '/create_config');
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ContentDialog(
          title: const Text('Device'),
          content: const Text(
              'No device selected.\nSelect a device to create scrcpy config.'),
          actions: [
            Button(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  _start() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final selectedConfig = ref.read(selectedConfigProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ContentDialog(
          title: const Text('Config'),
          content: const Text(
              'No config selected.\nSelect a scrcpy config to start.'),
          actions: [
            Button(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
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
            builder: (context) => ContentDialog(
              title: const Text('Device'),
              content: const Text(
                  'No device selected.\nSelect a device to start scrcpy.'),
              actions: [
                Button(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                )
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
}

class ConfigDropDownItem extends ConsumerStatefulWidget {
  final ScrcpyConfig config;
  const ConfigDropDownItem({super.key, required this.config});

  @override
  ConsumerState<ConfigDropDownItem> createState() => _ConfigDropDownItemState();
}

class _ConfigDropDownItemState extends ConsumerState<ConfigDropDownItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: 'Show details',
          child: IconButton(
            icon: const Icon(FluentIcons.info),
            onPressed: _onDetailPressed,
          ),
        ),
        Expanded(
          child: Text(
            widget.config.configName,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
        if (widget.config.isRecording)
          Tooltip(
            message: 'Open save folder',
            child: IconButton(
              icon: const Icon(FluentIcons.open_folder_horizontal),
              onPressed: () => AppUtils.openFolder(widget.config.savePath!),
            ),
          ),
        if (widget.config.isRecording &&
            !defaultConfigs.contains(widget.config))
          const Divider(
            direction: Axis.vertical,
            size: 18,
          ),
        if (!defaultConfigs.contains(widget.config))
          Tooltip(
            message: 'Edit config',
            child: IconButton(
              icon: const Icon(FluentIcons.edit),
              onPressed: () => _onEditPressed(widget.config),
            ),
          ),
        if (!defaultConfigs.contains(widget.config))
          const Divider(
            direction: Axis.vertical,
            size: 18,
          ),
        if (!defaultConfigs.contains(widget.config))
          Tooltip(
            message: 'Edit config',
            child: IconButton(
              icon: const Icon(FluentIcons.delete),
              onPressed: _onRemoveConfigPressed,
            ),
          ),
      ],
    );
  }

  _onDetailPressed() {
    configKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: widget.config),
    );
  }

  _onRemoveConfigPressed() async {
    configKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: widget.config),
    );
  }

  _onEditPressed(ScrcpyConfig config) {
    configKey.currentState?.closePopup();

    ref.read(selectedConfigProvider.notifier).state = config;

    if (ref.read(selectedDeviceProvider) == null) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ContentDialog(
          title: const Text('Device'),
          content: const Text(
              'No device selected.\nSelect a device to edit scrcpy config.'),
          actions: [
            Button(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } else {
      ref.read(configScreenConfig.notifier).state = config;
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => const ConfigScreen()));
    }
  }
}

class ConfigDetailDialog extends ConsumerStatefulWidget {
  final ScrcpyConfig config;
  const ConfigDetailDialog({super.key, required this.config});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigDetailDialogState();
}

class _ConfigDetailDialogState extends ConsumerState<ConfigDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Config info'),
      content: SingleChildScrollView(
        child: Column(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.config.configName}'),
            Text('Mode: ${widget.config.scrcpyMode.value.capitalizeFirst}'),
            Text('Record: ${widget.config.isRecording}'),
            if (widget.config.isRecording)
              Text('Save folder: ${widget.config.savePath}'),
            if (widget.config.scrcpyMode != ScrcpyMode.audioOnly)
              Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text('Video options:'),
                  if (widget.config.isRecording)
                    Text(
                        '  - format: ${widget.config.videoOptions.videoFormat.value}'),
                  Text('  - codec: ${widget.config.videoOptions.videoCodec}'),
                  Text(
                      '  - encoder: ${widget.config.videoOptions.videoEncoder}'),
                  Text(
                      '  - bitrate: ${widget.config.videoOptions.videoBitrate}M'),
                  Text(
                      '  - resolution scale: ${widget.config.videoOptions.resolutionScale}'),
                  Text(
                      '  - display id: ${widget.config.videoOptions.displayId}'),
                ],
              ),
            if (widget.config.scrcpyMode != ScrcpyMode.videoOnly)
              Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text('Audio options:'),
                  if (widget.config.isRecording)
                    Text(
                        '  - format: ${widget.config.audioOptions.audioFormat.value}'),
                  Text('  - codec: ${widget.config.audioOptions.audioCodec}'),
                  Text(
                      '  - encoder: ${widget.config.audioOptions.audioCodec == 'opus' ? 'default' : widget.config.audioOptions.audioEncoder}'),
                  Text(
                      '  - bitrate: ${widget.config.audioOptions.audioBitrate}K'),
                ],
              ),
            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text('Device options:'),
                if (widget.config.deviceOptions.stayAwake)
                  const Text('  - stay awake'),
                if (widget.config.deviceOptions.showTouches)
                  const Text('  - show touches'),
                if (widget.config.deviceOptions.turnOffDisplay)
                  const Text('  - turn off display on start'),
                if (widget.config.deviceOptions.offScreenOnClose)
                  const Text('  - turn off display on on exit'),
                if (widget.config.deviceOptions.noScreensaver)
                  const Text('  - disable screensaver (HOST)'),
              ],
            ),
            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text('Window options:'),
                if (widget.config.windowOptions.noWindow)
                  const Text('  - hide window'),
                if (widget.config.windowOptions.noBorder)
                  const Text('  - borderless'),
                if (widget.config.windowOptions.alwaysOntop)
                  const Text('  - always on top'),
                if (widget.config.windowOptions.timeLimit != 0)
                  Text(
                      '  - time limit: ${widget.config.windowOptions.timeLimit}s'),
              ],
            ),
            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text('Additional flags:'),
                ...widget.config.additionalFlags
                    .split('--')
                    .where((e) => e.isNotEmpty)
                    .map((e) => Text('  - --${e.trim()}'))
              ],
            ),
          ],
        ),
      ),
      actions: [
        Button(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class ConfigDeleteDialog extends ConsumerStatefulWidget {
  final ScrcpyConfig config;
  const ConfigDeleteDialog({super.key, required this.config});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigDeleteDialogState();
}

class _ConfigDeleteDialogState extends ConsumerState<ConfigDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Confirm'),
      content: Text('Delete ${widget.config.configName}?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            Button(
              child: const Text('Delete'),
              onPressed: () async {
                if (ref.read(selectedConfigProvider) == widget.config) {
                  ref.read(selectedConfigProvider.notifier).state = ref
                      .read(configsProvider)
                      .where((e) => e.id != widget.config.id)
                      .first;
                }
                ref.read(configsProvider.notifier).removeConfig(widget.config);
                await Db.saveConfigs(
                    ref,
                    context,
                    ref
                        .read(configsProvider)
                        .where((e) => !defaultConfigs.contains(e))
                        .toList());
                Navigator.pop(context, true);
              },
            ),
            Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context)),
          ],
        ),
      ],
    );
  }
}
