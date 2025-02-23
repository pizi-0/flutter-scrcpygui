import 'package:awesome_extensions/awesome_extensions.dart'
    show StringExtension;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          onPressed: () => context.pop(),
        )
      ],
    );
  }
}
