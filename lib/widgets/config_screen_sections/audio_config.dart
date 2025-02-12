import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';

import '../../models/scrcpy_related/scrcpy_config.dart';
import '../../models/scrcpy_related/scrcpy_enum.dart';
import '../../providers/adb_provider.dart';
import '../../providers/config_provider.dart';
import '../config_tiles.dart';

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Audio'),
        ),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAudioDuplicateOption(
                  context, selectedConfig, selectedDevice!.info!),
              const Divider(),
              _buildAudioSourceSelector(
                  context, selectedConfig, selectedDevice.info!),
              const Divider(),
              _buildAudioFormatSelector(
                  context, selectedConfig, selectedDevice.info!),
              const Divider(),
              _buildAudioBitrate(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioDuplicateOption(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
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
      items: const [
        ComboBoxItem(
          value: true,
          child: Text('Yes'),
        ),
        ComboBoxItem(
          value: false,
          child: Text('No'),
        ),
      ],
      label: 'Duplicate audio *',
      subtitle: selectedConfig.audioOptions.duplicateAudio
          ? "uses '--audio-dup' flag"
          : 'only for Android 13 and above',
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
      title: 'Source',
      subtitle: selectedConfig.audioOptions.audioSource == AudioSource.output
          ? "defaults to output, no flag"
          : selectedConfig.audioOptions.duplicateAudio
              ? "implied to 'Playback' with '--audio-dup', no flag"
              : "uses '${selectedConfig.audioOptions.audioSource.command.trimAll}'",
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedConfig.isRecording &&
            selectedConfig.scrcpyMode == ScrcpyMode.audioOnly)
          ConfigDropdownEnum<AudioFormat>(
            items: AudioFormat.values,
            title: 'Format',
            initialValue: selectedConfig.audioOptions.audioFormat,
            toTitleCase: false,
            onSelected: _onFormatSelected,
          ),
        if (selectedConfig.isRecording &&
            selectedConfig.scrcpyMode == ScrcpyMode.audioOnly)
          const Divider(),
        ConfigDropdownOthers(
          initialValue: selectedConfig.audioOptions.audioCodec,
          onSelected: _isRecordingAudioOnly(selectedConfig)
              ? null
              : (value) {
                  ref.read(configScreenConfig.notifier).update((state) =>
                      state = state!.copyWith(
                          audioOptions: state.audioOptions.copyWith(
                              audioCodec: value, audioEncoder: 'default')));
                },
          items: [
            ...info.audioEncoder
                .map((e) => ComboBoxItem(value: e.codec, child: Text(e.codec))),
            if (selectedConfig.audioOptions.audioFormat != AudioFormat.m4a)
              const ComboBoxItem(value: 'raw', child: Text('raw'))
          ],
          label: 'Codec *',
          subtitle: _isRecordingAudioOnly(selectedConfig)
              ? 'Format: ${selectedConfig.audioOptions.audioFormat.value}, requires Codec: ${selectedConfig.audioOptions.audioCodec}'
              : selectedConfig.audioOptions.audioCodec == 'opus'
                  ? 'defaults to opus, no flag'
                  : "uses '--audio-codec=${selectedConfig.audioOptions.audioCodec}'",
        ),
        const Divider(),
        ConfigDropdownOthers(
          initialValue: selectedConfig.audioOptions.audioEncoder,
          onSelected: (value) {
            ref.read(configScreenConfig.notifier).update((state) => state =
                state!.copyWith(
                    audioOptions:
                        state.audioOptions.copyWith(audioEncoder: value)));
          },
          items: [
            const ComboBoxItem(
              value: 'default',
              child: Text('Default'),
            ),
            if (selectedConfig.audioOptions.audioCodec != 'raw')
              ...info.audioEncoder
                  .firstWhere((ae) =>
                      ae.codec ==
                      ref.read(configScreenConfig)!.audioOptions.audioCodec)
                  .encoder
                  .map(
                    (enc) => ComboBoxItem(
                      value: enc,
                      child: Text(enc),
                    ),
                  )
          ],
          label: 'Encoder *',
          subtitle: selectedConfig.audioOptions.audioEncoder == 'default'
              ? 'defaults to first available, no flag'
              : "uses '--audio-encoder=${selectedConfig.audioOptions.audioEncoder}' flag",
        ),
      ],
    );
  }

  bool _isRecordingAudioOnly(ScrcpyConfig selectedConfig) {
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
      subtitle: audioBitrateController.text == '128'
          ? 'defaults to 128k, no flag'
          : "uses '--audio-bit-rate=${audioBitrateController.text.trim()}K'",
    );
  }
}
