import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/section_button.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/const.dart';
import '../../../widgets/body_container.dart';
import '../../../widgets/custom_slider_track_shape.dart';
import 'color_picker.dart';

class ThemeSection extends ConsumerStatefulWidget {
  const ThemeSection({super.key});

  @override
  ConsumerState<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends ConsumerState<ThemeSection> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final looks = ref.watch(settingsProvider.select((s) => s.looks));
    final advancedVisible = ref.watch(advancedThemingVisible);

    return BodyContainer(
      spacing: 4,
      height: (44 * (advancedVisible ? 6 : 3)) + 4,
      headerTitle: 'Theme',
      headerTrailing: TextButton.icon(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(15),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 10)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(looks.widgetRadius))),
          // padding: const WidgetStatePropertyAll(EdgeInsets.all(2)),
        ),
        onPressed: () => setState(() =>
            ref.read(advancedThemingVisible.notifier).state = !advancedVisible),
        label: advancedVisible ? const Text('Less') : const Text('More'),
        icon: advancedVisible
            ? const Icon(Icons.expand_less_rounded)
            : const Icon(Icons.expand_more_rounded),
        iconAlignment: IconAlignment.end,
      ),
      children: [
        ConfigCustom(
          childBackgroundColor: Colors.transparent,
          title: 'Brightness',
          child: Row(
            children: [
              Radio(
                activeColor: colorScheme.primary,
                value: Brightness.dark,
                groupValue: looks.brightness,
                onChanged: (val) {
                  final currentSettings = ref.read(settingsProvider);
                  final currentLooks = currentSettings.looks;

                  ref.read(settingsProvider.notifier).update((state) => state =
                      state.copyWith(
                          looks: currentLooks.copyWith(brightness: val)));

                  AppUtils.saveAppSettings(currentSettings.copyWith(
                      looks: currentLooks.copyWith(brightness: val)));
                },
              ),
              const Text('Dark').textColor(colorScheme.inverseSurface),
              const SizedBox(width: 10),
              Radio(
                activeColor: colorScheme.primary,
                value: Brightness.light,
                groupValue: looks.brightness,
                onChanged: (val) {
                  final currentSettings = ref.read(settingsProvider);
                  final currentLooks = currentSettings.looks;

                  ref.read(settingsProvider.notifier).update((state) => state =
                      state.copyWith(
                          looks: currentLooks.copyWith(brightness: val)));

                  AppUtils.saveAppSettings(currentSettings.copyWith(
                      looks: currentLooks.copyWith(brightness: val)));
                },
              ),
              const Text('Light').textColor(colorScheme.inverseSurface),
            ],
          ),
        ),
        ConfigCustom(
          childBackgroundColor: Colors.transparent,
          title: 'Color',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SectionButton(
                iconSize: 20,
                ontap: () async {
                  ref.read(settingsProvider.notifier).update((state) => state =
                      state.copyWith(
                          looks:
                              state.looks.copyWith(color: defaultTheme.color)));

                  final newSettings = ref.read(settingsProvider);
                  await AppUtils.saveAppSettings(newSettings);
                },
                icondata: Icons.refresh_rounded,
              ),
              InkWell(
                onTap: () async {
                  await showAdaptiveDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return const MyColorPicker();
                    },
                  );
                },
                child: Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(looks.widgetRadius * 0.8),
                    border: Border.all(color: Colors.black),
                    color: looks.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        ConfigCustom(
          childBackgroundColor: Colors.transparent,
          title: 'Corner radius',
          child: SliderTheme(
            data: SliderThemeData(
              trackShape: CustomTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              activeTrackColor: colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SectionButton(
                  iconSize: 20,
                  ontap: () async {
                    ref.read(settingsProvider.notifier).update((state) =>
                        state = state.copyWith(
                            looks: state.looks.copyWith(
                                widgetRadius: defaultTheme.widgetRadius)));

                    final newSettings = ref.read(settingsProvider);
                    await AppUtils.saveAppSettings(newSettings);
                  },
                  icondata: Icons.refresh_rounded,
                ),
                SizedBox(
                  width: 100,
                  child: Slider(
                    divisions: 15,
                    min: 0,
                    max: 15,
                    value: looks.widgetRadius,
                    onChangeEnd: (value) async {
                      final newSettings = ref.read(settingsProvider);
                      await AppUtils.saveAppSettings(newSettings);
                    },
                    onChanged: (v) {
                      ref.read(settingsProvider.notifier).update((state) =>
                          state = state.copyWith(
                              looks: state.looks.copyWith(widgetRadius: v)));
                    },
                  ),
                ),
                SizedBox(
                    width: 30,
                    child: Text(looks.widgetRadius.toInt().toString())
                        .textColor(colorScheme.inverseSurface)
                        .alignAtCenterRight())
              ],
            ),
          ),
        ),
        ConfigCustom(
          childBackgroundColor: Colors.transparent,
          title: 'Background tint level',
          child: SliderTheme(
            data: SliderThemeData(
              trackShape: CustomTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              activeTrackColor: colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SectionButton(
                  iconSize: 20,
                  ontap: () async {
                    final currentTint = looks.tintLevel;
                    ref.read(settingsProvider.notifier).update((state) =>
                        state = state.copyWith(
                            looks: state.looks.copyWith(
                                tintLevel: currentTint.copyWith(
                                    surfaceTintLevel: defaultTheme
                                        .tintLevel.surfaceTintLevel))));

                    final newSettings = ref.read(settingsProvider);
                    await AppUtils.saveAppSettings(newSettings);
                  },
                  icondata: Icons.refresh_rounded,
                ),
                SizedBox(
                  width: 100,
                  child: Slider(
                    divisions: 100,
                    min: 0,
                    max: 100,
                    value: looks.tintLevel.surfaceTintLevel.toDouble(),
                    onChangeEnd: (value) async {
                      final newSettings = ref.read(settingsProvider);
                      await AppUtils.saveAppSettings(newSettings);
                    },
                    onChanged: (v) {
                      final currentTint = looks.tintLevel;
                      ref.read(settingsProvider.notifier).update((state) =>
                          state = state.copyWith(
                              looks: state.looks.copyWith(
                                  tintLevel: currentTint.copyWith(
                                      surfaceTintLevel: v.toInt()))));
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  child:
                      Text(looks.tintLevel.surfaceTintLevel.toInt().toString())
                          .textColor(colorScheme.inverseSurface)
                          .alignAtCenterRight(),
                )
              ],
            ),
          ),
        ),
        ConfigCustom(
          childBackgroundColor: Colors.transparent,
          title: 'Primary tint level',
          child: SliderTheme(
            data: SliderThemeData(
              trackShape: CustomTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              activeTrackColor: colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SectionButton(
                  iconSize: 20,
                  tooltipmessage: 'Default',
                  ontap: () async {
                    final currentTint = looks.tintLevel;
                    ref.read(settingsProvider.notifier).update((state) =>
                        state = state.copyWith(
                            looks: state.looks.copyWith(
                                tintLevel: currentTint.copyWith(
                                    primaryTintLevel: defaultTheme
                                        .tintLevel.primaryTintLevel))));

                    final newSettings = ref.read(settingsProvider);
                    await AppUtils.saveAppSettings(newSettings);
                  },
                  icondata: Icons.refresh_rounded,
                ),
                SizedBox(
                  width: 100,
                  child: Slider(
                    divisions: 100,
                    min: 0,
                    max: 100,
                    value: looks.tintLevel.primaryTintLevel.toDouble(),
                    onChangeEnd: (value) async {
                      final newSettings = ref.read(settingsProvider);
                      await AppUtils.saveAppSettings(newSettings);
                    },
                    onChanged: (v) {
                      final currentTint = looks.tintLevel;
                      ref.read(settingsProvider.notifier).update((state) =>
                          state = state.copyWith(
                              looks: state.looks.copyWith(
                                  tintLevel: currentTint.copyWith(
                                      primaryTintLevel: v.toInt()))));
                    },
                  ),
                ),
                SizedBox(
                    width: 30,
                    child: Text(
                            looks.tintLevel.primaryTintLevel.toInt().toString())
                        .textColor(colorScheme.inverseSurface)
                        .alignAtCenterRight())
              ],
            ),
          ),
        ),
        ConfigCustom(
          childBackgroundColor: Colors.transparent,
          title: 'Secondary tint level',
          child: SliderTheme(
            data: SliderThemeData(
              trackShape: CustomTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SectionButton(
                  iconSize: 20,
                  tooltipmessage: 'Default',
                  ontap: () async {
                    final currentTint = looks.tintLevel;
                    ref.read(settingsProvider.notifier).update((state) =>
                        state = state.copyWith(
                            looks: state.looks.copyWith(
                                tintLevel: currentTint.copyWith(
                                    secondaryTintLevel: defaultTheme
                                        .tintLevel.secondaryTintLevel))));

                    final newSettings = ref.read(settingsProvider);
                    await AppUtils.saveAppSettings(newSettings);
                  },
                  icondata: Icons.refresh_rounded,
                ),
                SizedBox(
                  width: 100,
                  child: Slider(
                    divisions: 100,
                    min: 0,
                    max: 100,
                    value: looks.tintLevel.secondaryTintLevel.toDouble(),
                    onChangeEnd: (value) async {
                      final newSettings = ref.read(settingsProvider);
                      await AppUtils.saveAppSettings(newSettings);
                    },
                    onChanged: (v) {
                      final currentTint = looks.tintLevel;
                      ref.read(settingsProvider.notifier).update((state) =>
                          state = state.copyWith(
                              looks: state.looks.copyWith(
                                  tintLevel: currentTint.copyWith(
                                      secondaryTintLevel: v.toInt()))));
                    },
                  ),
                ),
                SizedBox(
                    width: 30,
                    child: Text(looks.tintLevel.secondaryTintLevel
                            .toInt()
                            .toString())
                        .textColor(colorScheme.inverseSurface)
                        .alignAtCenterRight())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
