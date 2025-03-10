import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/adb_provider.dart';

import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../../providers/config_provider.dart';
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

    return PgSectionCard(
      label: el.videoSection.title,
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
            (d) => SelectItemButton(
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
      showinfo:
          showInfo || selectedConfig.videoOptions.resolutionScale != 100.0,
      subtitle: selectedConfig.videoOptions.resolutionScale == 1.0
          ? el.videoSection.resolutionScale.info.default$
          : el.videoSection.resolutionScale.info.alt(
              size: ((selectedConfig.videoOptions.resolutionScale / 100) *
                      max.first)
                  .toStringAsFixed(0)),
      childExpand: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 180, maxWidth: 180),
        child: Row(
          spacing: 4,
          children: [
            Text('${selectedConfig.videoOptions.resolutionScale.toInt()}%')
                .small(),
            Expanded(
              child: Slider(
                value: SliderValue.single(
                    selectedConfig.videoOptions.resolutionScale),
                max: 100,
                min: 30,
                divisions: 70,
                onChanged: (value) {
                  ref.read(configScreenConfig.notifier).update((state) =>
                      state = state!.copyWith(
                          videoOptions: state.videoOptions
                              .copyWith(resolutionScale: value.value)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCodecNFormatSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    return Column(
      spacing: 8,
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
              .map(
                  (e) => SelectItemButton(value: e.codec, child: Text(e.codec)))
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
          popupWidthConstraint: PopoverConstraint.intrinsic,
          initialValue: selectedConfig.videoOptions.videoEncoder == 'default'
              ? el.commonLoc.default$
              : selectedConfig.videoOptions.videoEncoder,
          onSelected: (value) {
            ref.read(configScreenConfig.notifier).update((state) => state =
                state!.copyWith(
                    videoOptions:
                        state.videoOptions.copyWith(videoEncoder: value)));
          },
          items: [
            SelectItemButton(
              value: 'default',
              child: OverflowMarquee(
                duration: 2.seconds,
                child: Text(el.commonLoc.default$),
              ),
            ),
            ...info.videoEncoders
                .firstWhere((ve) =>
                    ve.codec ==
                    ref.read(configScreenConfig)!.videoOptions.videoCodec)
                .encoder
                .map(
                  (enc) => SelectItemButton(
                    value: enc,
                    child: OverflowMarquee(
                      duration: 2.seconds,
                      delayDuration: 1.seconds,
                      child: Text(enc),
                    ),
                  ),
                )
          ],
          label: el.videoSection.encoder.label,
          subtitle: selectedConfig.videoOptions.videoEncoder == 'default'
              ? el.videoSection.encoder.info.default$
              : el.videoSection.encoder.info
                  .alt(encoder: selectedConfig.videoOptions.videoEncoder),
        ),
        if (selectedConfig.isRecording) const Divider(),
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
