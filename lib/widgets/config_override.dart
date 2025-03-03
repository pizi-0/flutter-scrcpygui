import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../providers/adb_provider.dart';
import 'config_tiles.dart';

final configOverrideProvider = StateProvider<ScrcpyConfig?>((ref) => null);

class DisplayIdOverride extends ConsumerWidget {
  const DisplayIdOverride({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(configOverrideProvider);

    return ConfigDropdownOthers(
      label: 'Display *',
      initialValue: selectedDevice!.info!.displays.length == 1
          ? selectedDevice.info!.displays[0].id
          : selectedConfig?.videoOptions.displayId,
      tooltipMessage: 'Only 1 display detected',
      items: selectedDevice.info!.displays
          .map((d) => SelectItemButton(
                value: d.id,
                child: Text(d.id),
              ))
          .toList(),
      onSelected: selectedDevice.info!.displays.length == 1
          ? null
          : (value) => ref
              .read(configOverrideProvider.notifier)
              .update((state) => state = state!.copyWith(displayId: value)),
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
