import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/audio_options.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';

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
    final selectedConfig = ref.watch(configScreenConfig)!;
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Mode',
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
                _buildMainModeSelector(ref, context, selectedConfig),
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
      WidgetRef ref, BuildContext context, ScrcpyConfig selectedConfig) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

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

                  ref.read(configScreenConfig.notifier).update((state) =>
                      state = state!.copyWith(isRecording: isRecording));

                  modeLabel = value!.value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 4),
              ConfigCustom(
                label: 'Save folder',
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(appTheme.widgetRadius * 0.8),
                  child: Tooltip(
                    message: selectedConfig.savePath ?? '',
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(appTheme.widgetRadius * 0.8),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final res =
                              await FilePicker.platform.getDirectoryPath();

                          if (res != null) {
                            ref.read(configScreenConfig.notifier).update(
                                (state) =>
                                    state = state!.copyWith(savePath: res));
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.folder,
                                size: 15,
                                color: colorScheme.inverseSurface,
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
