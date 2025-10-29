import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
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
    final isRecording =
        ref.watch(configScreenConfig.select((val) => val!.isRecording));

    return PgSectionCard(
      label: el.modeSection.title,
      children: [
        MainModeFlag(),
        if (isRecording) const Divider(),
        if (isRecording) FadeIn(child: SaveFolderFlag()),
        const Divider(),
        ScrcpyModeFlag()
      ],
    );
  }
}

AudioFormat _audioFormat(ScrcpyConfig? selectedConfig) {
  switch (selectedConfig?.audioOptions.audioCodec) {
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

class MainModeFlag extends ConsumerWidget {
  const MainModeFlag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording =
        ref.watch(configScreenConfig.select((val) => val!.isRecording));
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigCustom(
      title: el.modeSection.mainMode.label,
      subtitle: !isRecording
          ? el.modeSection.mainMode.info.default$
          : el.modeSection.mainMode.info.alt,
      showinfo: showInfo,
      dimTitle: false,
      child: Select(
        value: isRecording ? mainModeDD(context)[1] : mainModeDD(context)[0],
        filled: true,
        popup: SelectPopup(
          items: SelectItemList(
            children: mainModeDD(context)
                .map(
                  (mode) => SelectItemButton(value: mode, child: Text(mode.$2)),
                )
                .toList(),
          ),
        ).call,
        onChanged: (value) =>
            ref.read(configScreenConfig.notifier).setModeConfig(
                  isRecording: value!.$1 == MainMode.record,
                ),
        itemBuilder: (context, value) => Text(value.$2),
      ),
    );
  }
}

class SaveFolderFlag extends ConsumerWidget {
  const SaveFolderFlag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showInfo = ref.watch(configScreenShowInfo);
    final savePath =
        ref.watch(configScreenConfig.select((val) => val!.savePath));

    return ConfigCustom(
      dimTitle: false,
      title: el.modeSection.saveFolder.label,
      subtitle: el.modeSection.saveFolder.info,
      showinfo: showInfo,
      child: SecondaryButton(
        trailing: const Icon(Icons.folder),
        onPressed: () async {
          final res = await FilePicker.platform
              .getDirectoryPath(initialDirectory: defaultSavePath);

          if (res != null) {
            ref.read(configScreenConfig.notifier).setModeConfig(savePath: res);
          }
        },
        child: Text(
          (savePath ?? '').split(sep).last,
        ),
      ),
    );
  }
}

class ScrcpyModeFlag extends ConsumerWidget {
  const ScrcpyModeFlag({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showInfo = ref.watch(configScreenShowInfo);
    final isRecording =
        ref.watch(configScreenConfig.select((val) => val!.isRecording));

    final scrcpyMode =
        ref.watch(configScreenConfig.select((val) => val!.scrcpyMode));

    final audioOptions =
        ref.watch(configScreenConfig.select((val) => val!.audioOptions));

    final videoOptions =
        ref.watch(configScreenConfig.select((val) => val!.videoOptions));

    return ConfigCustom(
      dimTitle: false,
      title: isRecording
          ? el.modeSection.mainMode.record
          : el.modeSection.mainMode.mirror,
      subtitle: scrcpyMode == ScrcpyMode.both
          ? el.modeSection.scrcpyMode.info.default$
          : el.modeSection.scrcpyMode.info
              .alt(command: scrcpyMode.command.trim()),
      showinfo: showInfo,
      child: Select(
        value:
            scrcpyModeDD(context).firstWhere((mode) => mode.$1 == scrcpyMode),
        onChanged: (value) {
          ref
              .read(configScreenConfig.notifier)
              .setModeConfig(scrcpyMode: value!.$1);

          if (value.$1 == ScrcpyMode.audioOnly) {
            final audioFormat = _audioFormat(ref.read(selectedConfigProvider));

            ref
                .read(configScreenConfig.notifier)
                .setVideoConfig(setToDefault: true);

            ref.read(configScreenConfig.notifier).setAudioConfig(
                  audioFormat: audioFormat,
                  audioBitrate: audioOptions.audioBitrate,
                  audioCodec: audioOptions.audioCodec,
                  audioEncoder: audioOptions.audioEncoder,
                  audioSource: audioOptions.audioSource,
                  duplicateAudio: audioOptions.duplicateAudio,
                );
          }

          if (value.$1 == ScrcpyMode.videoOnly) {
            ref
                .read(configScreenConfig.notifier)
                .setAudioConfig(setToDefault: true);

            ref.read(configScreenConfig.notifier).setVideoConfig(
                  displayId: videoOptions.displayId,
                  maxFPS: videoOptions.maxFPS,
                  resolutionScale: videoOptions.resolutionScale,
                  videoBitrate: videoOptions.videoBitrate,
                  videoCodec: videoOptions.videoCodec,
                  videoEncoder: videoOptions.videoEncoder,
                  videoFormat: videoOptions.videoFormat,
                );
          }
        },
        itemBuilder: (context, value) => Text(value.$2),
        filled: true,
        popup: SelectPopup(
          items: SelectItemList(
            children: scrcpyModeDD(context)
                .map((mode) =>
                    SelectItemButton(value: mode, child: Text(mode.$2)))
                .toList(),
          ),
        ).call,
      ),
    );
  }
}

List<(MainMode, String)> mainModeDD(BuildContext context) {
  return [
    (MainMode.mirror, el.modeSection.mainMode.mirror),
    (MainMode.record, el.modeSection.mainMode.record),
  ];
}

List<(ScrcpyMode, String)> scrcpyModeDD(BuildContext context) {
  return [
    (ScrcpyMode.both, el.modeSection.scrcpyMode.both),
    (ScrcpyMode.audioOnly, el.modeSection.scrcpyMode.audioOnly),
    (ScrcpyMode.videoOnly, el.modeSection.scrcpyMode.videoOnly),
  ];
}
