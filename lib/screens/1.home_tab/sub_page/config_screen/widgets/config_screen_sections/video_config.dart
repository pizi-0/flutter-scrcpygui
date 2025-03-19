import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/adb_provider.dart';

import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../../providers/config_provider.dart';
import '../../../../../../utils/const.dart';
import '../../../../../../widgets/config_tiles.dart';

class VideoConfig extends ConsumerStatefulWidget {
  const VideoConfig({super.key});

  @override
  ConsumerState<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends ConsumerState<VideoConfig> {
  late TextEditingController videoBitrateController;
  late TextEditingController maxFPSController;
  late TextEditingController vdResolutionController;
  late TextEditingController vdDPIController;

  @override
  void initState() {
    final selectedConfig = ref.read(configScreenConfig)!;

    videoBitrateController = TextEditingController(
        text: selectedConfig.videoOptions.videoBitrate.toString());

    maxFPSController = TextEditingController(
        text: selectedConfig.videoOptions.maxFPS == 0
            ? '-'
            : selectedConfig.videoOptions.maxFPS.toString());

    vdResolutionController = TextEditingController(
      text: selectedConfig.videoOptions.virtualDisplayOptions?.resolution ?? '',
    );

    vdDPIController = TextEditingController(
      text: selectedConfig.videoOptions.virtualDisplayOptions?.dpi ?? '',
    );
    super.initState();
  }

  @override
  void dispose() {
    videoBitrateController.dispose();
    maxFPSController.dispose();
    vdResolutionController.dispose();
    vdDPIController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);

    return PgSectionCard(
      label: el.videoSection.title,
      children: [
        _buildDisplaySelector(selectedConfig, selectedDevice!.info!),
        const Divider(),
        _buildVideoCodecNFormatSelector(
            context, selectedConfig, selectedDevice.info!),
        const Divider(),
        _buildVideoBitrate(context),
        const Divider(),
        _buildMaxFPS(selectedConfig),
        if (selectedConfig.videoOptions.displayId != 'new') const Divider(),
        if (selectedConfig.videoOptions.displayId != 'new')
          _buildResolutionScale(selectedConfig, selectedDevice.info!),
      ],
    );
  }

  Widget _buildMaxFPS(ScrcpyConfig selectedConfig) {
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigUserInput(
      label: el.videoSection.fpsLimit.label,
      showinfo: showInfo,
      subtitle: maxFPSController.text == '-'
          ? el.videoSection.fpsLimit.info.default$
          : el.videoSection.fpsLimit.info
              .alt(fps: maxFPSController.text.trim()),
      controller: maxFPSController,
      unit: 'fps',
      onTap: () => setState(() {
        maxFPSController.selection = TextSelection(
            baseOffset: 0, extentOffset: maxFPSController.text.length);
      }),
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(configScreenConfig.notifier).setVideoConfig(maxFPS: 0);

          setState(() {
            maxFPSController.text = '-';
          });
        } else {
          ref
              .read(configScreenConfig.notifier)
              .setVideoConfig(maxFPS: double.parse(value));
        }
      },
    );
  }

  Widget _buildDisplaySelector(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    final displays =
        info.displays.where((d) => (int.tryParse(d.id) ?? 11) < 10).toList();

    final displayDD = [
      ...displays.map((d) => (d.id, d.id)),
      ('new', 'New display'),
    ];

    return Column(
      spacing: 8,
      children: [
        ConfigCustom(
          dimTitle: false,
          title: el.videoSection.displays.label,
          showinfo: showInfo,
          subtitle: selectedConfig.videoOptions.displayId == 'new'
              ? el.videoSection.displays.virtual.newDisplay.info.alt
              : selectedConfig.videoOptions.displayId == '0'
                  ? el.videoSection.displays.info.default$
                  : el.videoSection.displays.info.alt,
          child: Select(
            filled: true,
            onChanged: (value) {
              ref
                  .read(configScreenConfig.notifier)
                  .setVideoConfig(displayId: value!.$1);
            },
            value: displayDD.firstWhere(
                (d) => d.$1 == selectedConfig.videoOptions.displayId),
            popup: SelectPopup(
              items: SelectItemList(
                children: displayDD
                    .map((d) => SelectItemButton(value: d, child: Text(d.$2)))
                    .toList(),
              ),
            ).call,
            itemBuilder: (context, value) => Text(value.$2),
          ),
        ),
        if (selectedConfig.videoOptions.displayId == 'new') const Divider(),
        if (selectedConfig.videoOptions.displayId == 'new')
          Card(
            borderRadius: Theme.of(context).borderRadiusMd,
            filled: true,
            padding: EdgeInsets.all(8),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(child: Text(el.videoSection.displays.virtual.label))
                    .small(),
                PgSectionCard(
                  cardPadding: EdgeInsets.all(8),
                  children: [
                    ConfigUserInput(
                      placeholder: Text('eg: 1920x1080'),
                      inputFormatters: [],
                      showinfo: showInfo,
                      label: el.videoSection.displays.virtual.resolution.label,
                      subtitle: selectedConfig.videoOptions
                                      .virtualDisplayOptions?.resolution ==
                                  null ||
                              vdResolutionController.text.isEmpty ||
                              !selectedConfig
                                  .videoOptions
                                  .virtualDisplayOptions!
                                  .resolution!
                                  .isValidResolution
                          ? el.videoSection.displays.virtual.resolution.info
                              .default$
                          : el.videoSection.displays.virtual.resolution.info
                              .alt(res: vdResolutionController.text),
                      controller: vdResolutionController,
                      onChanged: _onVdResolutionChanged,
                    ),
                    Divider(),
                    ConfigUserInput(
                      placeholder: Text('eg: 420'),
                      showinfo: showInfo,
                      label: el.videoSection.displays.virtual.dpi.label,
                      subtitle: selectedConfig.videoOptions
                                      .virtualDisplayOptions?.dpi ==
                                  null ||
                              vdDPIController.text.isEmpty
                          ? el.videoSection.displays.virtual.dpi.info.default$
                          : el.videoSection.displays.virtual.dpi.info.alt(
                              dpi: vdDPIController.text,
                              res: vdResolutionController.text),
                      controller: vdDPIController,
                      onChanged: _onVdDpiChanged,
                    ),
                    Divider(),
                    ConfigCustom(
                      title: el.videoSection.displays.virtual.deco.label,
                      subtitle: selectedConfig.videoOptions
                                  .virtualDisplayOptions?.disableDecorations ??
                              false
                          ? el.videoSection.displays.virtual.deco.info.alt
                          : el.videoSection.displays.virtual.deco.info.default$,
                      showinfo: showInfo,
                      childExpand: false,
                      onPressed: _onVdDisableDecoChanged,
                      child: Checkbox(
                        state: (selectedConfig
                                        .videoOptions.virtualDisplayOptions ??
                                    defaultVdOptions)
                                .disableDecorations
                            ? CheckboxState.checked
                            : CheckboxState.unchecked,
                        onChanged: (val) => _onVdDisableDecoChanged(),
                      ),
                    ),
                    Divider(),
                    ConfigCustom(
                      title: el.videoSection.displays.virtual.preserve.label,
                      subtitle: selectedConfig.videoOptions
                                  .virtualDisplayOptions?.preseveContent ??
                              false
                          ? el.videoSection.displays.virtual.preserve.info.alt
                          : el.videoSection.displays.virtual.preserve.info
                              .default$,
                      showinfo: showInfo,
                      childExpand: false,
                      onPressed: _onVdDestroyContentChanged,
                      child: Checkbox(
                        state: (selectedConfig
                                        .videoOptions.virtualDisplayOptions ??
                                    defaultVdOptions)
                                .preseveContent
                            ? CheckboxState.checked
                            : CheckboxState.unchecked,
                        onChanged: (value) => _onVdDestroyContentChanged(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // if (selectedConfig.videoOptions.displayId == 'new') const Divider(),
        // if (selectedConfig.videoOptions.displayId == 'new')
        //   ConfigUserInput(
        //     placeholder: Text('eg: 1920x1080'),
        //     inputFormatters: [],
        //     showinfo: showInfo,
        //     label: el.videoSection.displays.virtual.resolution.label,
        //     subtitle: selectedConfig.videoOptions.vdResolution == null ||
        //             vdResolutionController.text.isEmpty ||
        //             !selectedConfig.videoOptions.vdResolution!.isValidResolution
        //         ? el.videoSection.displays.virtual.resolution.info.default$
        //         : el.videoSection.displays.virtual.resolution.info
        //             .alt(res: vdResolutionController.text),
        //     controller: vdResolutionController,
        //     onChanged: (value) {
        //       ref.read(configScreenConfig.notifier).update((state) => state =
        //           state!.copyWith(
        //               videoOptions:
        //                   state.videoOptions.copyWith(vdResolution: value)));
        //     },
        //   ),
        // if (selectedConfig.videoOptions.displayId == 'new') const Divider(),
        // if (selectedConfig.videoOptions.displayId == 'new')
        //   ConfigUserInput(
        //     placeholder: Text('eg: 420'),
        //     showinfo: showInfo,
        //     label: el.videoSection.displays.virtual.dpi.label,
        //     subtitle: selectedConfig.videoOptions.vdDPI == null ||
        //             vdDPIController.text.isEmpty
        //         ? el.videoSection.displays.virtual.dpi.info.default$
        //         : el.videoSection.displays.virtual.dpi.info.alt(
        //             dpi: vdDPIController.text,
        //             res: vdResolutionController.text),
        //     controller: vdDPIController,
        //     onChanged: (value) {
        //       ref.read(configScreenConfig.notifier).update((state) => state =
        //           state!.copyWith(
        //               videoOptions: state.videoOptions.copyWith(vdDPI: value)));
        //     },
        //   )
      ],
    );
  }

  _onVdResolutionChanged(value) {
    ref
        .read(configScreenConfig.notifier)
        .setVirtDisplayConfig(resolution: value);
  }

  _onVdDpiChanged(value) {
    ref.read(configScreenConfig.notifier).setVirtDisplayConfig(dpi: value);
  }

  _onVdDisableDecoChanged() {
    final selectedConfig = ref.read(configScreenConfig)!;

    var currentVdOptions =
        selectedConfig.videoOptions.virtualDisplayOptions ?? defaultVdOptions;

    ref.read(configScreenConfig.notifier).setVirtDisplayConfig(
        disableDecorations: !currentVdOptions.disableDecorations);
  }

  _onVdDestroyContentChanged() {
    final selectedConfig = ref.read(configScreenConfig)!;

    var currentVdOptions =
        selectedConfig.videoOptions.virtualDisplayOptions ?? defaultVdOptions;

    ref
        .read(configScreenConfig.notifier)
        .setVirtDisplayConfig(preseveContent: !currentVdOptions.preseveContent);
  }

  Widget _buildResolutionScale(ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    final displaySize = info.displays
        .firstWhere(
            (f) => f.id == selectedConfig.videoOptions.displayId.toString())
        .resolution
        .split('x');

    final max = displaySize.map((e) => int.parse(e.removeLetters!)).toList();
    max.sort((a, b) => b.compareTo(a));

    return ConfigCustom(
      dimTitle: false,
      title: el.videoSection.resolutionScale.label,
      showinfo:
          showInfo || selectedConfig.videoOptions.resolutionScale != 100.0,
      subtitle: selectedConfig.videoOptions.resolutionScale == 1.0
          ? el.videoSection.resolutionScale.info.default$
          : el.videoSection.resolutionScale.info.alt(
              size: ((selectedConfig.videoOptions.resolutionScale / 100) *
                      max.first)
                  .toStringAsFixed(0)),
      childExpand: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 180, maxWidth: 180),
        child: Row(
          spacing: 4,
          children: [
            Text('${selectedConfig.videoOptions.resolutionScale.toInt()}%')
                .small(),
            Expanded(
              child: Slider(
                value: SliderValue.single(
                    selectedConfig.videoOptions.resolutionScale),
                max: 100,
                min: 30,
                divisions: 70,
                onChanged: (value) {
                  ref
                      .read(configScreenConfig.notifier)
                      .setVideoConfig(resolutionScale: value.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCodecNFormatSelector(
      BuildContext context, ScrcpyConfig selectedConfig, ScrcpyInfo info) {
    final showInfo = ref.watch(configScreenShowInfo);

    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfigDropdownOthers(
          showinfo: showInfo,
          initialValue: selectedConfig.videoOptions.videoCodec,
          onSelected: (value) {
            ref
                .read(configScreenConfig.notifier)
                .setVideoConfig(videoCodec: value, videoEncoder: 'default');
          },
          items: info.videoEncoders
              .map(
                  (e) => SelectItemButton(value: e.codec, child: Text(e.codec)))
              .toList(),
          label: el.videoSection.codec.label,
          subtitle: selectedConfig.videoOptions.videoCodec == 'h264'
              ? el.videoSection.codec.info.default$
              : el.videoSection.codec.info
                  .alt(codec: selectedConfig.videoOptions.videoCodec),
        ),
        const Divider(),
        ConfigDropdownOthers(
          showinfo: showInfo,
          popupWidthConstraint: PopoverConstraint.intrinsic,
          initialValue: selectedConfig.videoOptions.videoEncoder == 'default'
              ? el.commonLoc.default$
              : selectedConfig.videoOptions.videoEncoder,
          onSelected: (value) {
            ref
                .read(configScreenConfig.notifier)
                .setVideoConfig(videoEncoder: value);
          },
          items: [
            SelectItemButton(
              value: 'default',
              child: OverflowMarquee(
                duration: 2.seconds,
                child: Text(el.commonLoc.default$),
              ),
            ),
            ...info.videoEncoders
                .firstWhere((ve) =>
                    ve.codec ==
                    ref.read(configScreenConfig)!.videoOptions.videoCodec)
                .encoder
                .map(
                  (enc) => SelectItemButton(
                    value: enc,
                    child: OverflowMarquee(
                      duration: 2.seconds,
                      delayDuration: 1.seconds,
                      child: Text(enc),
                    ),
                  ),
                )
          ],
          label: el.videoSection.encoder.label,
          subtitle: selectedConfig.videoOptions.videoEncoder == 'default'
              ? el.videoSection.encoder.info.default$
              : el.videoSection.encoder.info
                  .alt(encoder: selectedConfig.videoOptions.videoEncoder),
        ),
        if (selectedConfig.isRecording) const Divider(),
        if (selectedConfig.isRecording)
          FadeIn(
            child: ConfigDropdownEnum<VideoFormat>(
              showinfo: showInfo,
              items: VideoFormat.values,
              title: el.videoSection.format.label,
              subtitle: el.videoSection.format.info.default$(
                  format: selectedConfig.videoOptions.videoFormat.command),
              initialValue: selectedConfig.videoOptions.videoFormat,
              toTitleCase: false,
              onSelected: (value) => ref
                  .read(configScreenConfig.notifier)
                  .setVideoConfig(videoFormat: value),
            ),
          )
      ],
    );
  }

  Widget _buildVideoBitrate(BuildContext context) {
    final showInfo = ref.watch(configScreenShowInfo);

    return ConfigUserInput(
      label: el.videoSection.bitrate.label,
      subtitle: videoBitrateController.text == '8'
          ? el.videoSection.bitrate.info.default$
          : el.videoSection.bitrate.info
              .alt(bitrate: videoBitrateController.text.trimAll),
      controller: videoBitrateController,
      showinfo: showInfo,
      unit: 'M',
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(configScreenConfig.notifier).setVideoConfig(videoBitrate: 8);

          videoBitrateController.text = '8';
          setState(() {});
        } else {
          ref
              .read(configScreenConfig.notifier)
              .setVideoConfig(videoBitrate: int.parse(value));
        }
      },
      onTap: () => setState(() {
        videoBitrateController.selection = TextSelection(
            baseOffset: 0, extentOffset: videoBitrateController.text.length);
      }),
    );
  }
}
