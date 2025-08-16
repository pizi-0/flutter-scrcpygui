import 'package:awesome_extensions/awesome_extensions.dart'
    show StringExtension;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../models/scrcpy_related/scrcpy_enum.dart';

class ConfigDetailDialog extends ConsumerStatefulWidget {
  final ScrcpyConfig config;
  const ConfigDetailDialog({super.key, required this.config});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigDetailDialogState();
}

class _ConfigDetailDialogState extends ConsumerState<ConfigDetailDialog> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final videoOptions = widget.config.videoOptions;
    final virtualDisplayOptions = videoOptions.virtualDisplayOptions;
    final audioOptions = widget.config.audioOptions;
    final appOptions = widget.config.appOptions;
    final deviceOptions = widget.config.deviceOptions;
    final windowOptions = widget.config.windowOptions;

    return AlertDialog(
      title: const Text('Config info'),
      content: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: sectionWidth, maxHeight: size.height - 161),
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              spacing: 6,
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
                        Text('  - format: ${videoOptions.videoFormat.value}'),
                      Text('  - codec: ${videoOptions.videoCodec}'),
                      Text('  - encoder: ${videoOptions.videoEncoder}'),
                      Text('  - bitrate: ${videoOptions.videoBitrate}M'),
                      Text(
                          '  - resolution scale: ${videoOptions.resolutionScale}'),
                      Text('  - display id: ${videoOptions.displayId}'),
                    ],
                  ),
                if (videoOptions.displayId == 'new')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Divider(),
                      Text('Virtual display options: '),
                      Text(
                          '  - resolution: ${virtualDisplayOptions.resolution}'),
                      Text('  - dpi: ${virtualDisplayOptions.dpi}'),
                      if (virtualDisplayOptions.disableDecorations)
                        Text(
                            '  - disable decorations: ${virtualDisplayOptions.disableDecorations}'),
                      if (virtualDisplayOptions.preseveContent)
                        Text(
                            '  - preserve content: ${virtualDisplayOptions.preseveContent}')
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
                        Text('  - format: ${audioOptions.audioFormat.value}'),
                      Text('  - codec: ${audioOptions.audioCodec}'),
                      Text(
                          '  - encoder: ${audioOptions.audioCodec == 'opus' ? 'default' : audioOptions.audioEncoder}'),
                      Text('  - bitrate: ${audioOptions.audioBitrate}K'),
                    ],
                  ),
                if (appOptions.selectedApp != null)
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const Text('App options:'),
                      Text('  - app: ${appOptions.selectedApp!.name}'),
                      Text('  - force close app: ${appOptions.forceClose}')
                    ],
                  ),
                Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const Text('Device options:'),
                    if (deviceOptions.stayAwake) const Text('  - stay awake'),
                    if (deviceOptions.showTouches)
                      const Text('  - show touches'),
                    if (deviceOptions.turnOffDisplay)
                      const Text('  - turn off display on start'),
                    if (deviceOptions.offScreenOnClose)
                      const Text('  - turn off display on on exit'),
                    if (deviceOptions.noScreensaver)
                      const Text('  - disable screensaver (HOST)'),
                  ],
                ),
                Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const Text('Window options:'),
                    if (windowOptions.noWindow) const Text('  - hide window'),
                    if (windowOptions.noBorder) const Text('  - borderless'),
                    if (windowOptions.alwaysOntop)
                      const Text('  - always on top'),
                    if (windowOptions.timeLimit != 0)
                      Text('  - time limit: ${windowOptions.timeLimit}s'),
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
                        .map((e) => Text('  --${e.trim()}'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        SecondaryButton(
          child: Text(el.buttonLabelLoc.close),
          onPressed: () => context.pop(),
        )
      ],
    );
  }
}
