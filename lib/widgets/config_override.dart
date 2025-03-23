import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../providers/adb_provider.dart';
import 'config_tiles.dart';

final configOverrideProvider = StateProvider<ScrcpyConfig?>((ref) => null);

class VideoOptionsOverride extends ConsumerWidget {
  final bool display;
  final bool codec;
  final bool encoder;
  const VideoOptionsOverride(
      {super.key,
      this.display = false,
      this.codec = false,
      this.encoder = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = [
      if (display) DisplayIdOverride(),
      if (codec) VideoCodecOverride(),
      if (encoder) VideoEncoderOverride()
    ];

    return PgSectionCard(
      label: el.videoSection.title,
      children: list
          .mapIndexed((index, widget) => Column(
                spacing: 8,
                children: [widget, if (index != list.length - 1) Divider()],
              ))
          .toList(),
    );
  }
}

class AudioOptionsOverride extends ConsumerWidget {
  final bool duplicateAudio;
  final bool audioCodec;
  final bool audioEncoder;
  const AudioOptionsOverride(
      {super.key,
      this.duplicateAudio = false,
      this.audioCodec = false,
      this.audioEncoder = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = [
      // if (duplicateAudio) DisplayIdOverride(),
      // if (audioCodec) VideoCodecOverride(),
      // if (audioEncoder) VideoEncoderOverride()
    ];

    return PgSectionCard(
      label: el.audioSection.title,
      children: list
          .mapIndexed((index, widget) => Column(
                spacing: 8,
                children: [widget, if (index != list.length - 1) Divider()],
              ))
          .toList(),
    );
  }
}

class DisplayIdOverride extends ConsumerWidget {
  const DisplayIdOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(configOverrideProvider)!;
    final faultyConfig = ref.watch(selectedConfigProvider)!;

    return ConfigDropdownOthers(
      label: el.videoSection.displays.label,
      subtitle:
          "Display with ID: '${faultyConfig.videoOptions.displayId}' is not available for this device.",
      showinfo: true,
      initialValue: selectedDevice!.info!.displays.length == 1
          ? selectedDevice.info!.displays[0].id
          : selectedConfig.videoOptions.displayId,
      tooltipMessage: 'Only 1 display detected',
      items: selectedDevice.info!.displays
          .map((d) => SelectItemButton(
                value: d.id,
                child: Text(d.id),
              ))
          .toList(),
      onSelected: selectedDevice.info!.displays.length == 1
          ? null
          : (value) => ref.read(configOverrideProvider.notifier).update(
                (state) => state = state!.copyWith(
                    videoOptions:
                        state.videoOptions.copyWith(displayId: value)),
              ),
    );
  }
}

class VideoCodecOverride extends ConsumerWidget {
  const VideoCodecOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(configOverrideProvider);

    final currentCodec = selectedConfig!.videoOptions.videoCodec;

    return ConfigDropdownOthers(
      initialValue: selectedConfig.videoOptions.videoCodec,
      onSelected: (value) {
        ref.read(configOverrideProvider.notifier).update((state) => state =
            state!.copyWith(
                videoOptions: state.videoOptions.copyWith(videoCodec: value)));
      },
      items: [
        ...selectedDevice!.info!.videoEncoders
            .map((e) => SelectItemButton(value: e.codec, child: Text(e.codec))),
        SelectItemButton(value: currentCodec, child: Text('$currentCodec *'))
      ],
      label: el.videoSection.codec.label,
    );
  }
}

class VideoEncoderOverride extends ConsumerWidget {
  const VideoEncoderOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(configOverrideProvider)!;
    final faultyConfig = ref.watch(selectedConfigProvider)!;

    return ConfigDropdownOthers(
      initialValue: selectedConfig.videoOptions.videoEncoder,
      subtitle:
          "Encoder: '${faultyConfig.videoOptions.videoEncoder}' is not available for this device.",
      showinfo: faultyConfig.videoOptions.videoEncoder ==
          selectedConfig.videoOptions.videoEncoder,
      popupWidthConstraint: PopoverConstraint.intrinsic,
      onSelected: (value) {
        ref.read(configOverrideProvider.notifier).update((state) => state =
            state!.copyWith(
                videoOptions:
                    state.videoOptions.copyWith(videoEncoder: value)));
      },
      items: [
        ...selectedDevice!.info!.videoEncoders
            .firstWhere(
                (enc) => enc.codec == selectedConfig.videoOptions.videoCodec)
            .encoder
            .map((e) => SelectItemButton(value: e, child: Text(e))),
        SelectItemButton(
            value: faultyConfig.videoOptions.videoEncoder,
            child: Text('${faultyConfig.videoOptions.videoEncoder} *'))
      ],
      label: el.videoSection.encoder.label,
    );
  }
}

class AudioCodecOverride extends ConsumerWidget {
  const AudioCodecOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
