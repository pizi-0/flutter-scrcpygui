import 'package:animate_do/animate_do.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/adb_provider.dart';

import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../../providers/config_provider.dart';
import '../../../../../../providers/settings_provider.dart';
import '../../../../../../widgets/config_tiles.dart';

class VideoConfig extends ConsumerStatefulWidget {
  const VideoConfig({super.key});

  @override
  ConsumerState<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends ConsumerState<VideoConfig> {
  late TextEditingController videoBitrateController;
  late TextEditingController maxFPSController;

  @override
  void initState() {
    final selectedConfig = ref.read(configScreenConfig)!;

    videoBitrateController = TextEditingController(
        text: selectedConfig.videoOptions.videoBitrate.toString());

    maxFPSController = TextEditingController(
        text: selectedConfig.videoOptions.maxFPS == 0
            ? '-'
            : selectedConfig.videoOptions.maxFPS.toString());
    super.initState();
  }

  @override
  void dispose() {
    videoBitrateController.dispose();
    maxFPSController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfigCustom(
            title: el.videoSection.title, child: const Icon(FluentIcons.video)),
        Card(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDisplaySelector(selectedConfig, selectedDevice!.info!),
                const Divider(),
                _buildVideoCodecNFormatSelector(
                    context, selectedConfig, selectedDevice.info!),
                const Divider(),
                _buildVideoBitrate(context),
                const Divider(),
                _buildMaxFPS(selectedConfig),
                const Divider(),
                _buildResolutionScale(selectedConfig, selectedDevice.info!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaxFPS(ScrcpyConfig selectedConfig) {
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigUserInput(
      label: el.videoSection.fpsLimit.label,
      showinfo: showInfo,
      subtitle: maxFPSController.text == '-'
          ? el.videoSection.fpsLimit.info.default$
          : el.videoSection.fpsLimit.info
              .alt(fps: maxFPSController.text.trim()),
      controller: maxFPSController,
      unit: 'fps',
      onTap: () => setState(() {
        maxFPSController.selection = TextSelection(
            baseOffset: 0, extentOffset: maxFPSController.text.length);
      }),
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(configScreenConfig.notifier).update((state) => state = state!
              .copyWith(videoOptions: state.videoOptions.copyWith(maxFPS: 0)));

          setState(() {
            maxFPSController.text = '-';
          });
        } else {
          ref.read(configScreenConfig.notifier).update((state) => state = state!
              .copyWith(
                  videoOptions: state.videoOptions
                      .copyWith(maxFPS: double.parse(value))));
        }
      },
    );
  }

  Widget _buildDisplaySelector(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    final displays =
        info.displays.where((d) => (int.tryParse(d.id) ?? 11) < 10).toList();

    return ConfigDropdownOthers(
      label: el.videoSection.displays.label,
      initialValue: displays.length == 1
          ? displays[0].id
          : selectedConfig.videoOptions.displayId.toString(),
      tooltipMessage: 'Only 1 display detected',
      showinfo: showInfo,
      subtitle: selectedConfig.videoOptions.displayId == 0
          ? el.videoSection.displays.info.default$
          : el.videoSection.displays.info.alt,
      items: displays
          .map(
            (d) => ComboBoxItem(
              value: d.id,
              child: Text(d.id),
            ),
          )
          .toList(),
      onSelected: displays.length == 1
          ? null
          : (value) => ref
              .read(configScreenConfig.notifier)
              .update((state) => state = state!.copyWith(displayId: value)),
    );
  }

  Widget _buildResolutionScale(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    final displaySize = info.displays
        .firstWhere(
            (f) => f.id == selectedConfig.videoOptions.displayId.toString())
        .resolution
        .split('x');

    final max = displaySize.map((e) => int.parse(e.removeLetters!)).toList();
    max.sort((a, b) => b.compareTo(a));

    return ConfigCustom(
      title: el.videoSection.resolutionScale.label,
      showinfo: showInfo,
      subtitle: selectedConfig.videoOptions.resolutionScale == 1.0
          ? el.videoSection.resolutionScale.info.default$
          : el.videoSection.resolutionScale.info.alt(
              size: (selectedConfig.videoOptions.resolutionScale * max.first)
                  .toStringAsFixed(0)),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Slider(
                label:
                    'max-size=${(selectedConfig.videoOptions.resolutionScale * max.first).toStringAsFixed(0)}',
                value: selectedConfig.videoOptions.resolutionScale,
                max: 1,
                min: 0.3,
                divisions: 7,
                onChanged: (value) {
                  ref.read(configScreenConfig.notifier).update((state) =>
                      state = state!.copyWith(
                          videoOptions: state.videoOptions
                              .copyWith(resolutionScale: value)));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
                selectedConfig.videoOptions.resolutionScale.toStringAsFixed(1)),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCodecNFormatSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfigDropdownOthers(
          showinfo: showInfo,
          initialValue: selectedConfig.videoOptions.videoCodec,
          onSelected: (value) {
            ref.read(configScreenConfig.notifier).update((state) => state =
                state!.copyWith(
                    videoOptions: state.videoOptions
                        .copyWith(videoCodec: value, videoEncoder: 'default')));
          },
          items: info.videoEncoders
              .map((e) => ComboBoxItem(value: e.codec, child: Text(e.codec)))
              .toList(),
          label: el.videoSection.codec.label,
          subtitle: selectedConfig.videoOptions.videoCodec == 'h264'
              ? el.videoSection.codec.info.default$
              : el.videoSection.codec.info
                  .alt(codec: selectedConfig.videoOptions.videoCodec),
        ),
        const Divider(),
        ConfigDropdownOthers(
          showinfo: showInfo,
          initialValue: selectedConfig.videoOptions.videoEncoder,
          onSelected: (value) {
            ref.read(configScreenConfig.notifier).update((state) => state =
                state!.copyWith(
                    videoOptions:
                        state.videoOptions.copyWith(videoEncoder: value)));
          },
          items: [
            const ComboBoxItem(
              value: 'default',
              child: Text('Default'),
            ),
            ...info.videoEncoders
                .firstWhere((ve) =>
                    ve.codec ==
                    ref.read(configScreenConfig)!.videoOptions.videoCodec)
                .encoder
                .map(
                  (enc) => ComboBoxItem(
                    value: enc,
                    child: Text(enc),
                  ),
                )
          ],
          label: el.videoSection.encoder.label,
          subtitle: selectedConfig.videoOptions.videoEncoder == 'default'
              ? el.videoSection.encoder.info.default$
              : el.videoSection.encoder.info
                  .alt(encoder: selectedConfig.videoOptions.videoEncoder),
        ),
        const Divider(),
        if (selectedConfig.isRecording)
          FadeIn(
            child: ConfigDropdownEnum<VideoFormat>(
              showinfo: showInfo,
              items: VideoFormat.values,
              title: el.videoSection.format.label,
              subtitle: el.videoSection.format.info.default$(
                  format: selectedConfig.videoOptions.videoFormat.command),
              initialValue: selectedConfig.videoOptions.videoFormat,
              toTitleCase: false,
              onSelected: (value) {
                ref.read(configScreenConfig.notifier).update((state) => state =
                    state!.copyWith(
                        videoOptions:
                            state.videoOptions.copyWith(videoFormat: value)));
              },
            ),
          )
      ],
    );
  }

  Widget _buildVideoBitrate(BuildContext context) {
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigUserInput(
      label: el.videoSection.bitrate.label,
      subtitle: videoBitrateController.text == '8'
          ? el.videoSection.bitrate.info.default$
          : el.videoSection.bitrate.info
              .alt(bitrate: videoBitrateController.text.trimAll),
      controller: videoBitrateController,
      showinfo: showInfo,
      unit: 'M',
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(configScreenConfig.notifier).update((state) => state!
              .copyWith(
                  videoOptions: state.videoOptions.copyWith(videoBitrate: 8)));
          videoBitrateController.text = '8';
          setState(() {});
        } else {
          ref.read(configScreenConfig.notifier).update((state) => state!
              .copyWith(
                  videoOptions: state.videoOptions
                      .copyWith(videoBitrate: int.parse(value))));
        }
      },
      onTap: () => setState(() {
        videoBitrateController.selection = TextSelection(
            baseOffset: 0, extentOffset: videoBitrateController.text.length);
      }),
    );
  }
}
