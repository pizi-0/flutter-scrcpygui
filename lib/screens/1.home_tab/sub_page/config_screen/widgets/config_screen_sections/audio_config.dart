import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';

import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../../providers/adb_provider.dart';
import '../../../../../../providers/config_provider.dart';
import '../../../../../../widgets/config_tiles.dart';

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

    return PgSectionCard(
      label: el.audioSection.title,
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
    );
  }

  Widget _buildAudioDuplicateOption(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigDropdownOthers(
      initialValue: selectedConfig.audioOptions.duplicateAudio
          ? el.commonLoc.yes
          : el.commonLoc.no,
      showinfo: showInfo,
      onSelected: (info.buildVersion.toInt() ?? 0) < 13
          ? null
          : (value) {
              ref
                  .read(configScreenConfig.notifier)
                  .setAudioConfig(duplicateAudio: value);

              if (value == true) {
                ref
                    .read(configScreenConfig.notifier)
                    .setAudioConfig(audioSource: AudioSource.playback);
              } else {
                ref
                    .read(configScreenConfig.notifier)
                    .setAudioConfig(audioSource: AudioSource.output);
              }
            },
      items: [
        SelectItemButton(
          value: true,
          child: Text(el.commonLoc.yes),
        ),
        SelectItemButton(
          value: false,
          child: Text(el.commonLoc.no),
        ),
      ],
      label: el.audioSection.duplicate.label,
      subtitle: selectedConfig.audioOptions.duplicateAudio
          ? el.audioSection.duplicate.info.alt
          : el.audioSection.duplicate.info.default$,
    );
  }

  Widget _buildAudioSourceSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);
    final scrcpyVersion = ref.watch(scrcpyVersionProvider);

    final defaultSource = AudioSource.values
        .sublist(0, 3)
        .where((s) => (info.buildVersion.toInt() ?? 0) < 13
            ? s.value != 'playback'
            : true)
        .map((e) =>
            SelectItemButton(value: e, child: Text(e.value.capitalizeFirst)));

    final extraSource = AudioSource.values.sublist(3).map(
          (e) =>
              SelectItemButton(value: e, child: Text(e.value.capitalizeFirst)),
        );

    final showExtraSource =
        scrcpyVersion.parseVersionToInt()! >= '3.2'.parseVersionToInt()!;

    return ConfigDropdownOthers(
      label: el.audioSection.source.label,
      showinfo: showInfo || selectedConfig.audioOptions.duplicateAudio,
      subtitle: selectedConfig.audioOptions.audioSource == AudioSource.output
          ? el.audioSection.source.info.default$
          : selectedConfig.audioOptions.duplicateAudio
              ? el.audioSection.source.info.inCaseOfDup
              : el.audioSection.source.info.alt(
                  source:
                      selectedConfig.audioOptions.audioSource.command.trimAll),
      items: [
        ...defaultSource,
        if (showExtraSource) Divider(child: Text('Extra').xSmall()),
        if (showExtraSource) ...extraSource
      ],
      popupWidthConstraint:
          showExtraSource ? PopoverConstraint.intrinsic : null,
      initialValue: selectedConfig.audioOptions.audioSource,
      itemBuilder: (context, value) => OverflowMarquee(
          duration: 3.seconds,
          delayDuration: 1.5.seconds,
          child: Text(value.value.toString().capitalizeFirst)),
      onSelected: selectedConfig.audioOptions.duplicateAudio
          ? null
          : (value) {
              ref
                  .read(configScreenConfig.notifier)
                  .setAudioConfig(audioSource: value!);
            },
    );
  }

  Widget _buildAudioFormatSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedConfig.isRecording &&
            selectedConfig.scrcpyMode == ScrcpyMode.audioOnly)
          ConfigDropdownEnum<AudioFormat>(
            items: AudioFormat.values,
            title: el.audioSection.format.label,
            subtitle: el.audioSection.format.info.default$(
                format: selectedConfig.audioOptions.audioFormat.value),
            showinfo: showInfo,
            initialValue: selectedConfig.audioOptions.audioFormat,
            toTitleCase: false,
            onSelected: _onFormatSelected,
          ),
        if (selectedConfig.isRecording &&
            selectedConfig.scrcpyMode == ScrcpyMode.audioOnly)
          const Divider(),
        ConfigDropdownOthers(
          initialValue: info.audioEncoder
              .firstWhere(
                  (ae) => ae.codec == selectedConfig.audioOptions.audioCodec,
                  orElse: () => info.audioEncoder.first)
              .codec,
          showinfo: showInfo || _isRecordingAudioOnly(selectedConfig),
          onSelected: _isRecordingAudioOnly(selectedConfig)
              ? null
              : (value) {
                  ref.read(configScreenConfig.notifier).setAudioConfig(
                        audioCodec: value,
                        audioEncoder: 'default',
                      );
                },
          items: [
            ...info.audioEncoder.map(
                (e) => SelectItemButton(value: e.codec, child: Text(e.codec))),
            if (selectedConfig.audioOptions.audioFormat != AudioFormat.m4a)
              const SelectItemButton(value: 'raw', child: Text('raw'))
          ],
          label: el.audioSection.codec.label,
          subtitle: _isRecordingAudioOnly(selectedConfig)
              ? el.audioSection.codec.info.isAudioOnly(
                  codec: selectedConfig.audioOptions.audioCodec,
                  format: selectedConfig.audioOptions.audioFormat.value)
              : selectedConfig.audioOptions.audioCodec == 'opus'
                  ? el.audioSection.codec.info.default$
                  : el.audioSection.codec.info
                      .alt(codec: selectedConfig.audioOptions.audioCodec),
        ),
        const Divider(),
        ConfigDropdownOthers(
          showinfo: showInfo,
          popupWidthConstraint: PopoverConstraint.intrinsic,
          initialValue: selectedConfig.audioOptions.audioEncoder == 'default'
              ? el.commonLoc.default$
              : selectedConfig.audioOptions.audioEncoder,
          onSelected: (value) {
            ref
                .read(configScreenConfig.notifier)
                .setAudioConfig(audioEncoder: value);
          },
          items: [
            SelectItemButton(
              value: 'default',
              child: Text(el.commonLoc.default$),
            ),
            if (selectedConfig.audioOptions.audioCodec != 'raw')
              ...info.audioEncoder
                  .firstWhere(
                      (ae) =>
                          ae.codec ==
                          ref.read(configScreenConfig)!.audioOptions.audioCodec,
                      orElse: () => info.audioEncoder.first)
                  .encoder
                  .map(
                    (enc) => SelectItemButton(
                      value: enc,
                      child: Text(enc),
                    ),
                  )
          ],
          label: el.audioSection.encoder.label,
          subtitle: selectedConfig.audioOptions.audioEncoder == 'default'
              ? el.audioSection.encoder.info.default$
              : el.audioSection.encoder.info
                  .alt(encoder: selectedConfig.audioOptions.audioEncoder),
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
      ref.read(configScreenConfig.notifier).setAudioConfig(audioCodec: 'raw');
    }

    if (value == AudioFormat.flac) {
      ref.read(configScreenConfig.notifier).setAudioConfig(audioCodec: 'flac');
    }

    if (value == AudioFormat.aac) {
      ref.read(configScreenConfig.notifier).setAudioConfig(audioCodec: 'aac');
    }

    if (value == AudioFormat.opus) {
      ref.read(configScreenConfig.notifier).setAudioConfig(audioCodec: 'opus');
    }

    if (value == AudioFormat.m4a) {
      ref.read(configScreenConfig.notifier).setAudioConfig(audioCodec: 'opus');
    }

    ref.read(configScreenConfig.notifier).setAudioConfig(audioFormat: value);
  }

  Widget _buildAudioBitrate(BuildContext context) {
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigUserInput(
        label: el.audioSection.bitrate.label,
        showinfo: showInfo,
        controller: audioBitrateController,
        unit: 'K',
        onChanged: (value) {
          if (value.isEmpty) {
            ref
                .read(configScreenConfig.notifier)
                .setAudioConfig(audioBitrate: 128);
            audioBitrateController.text = '128';
            setState(() {});
          } else {
            ref
                .read(configScreenConfig.notifier)
                .setAudioConfig(audioBitrate: int.parse(value));
          }
        },
        onTap: () => setState(() {
              audioBitrateController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: audioBitrateController.text.length);
            }),
        subtitle: audioBitrateController.text == '128'
            ? el.audioSection.bitrate.info.default$
            : el.audioSection.bitrate.info
                .alt(bitrate: audioBitrateController.text.trim()));
  }
}
