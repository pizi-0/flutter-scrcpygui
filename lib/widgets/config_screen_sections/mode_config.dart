import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config/audio_options.dart';
import 'package:pg_scrcpy/providers/config_provider.dart';

import '../../models/scrcpy_related/scrcpy_config.dart';
import '../../models/scrcpy_related/scrcpy_enum.dart';
import '../../utils/const.dart';
import '../config_dropdown.dart';

class ModeConfig extends ConsumerStatefulWidget {
  const ModeConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModeConfigState();
}

class _ModeConfigState extends ConsumerState<ModeConfig> {
  String modeLabel = MainMode.mirror.value;

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Mode',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(10)),
          width: appWidth,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainModeSelector(context, selectedConfig),
                const SizedBox(height: 4),
                _buildModeSelector(context, selectedConfig),
                // const SizedBox(height: 4),
                // _extraOptions(context, selectedConfig)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainModeSelector(
      BuildContext context, ScrcpyConfig selectedConfig) {
    return AnimatedContainer(
      height: selectedConfig.isRecording ? 84 : 40,
      duration: const Duration(milliseconds: 200),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConfigDropdownEnum<MainMode>(
                items: MainMode.values,
                label: 'Mode',
                initialValue: selectedConfig.isRecording
                    ? MainMode.record
                    : MainMode.mirror,
                onSelected: (value) {
                  bool isRecording = value == MainMode.record;

                  ref.read(selectedConfigProvider.notifier).update(
                      (state) => state.copyWith(isRecording: isRecording));

                  modeLabel = value!.value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 4),
              ConfigCustom(
                label: 'Save folder',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Tooltip(
                    message: selectedConfig.savePath ?? '',
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final res =
                              await FilePicker.platform.getDirectoryPath();

                          if (res != null) {
                            ref.read(selectedConfigProvider.notifier).update(
                                (state) => state.copyWith(savePath: res));
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (selectedConfig.isRecording)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: Text(
                                    (selectedConfig.savePath ?? '')
                                        .split('/')
                                        .last,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.folder,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context, ScrcpyConfig selectedConfig) {
    return ConfigDropdownEnum<ScrcpyMode>(
      items: ScrcpyMode.values,
      label: modeLabel,
      initialValue: selectedConfig.scrcpyMode,
      onSelected: (value) {
        ref
            .read(selectedConfigProvider.notifier)
            .update((state) => state.copyWith(scrcpyMode: value));

        final def = selectedConfig.isRecording ? defaultRecord : defaultMirror;

        if (value == ScrcpyMode.audioOnly) {
          final audioFormat = _audioFormat(selectedConfig);

          ref
              .read(selectedConfigProvider.notifier)
              .update((state) => state = state.copyWith(
                  videoOptions: def.videoOptions,
                  audioOptions: SAudioOptions(
                    audioFormat: audioFormat,
                    audioBitrate: selectedConfig.audioOptions.audioBitrate,
                    audioCodec: selectedConfig.audioOptions.audioCodec,
                    audioEncoder: selectedConfig.audioOptions.audioEncoder,
                    audioSource: selectedConfig.audioOptions.audioSource,
                    duplicateAudio: selectedConfig.audioOptions.duplicateAudio,
                  )));
        }

        if (value == ScrcpyMode.videoOnly) {
          ref
              .read(selectedConfigProvider.notifier)
              .update((state) => state = state.copyWith(
                    videoOptions: selectedConfig.videoOptions,
                    audioOptions: SAudioOptions(
                      audioBitrate: def.audioOptions.audioBitrate,
                      audioCodec: def.audioOptions.audioCodec,
                      audioEncoder: def.audioOptions.audioEncoder,
                      audioFormat: def.audioOptions.audioFormat,
                      audioSource: def.audioOptions.audioSource,
                      duplicateAudio:
                          selectedConfig.audioOptions.duplicateAudio,
                    ),
                  ));
        }
      },
    );
  }

  _audioFormat(ScrcpyConfig selectedConfig) {
    switch (selectedConfig.audioOptions.audioCodec) {
      case 'aac':
        return AudioFormat.aac;
      case 'flac':
        return AudioFormat.flac;
      case 'raw':
        return AudioFormat.wav;

      default:
        return AudioFormat.opus;
    }
  }
}
