import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/audio_options.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';

import '../../models/scrcpy_related/scrcpy_config.dart';
import '../../models/scrcpy_related/scrcpy_enum.dart';
import '../../utils/const.dart';
import '../config_tiles.dart';

class ModeConfig extends ConsumerStatefulWidget {
  const ModeConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModeConfigState();
}

class _ModeConfigState extends ConsumerState<ModeConfig> {
  String modeLabel = MainMode.mirror.value;

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Mode'),
        ),
        Card(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainModeSelector(ref, context, selectedConfig),
              _buildModeSelector(context, selectedConfig),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainModeSelector(
      WidgetRef ref, BuildContext context, ScrcpyConfig selectedConfig) {
    final sep = Platform.pathSeparator;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfigDropdownEnum<MainMode>(
          items: MainMode.values,
          title: 'Mode',
          subtitle: !selectedConfig.isRecording
              ? 'mirror or record, no flag for mirror'
              : "uses '--record=' flag",
          initialValue:
              selectedConfig.isRecording ? MainMode.record : MainMode.mirror,
          onSelected: (value) {
            bool isRecording = value == MainMode.record;

            ref.read(configScreenConfig.notifier).update(
                (state) => state = state!.copyWith(isRecording: isRecording));

            modeLabel = value!.value;
            setState(() {});
          },
        ),
        const Divider(),
        if (selectedConfig.isRecording)
          FadeIn(
            duration: 200.milliseconds,
            child: ConfigCustom(
              title: 'Save folder',
              subtitle: "appends save path to '--record=savepath/file'",
              child: Button(
                onPressed: () async {
                  final res = await FilePicker.platform.getDirectoryPath();

                  if (res != null) {
                    ref.read(configScreenConfig.notifier).update(
                        (state) => state = state!.copyWith(savePath: res));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      const Icon(FluentIcons.folder_horizontal),
                      Text(
                        (selectedConfig.savePath ?? '').split(sep).last,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const Divider(),
      ],
    );
  }

  Widget _buildModeSelector(BuildContext context, ScrcpyConfig selectedConfig) {
    return ConfigDropdownEnum<ScrcpyMode>(
      items: ScrcpyMode.values,
      title: modeLabel,
      subtitle: selectedConfig.scrcpyMode == ScrcpyMode.both
          ? 'defaults to both, no flag'
          : "uses '${selectedConfig.scrcpyMode.command.trim()}' flag",
      initialValue: selectedConfig.scrcpyMode,
      onSelected: (value) {
        ref
            .read(configScreenConfig.notifier)
            .update((state) => state = state!.copyWith(scrcpyMode: value));

        final def = selectedConfig.isRecording ? defaultRecord : defaultMirror;

        if (value == ScrcpyMode.audioOnly) {
          final audioFormat = _audioFormat(selectedConfig);

          ref
              .read(configScreenConfig.notifier)
              .update((state) => state = state!.copyWith(
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
              .read(configScreenConfig.notifier)
              .update((state) => state = state!.copyWith(
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
