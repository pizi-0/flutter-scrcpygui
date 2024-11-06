import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/widgets/custom_slider_track_shape.dart';

import '../../models/scrcpy_related/scrcpy_config.dart';
import '../../models/scrcpy_related/scrcpy_enum.dart';
import '../../providers/settings_provider.dart';
import '../../utils/const.dart';
import '../config_dropdown.dart';

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
    final selectedConfig = ref.read(newOrEditConfigProvider)!;

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
    final selectedConfig = ref.watch(newOrEditConfigProvider)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      height: _containerHeight(selectedConfig, selectedDevice!.info!),
      duration: const Duration(milliseconds: 200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Video',
                style: Theme.of(context).textTheme.titleLarge,
              ).textColor(colorScheme.inverseSurface),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(appTheme.widgetRadius)),
              width: appWidth,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDisplaySelector(selectedConfig, selectedDevice.info!),
                    const SizedBox(height: 4),
                    _buildVideoCodecNFormatSelector(
                        context, selectedConfig, selectedDevice.info!),
                    const SizedBox(height: 4),
                    _buildVideoBitrate(context),
                    const SizedBox(height: 4),
                    _buildMaxFPS(selectedConfig),
                    // const SizedBox(height: 4),
                    // _buildCrop(selectedConfig, info),
                    const SizedBox(height: 4),
                    _buildResolutionScale(selectedConfig, selectedDevice.info!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _containerHeight(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    if (selectedConfig.scrcpyMode == ScrcpyMode.audioOnly) return 0;

    if (selectedConfig.isRecording) {
      return 360;
    } else {
      return 316;
    }
  }

  // Widget _buildCrop(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
  //   return const ConfigCustom(label: 'Crop', child: Center(child: Text('WIP')));
  // }

  Widget _buildMaxFPS(ScrcpyConfig selectedConfig) {
    return ConfigUserInput(
      label: 'FPS limit',
      controller: maxFPSController,
      unit: 'fps',
      onTap: () => setState(() {
        maxFPSController.selection = TextSelection(
            baseOffset: 0, extentOffset: maxFPSController.text.length);
      }),
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(newOrEditConfigProvider.notifier).update((state) => state =
              state!.copyWith(
                  videoOptions: state.videoOptions.copyWith(maxFPS: 0)));

          setState(() {
            maxFPSController.text = '-';
          });
        } else {
          ref.read(newOrEditConfigProvider.notifier).update((state) => state =
              state!.copyWith(
                  videoOptions: state.videoOptions
                      .copyWith(maxFPS: double.parse(value))));
        }
      },
    );
  }

  Widget _buildDisplaySelector(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfigDropdownOthers(
          label: 'Display *',
          initialValue: info.displays.length == 1
              ? info.displays[0].id
              : selectedConfig.videoOptions.displayId,
          tooltipMessage: 'Only 1 display detected',
          items: info.displays
              .map((d) => DropdownMenuItem(
                    value: d.id,
                    child: Text(d.id).textColor(colorScheme.inverseSurface
                        .withOpacity(info.displays.length == 1 ? 0.3 : 0)),
                  ))
              .toList(),
          onSelected: info.displays.length == 1
              ? null
              : (value) => ref
                  .read(newOrEditConfigProvider.notifier)
                  .update((state) => state = state!.copyWith(displayId: value)),
        ),
      ],
    );
  }

  Widget _buildResolutionScale(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConfigCustom(
      label: 'Resolution scale',
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SliderTheme(
                data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 5),
                ),
                child: Slider(
                  label: selectedConfig.videoOptions.resolutionScale
                      .toStringAsFixed(1),
                  value: selectedConfig.videoOptions.resolutionScale,
                  max: 1,
                  min: 0.3,
                  divisions: 7,
                  onChanged: (value) {
                    ref.read(newOrEditConfigProvider.notifier).update((state) =>
                        state = state!.copyWith(
                            videoOptions: state.videoOptions
                                .copyWith(resolutionScale: value)));
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(selectedConfig.videoOptions.resolutionScale
                    .toStringAsFixed(1))
                .textColor(colorScheme.inverseSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCodecNFormatSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      height: selectedConfig.isRecording ? 128 : 84,
      duration: const Duration(milliseconds: 200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfigDropdownOthers(
              initialValue: selectedConfig.videoOptions.videoCodec,
              onSelected: (value) {
                ref.read(newOrEditConfigProvider.notifier).update((state) =>
                    state = state!.copyWith(
                        videoOptions: state.videoOptions.copyWith(
                            videoCodec: value, videoEncoder: 'default')));
              },
              items: info.videoEncoders
                  .map((e) =>
                      DropdownMenuItem(value: e.codec, child: Text(e.codec)))
                  .toList(),
              label: 'Codec *',
            ),
            const SizedBox(height: 4),
            ConfigDropdownOthers(
              initialValue: selectedConfig.videoOptions.videoEncoder,
              onSelected: (value) {
                ref.read(newOrEditConfigProvider.notifier).update((state) =>
                    state = state!.copyWith(
                        videoOptions:
                            state.videoOptions.copyWith(videoEncoder: value)));
              },
              items: [
                DropdownMenuItem(
                  value: 'default',
                  child: const Text('Default')
                      .textColor(colorScheme.inverseSurface),
                ),
                ...info.videoEncoders
                    .firstWhere((ve) =>
                        ve.codec ==
                        ref
                            .read(newOrEditConfigProvider)!
                            .videoOptions
                            .videoCodec)
                    .encoder
                    .map(
                      (enc) => DropdownMenuItem(
                        value: enc,
                        child: Text(enc),
                      ),
                    )
              ],
              label: 'Encoder *',
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: !selectedConfig.isRecording ? 0 : 44,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    ConfigDropdownEnum<VideoFormat>(
                      items: VideoFormat.values,
                      label: 'Format',
                      initialValue: selectedConfig.videoOptions.videoFormat,
                      toTitleCase: false,
                      onSelected: (value) {
                        ref.read(newOrEditConfigProvider.notifier).update(
                            (state) => state = state!.copyWith(
                                videoOptions: state.videoOptions
                                    .copyWith(videoFormat: value)));
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVideoBitrate(BuildContext context) {
    return ConfigUserInput(
      label: 'Bitrate',
      controller: videoBitrateController,
      unit: 'M',
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(newOrEditConfigProvider.notifier).update((state) => state!
              .copyWith(
                  videoOptions: state.videoOptions.copyWith(videoBitrate: 8)));
          videoBitrateController.text = '8';
          setState(() {});
        } else {
          ref.read(newOrEditConfigProvider.notifier).update((state) => state!
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
