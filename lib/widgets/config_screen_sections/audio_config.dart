import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../models/scrcpy_related/scrcpy_config.dart';
import '../../models/scrcpy_related/scrcpy_enum.dart';
import '../../providers/adb_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/const.dart';
import '../config_dropdown.dart';

class AudioConfig extends ConsumerStatefulWidget {
  const AudioConfig({super.key});

  @override
  ConsumerState<AudioConfig> createState() => _AudioConfigState();
}

class _AudioConfigState extends ConsumerState<AudioConfig> {
  late TextEditingController audioBitrateController;

  @override
  void initState() {
    final selectedConfig = ref.read(configScreenConfig)!;

    audioBitrateController = TextEditingController(
        text: selectedConfig.audioOptions.audioBitrate.toString());

    super.initState();
  }

  @override
  void dispose() {
    audioBitrateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      height: selectedConfig.scrcpyMode == ScrcpyMode.videoOnly
          ? 0
          : selectedConfig.scrcpyMode == ScrcpyMode.audioOnly &&
                  selectedConfig.isRecording
              ? 316
              : selectedConfig.scrcpyMode == ScrcpyMode.audioOnly &&
                      !selectedConfig.isRecording
                  ? 272
                  : 272,
      duration: const Duration(milliseconds: 200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Audio',
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
                    _buildAudioDuplicateOption(
                        context, selectedConfig, selectedDevice!.info!),
                    const SizedBox(height: 4),
                    _buildAudioSourceSelector(
                        context, selectedConfig, selectedDevice.info!),
                    const SizedBox(height: 4),
                    _buildAudioFormatSelector(
                        context, selectedConfig, selectedDevice.info!),
                    const SizedBox(height: 4),
                    _buildAudioBitrate(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioDuplicateOption(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConfigDropdownOthers(
      initialValue: selectedConfig.audioOptions.duplicateAudio,
      onSelected: (info.buildVersion.toInt() ?? 0) < 13
          ? null
          : (value) {
              ref.read(configScreenConfig.notifier).update((state) => state =
                  state!.copyWith(
                      audioOptions:
                          state.audioOptions.copyWith(duplicateAudio: value)));

              if (value == true) {
                ref.read(configScreenConfig.notifier).update((state) => state =
                    state!.copyWith(
                        audioOptions: state.audioOptions
                            .copyWith(audioSource: AudioSource.playback)));
              } else {
                ref.read(configScreenConfig.notifier).update((state) => state!
                    .copyWith(
                        audioOptions: state.audioOptions
                            .copyWith(audioSource: AudioSource.output)));
              }
            },
      items: [
        DropdownMenuItem(
          value: true,
          child: const Text('Yes').textColor(colorScheme.inverseSurface),
        ),
        DropdownMenuItem(
          value: false,
          child: const Text('No').textColor(colorScheme.inverseSurface),
        ),
      ],
      label: 'Duplicate audio *',
      tooltipMessage: 'Only for Android 13 and up',
    );
  }

  Widget _buildAudioSourceSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    return ConfigDropdownEnum<AudioSource>(
      items: AudioSource.values
          .where((s) => (info.buildVersion.toInt() ?? 0) < 13
              ? s.value != 'playback'
              : true)
          .toList(),
      label: 'Source',
      initialValue: selectedConfig.audioOptions.audioSource,
      onSelected: selectedConfig.audioOptions.duplicateAudio
          ? null
          : (value) {
              ref.read(configScreenConfig.notifier).update((state) => state =
                  state!.copyWith(
                      audioOptions:
                          state.audioOptions.copyWith(audioSource: value)));
            },
    );
  }

  Widget _buildAudioFormatSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: selectedConfig.isRecording &&
              selectedConfig.scrcpyMode == ScrcpyMode.audioOnly
          ? 128
          : 84,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfigDropdownOthers(
              initialValue: selectedConfig.audioOptions.audioCodec,
              onSelected: _isNotRecordingAudioOnly(selectedConfig)
                  ? null
                  : (value) {
                      ref.read(configScreenConfig.notifier).update((state) =>
                          state = state!.copyWith(
                              audioOptions: state.audioOptions.copyWith(
                                  audioCodec: value, audioEncoder: 'default')));
                    },
              items: [
                ...info.audioEncoder.map((e) => DropdownMenuItem(
                    value: e.codec,
                    child:
                        Text(e.codec).textColor(colorScheme.inverseSurface))),
                if (selectedConfig.audioOptions.audioFormat != AudioFormat.m4a)
                  DropdownMenuItem(
                      value: 'raw',
                      child: const Text('raw')
                          .textColor(colorScheme.inverseSurface))
              ],
              label: 'Codec *',
              tooltipMessage:
                  'Format: ${selectedConfig.audioOptions.audioFormat.value}, requires Codec: ${selectedConfig.audioOptions.audioCodec}',
            ),
            const SizedBox(height: 4),
            ConfigDropdownOthers(
              initialValue: selectedConfig.audioOptions.audioEncoder,
              onSelected: (value) {
                ref.read(configScreenConfig.notifier).update((state) => state =
                    state!.copyWith(
                        audioOptions:
                            state.audioOptions.copyWith(audioEncoder: value)));
              },
              items: [
                DropdownMenuItem(
                  value: 'default',
                  child: const Text('Default')
                      .textColor(colorScheme.inverseSurface),
                ),
                if (selectedConfig.audioOptions.audioCodec != 'raw')
                  ...info.audioEncoder
                      .firstWhere((ae) =>
                          ae.codec ==
                          ref.read(configScreenConfig)!.audioOptions.audioCodec)
                      .encoder
                      .map(
                        (enc) => DropdownMenuItem(
                          value: enc,
                          child:
                              Text(enc).textColor(colorScheme.inverseSurface),
                        ),
                      )
              ],
              label: 'Encoder *',
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: selectedConfig.isRecording &&
                      selectedConfig.scrcpyMode == ScrcpyMode.audioOnly
                  ? 44
                  : 0,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    ConfigDropdownEnum<AudioFormat>(
                      items: AudioFormat.values,
                      label: 'Format',
                      initialValue: selectedConfig.audioOptions.audioFormat,
                      toTitleCase: false,
                      onSelected: _onFormatSelected,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isNotRecordingAudioOnly(ScrcpyConfig selectedConfig) {
    if (selectedConfig.scrcpyMode == ScrcpyMode.audioOnly &&
        selectedConfig.isRecording) {
      if (selectedConfig.audioOptions.audioFormat != AudioFormat.mka &&
          selectedConfig.audioOptions.audioFormat != AudioFormat.m4a) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  _onFormatSelected(AudioFormat? value) {
    if (value == AudioFormat.wav) {
      ref.read(configScreenConfig.notifier).update((state) => state = state!
          .copyWith(
              audioOptions: state.audioOptions.copyWith(audioCodec: 'raw')));
    }

    if (value == AudioFormat.flac) {
      ref.read(configScreenConfig.notifier).update((state) => state = state!
          .copyWith(
              audioOptions: state.audioOptions.copyWith(audioCodec: 'flac')));
    }

    if (value == AudioFormat.aac) {
      ref.read(configScreenConfig.notifier).update((state) => state = state!
          .copyWith(
              audioOptions: state.audioOptions.copyWith(audioCodec: 'aac')));
    }

    if (value == AudioFormat.opus) {
      ref.read(configScreenConfig.notifier).update((state) => state = state!
          .copyWith(
              audioOptions: state.audioOptions.copyWith(audioCodec: 'opus')));
    }

    if (value == AudioFormat.m4a) {
      ref.read(configScreenConfig.notifier).update((state) => state = state!
          .copyWith(
              audioOptions: state.audioOptions.copyWith(audioCodec: 'opus')));
    }

    ref.read(configScreenConfig.notifier).update((state) => state!.copyWith(
        audioOptions: state.audioOptions.copyWith(audioFormat: value)));
  }

  Widget _buildAudioBitrate(BuildContext context) {
    return ConfigUserInput(
      label: 'Bitrate',
      controller: audioBitrateController,
      unit: 'K',
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(configScreenConfig.notifier).update((state) => state = state!
              .copyWith(
                  audioOptions:
                      state.audioOptions.copyWith(audioBitrate: 128)));
          audioBitrateController.text = '128';
          setState(() {});
        } else {
          ref.read(configScreenConfig.notifier).update((state) => state = state!
              .copyWith(
                  audioOptions: state.audioOptions
                      .copyWith(audioBitrate: int.parse(value))));
        }
      },
      onTap: () => setState(() {
        audioBitrateController.selection = TextSelection(
            baseOffset: 0, extentOffset: audioBitrateController.text.length);
      }),
    );
  }
}
