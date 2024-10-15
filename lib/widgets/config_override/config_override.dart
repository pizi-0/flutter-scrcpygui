import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import '../../providers/adb_provider.dart';
import '../../providers/config_provider.dart';
import '../../providers/info_provider.dart';
import '../config_dropdown.dart';

class DisplayIdOverride extends ConsumerWidget {
  const DisplayIdOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);
    final ScrcpyInfo info = ref
        .watch(infoProvider)
        .firstWhere((i) => i.device.serialNo == selectedDevice!.serialNo);

    return ConfigDropdownOthers(
      label: 'Display *',
      initialValue: info.displays.length == 1
          ? info.displays[0].id
          : selectedConfig.videoOptions.displayId,
      tooltipMessage: 'Only 1 display detected',
      items: info.displays
          .map((d) => DropdownMenuItem(
                value: d.id,
                child: Text(d.id),
              ))
          .toList(),
      onSelected: info.displays.length == 1
          ? null
          : (value) => ref
              .read(selectedConfigProvider.notifier)
              .update((state) => state = state.copyWith(displayId: value)),
    );
  }
}

class VideoCodecOverride extends ConsumerWidget {
  const VideoCodecOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);
    final ScrcpyInfo info = ref
        .watch(infoProvider)
        .firstWhere((i) => i.device.serialNo == selectedDevice!.serialNo);

    final currentCodec = selectedConfig.videoOptions.videoCodec;

    return ConfigDropdownOthers(
      initialValue: selectedConfig.videoOptions.videoCodec,
      onSelected: (value) {
        ref.read(selectedConfigProvider.notifier).update((state) => state =
            state.copyWith(
                videoOptions: state.videoOptions.copyWith(videoCodec: value)));
      },
      items: [
        ...info.videoEncoders
            .map((e) => DropdownMenuItem(value: e.codec, child: Text(e.codec))),
        DropdownMenuItem(value: currentCodec, child: Text('$currentCodec *'))
      ],
      label: 'Codec',
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
