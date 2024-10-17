import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/body_container.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/custom_slider_track_shape.dart';

class ThemeSectionAdvanced extends ConsumerStatefulWidget {
  const ThemeSectionAdvanced({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ThemeSectionAdvancedState();
}

class _ThemeSectionAdvancedState extends ConsumerState<ThemeSectionAdvanced> {
  @override
  Widget build(BuildContext context) {
    final looks = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: appWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BodyContainer(
                children: [
                  BodyContainerItem(
                    title: 'Background tint level',
                    trailing: SliderTheme(
                      data: SliderThemeData(
                        trackShape: CustomTrackShape(),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5),
                        activeTrackColor: colorScheme.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'Default',
                            onPressed: () async {
                              final currentTint = looks.tintLevel;
                              ref.read(settingsProvider.notifier).update(
                                  (state) => state = state.copyWith(
                                      looks: state.looks.copyWith(
                                          tintLevel: currentTint.copyWith(
                                              surfaceTintLevel: defaultTheme
                                                  .tintLevel
                                                  .surfaceTintLevel))));

                              final newSettings = ref.read(settingsProvider);
                              await AppUtils.saveAppSettings(newSettings);
                            },
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            child: Slider(
                              divisions: 100,
                              min: 0,
                              max: 100,
                              value:
                                  looks.tintLevel.surfaceTintLevel.toDouble(),
                              onChangeEnd: (value) async {
                                final newSettings = ref.read(settingsProvider);
                                await AppUtils.saveAppSettings(newSettings);
                              },
                              onChanged: (v) {
                                final currentTint = looks.tintLevel;
                                ref.read(settingsProvider.notifier).update(
                                    (state) => state = state.copyWith(
                                        looks: state.looks.copyWith(
                                            tintLevel: currentTint.copyWith(
                                                surfaceTintLevel: v.toInt()))));
                              },
                            ),
                          ),
                          SizedBox(
                              width: 30,
                              child: Text(looks.tintLevel.surfaceTintLevel
                                      .toInt()
                                      .toString())
                                  .alignAtCenterRight())
                        ],
                      ),
                    ),
                  ),
                  BodyContainerItem(
                    title: 'Primary tint level',
                    trailing: SliderTheme(
                      data: SliderThemeData(
                        trackShape: CustomTrackShape(),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5),
                        activeTrackColor: colorScheme.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'Default',
                            onPressed: () async {
                              final currentTint = looks.tintLevel;
                              ref.read(settingsProvider.notifier).update(
                                  (state) => state = state.copyWith(
                                      looks: state.looks.copyWith(
                                          tintLevel: currentTint.copyWith(
                                              primaryTintLevel: defaultTheme
                                                  .tintLevel
                                                  .primaryTintLevel))));

                              final newSettings = ref.read(settingsProvider);
                              await AppUtils.saveAppSettings(newSettings);
                            },
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            child: Slider(
                              divisions: 100,
                              min: 0,
                              max: 100,
                              value:
                                  looks.tintLevel.primaryTintLevel.toDouble(),
                              onChangeEnd: (value) async {
                                final newSettings = ref.read(settingsProvider);
                                await AppUtils.saveAppSettings(newSettings);
                              },
                              onChanged: (v) {
                                final currentTint = looks.tintLevel;
                                ref.read(settingsProvider.notifier).update(
                                    (state) => state = state.copyWith(
                                        looks: state.looks.copyWith(
                                            tintLevel: currentTint.copyWith(
                                                primaryTintLevel: v.toInt()))));
                              },
                            ),
                          ),
                          SizedBox(
                              width: 30,
                              child: Text(looks.tintLevel.primaryTintLevel
                                      .toInt()
                                      .toString())
                                  .alignAtCenterRight())
                        ],
                      ),
                    ),
                  ),
                  BodyContainerItem(
                    title: 'Secondary tint level',
                    trailing: SliderTheme(
                      data: SliderThemeData(
                        trackShape: CustomTrackShape(),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5),
                        activeTrackColor: colorScheme.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'Default',
                            onPressed: () async {
                              final currentTint = looks.tintLevel;
                              ref.read(settingsProvider.notifier).update(
                                  (state) => state = state.copyWith(
                                      looks: state.looks.copyWith(
                                          tintLevel: currentTint.copyWith(
                                              secondaryTintLevel: defaultTheme
                                                  .tintLevel
                                                  .secondaryTintLevel))));

                              final newSettings = ref.read(settingsProvider);
                              await AppUtils.saveAppSettings(newSettings);
                            },
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            child: Slider(
                              divisions: 100,
                              min: 0,
                              max: 100,
                              value:
                                  looks.tintLevel.secondaryTintLevel.toDouble(),
                              onChangeEnd: (value) async {
                                final newSettings = ref.read(settingsProvider);
                                await AppUtils.saveAppSettings(newSettings);
                              },
                              onChanged: (v) {
                                final currentTint = looks.tintLevel;
                                ref.read(settingsProvider.notifier).update(
                                    (state) => state = state.copyWith(
                                        looks: state.looks.copyWith(
                                            tintLevel: currentTint.copyWith(
                                                secondaryTintLevel:
                                                    v.toInt()))));
                              },
                            ),
                          ),
                          SizedBox(
                              width: 30,
                              child: Text(looks.tintLevel.secondaryTintLevel
                                      .toInt()
                                      .toString())
                                  .alignAtCenterRight())
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // const Text('Preview'),
              // Expanded(
              //   child: Container(
              //     width: appWidth,
              //     decoration: BoxDecoration(
              //       color: Colors.grey,
              //       borderRadius: BorderRadius.circular(looks.widgetRadius),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: SizedBox.expand(
              //         child: Stack(
              //           children: [
              //             Container(
              //               decoration: BoxDecoration(
              //                 color: colorScheme.surface,
              //                 borderRadius:
              //                     BorderRadius.circular(looks.widgetRadius),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(32.0),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.stretch,
              //                   children: [
              //                     Container(
              //                       height: 70,
              //                       decoration: BoxDecoration(
              //                         color: colorScheme.primaryContainer,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             const Padding(
              //               padding: EdgeInsets.all(4.0),
              //               child: Text('Surface'),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
