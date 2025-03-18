import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../../providers/config_provider.dart';
import '../../../../../../widgets/config_tiles.dart';

final sep = Platform.pathSeparator;

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
    final showInfo = ref.watch(configScreenShowInfo);

    return PgSectionCard(
      label: el.modeSection.title,
      children: [
        ConfigDropdownEnum<MainMode>(
          items: MainMode.values,
          title: el.modeSection.mainMode.label,
          subtitle: !selectedConfig.isRecording
              ? el.modeSection.mainMode.info.default$
              : el.modeSection.mainMode.info.alt,
          showinfo: showInfo,
          initialValue:
              (selectedConfig.isRecording ? MainMode.record : MainMode.mirror),
          onSelected: (value) {
            bool isRecording = value == MainMode.record;

            ref
                .read(configScreenConfig.notifier)
                .setModeConfig(isRecording: isRecording);

            modeLabel = value!.value;
            setState(() {});
          },
        ),
        if (selectedConfig.isRecording) const Divider(),
        if (selectedConfig.isRecording)
          FadeIn(
            child: ConfigCustom(
              dimTitle: false,
              title: el.modeSection.saveFolder.label,
              subtitle: el.modeSection.saveFolder.info,
              showinfo: showInfo,
              child: SecondaryButton(
                trailing: const Icon(Icons.folder),
                onPressed: () async {
                  final res = await FilePicker.platform.getDirectoryPath();

                  if (res != null) {
                    ref
                        .read(configScreenConfig.notifier)
                        .setModeConfig(savePath: res);
                  }
                },
                child: Text(
                  (selectedConfig.savePath ?? '').split(sep).last,
                ),
              ),
            ),
          ),
        const Divider(),
        ConfigDropdownEnum<ScrcpyMode>(
          items: ScrcpyMode.values,
          title: modeLabel,
          subtitle: selectedConfig.scrcpyMode == ScrcpyMode.both
              ? el.modeSection.scrcpyMode.info.default$
              : el.modeSection.scrcpyMode.info
                  .alt(command: selectedConfig.scrcpyMode.command.trim()),
          showinfo: showInfo,
          initialValue: selectedConfig.scrcpyMode,
          onSelected: (value) {
            ref
                .read(configScreenConfig.notifier)
                .setModeConfig(scrcpyMode: value);

            if (value == ScrcpyMode.audioOnly) {
              final audioFormat = _audioFormat(selectedConfig);

              ref
                  .read(configScreenConfig.notifier)
                  .setVideoConfig(setToDefault: true);

              ref.read(configScreenConfig.notifier).setAudioConfig(
                    audioFormat: audioFormat,
                    audioBitrate: selectedConfig.audioOptions.audioBitrate,
                    audioCodec: selectedConfig.audioOptions.audioCodec,
                    audioEncoder: selectedConfig.audioOptions.audioEncoder,
                    audioSource: selectedConfig.audioOptions.audioSource,
                    duplicateAudio: selectedConfig.audioOptions.duplicateAudio,
                  );
            }

            if (value == ScrcpyMode.videoOnly) {
              ref
                  .read(configScreenConfig.notifier)
                  .setAudioConfig(setToDefault: true);

              ref.read(configScreenConfig.notifier).setVideoConfig(
                    displayId: selectedConfig.videoOptions.displayId,
                    maxFPS: selectedConfig.videoOptions.maxFPS,
                    resolutionScale:
                        selectedConfig.videoOptions.resolutionScale,
                    videoBitrate: selectedConfig.videoOptions.videoBitrate,
                    videoCodec: selectedConfig.videoOptions.videoCodec,
                    videoEncoder: selectedConfig.videoOptions.videoEncoder,
                    videoFormat: selectedConfig.videoOptions.videoFormat,
                  );
            }
          },
        )
      ],
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
