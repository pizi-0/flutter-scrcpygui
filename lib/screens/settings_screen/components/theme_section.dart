import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late double radius;

  @override
  void initState() {
    radius = ref.read(settingsProvider.select((s) => s.looks)).widgetRadius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return BodyContainer(
      headerTitle: 'Theme',
      children: [
        BodyContainerItem(
          title: 'Brightness',
          trailing: Row(
            children: [
              Radio(
                activeColor: colorScheme.inversePrimary,
                value: Brightness.dark,
                groupValue: appTheme.brightness,
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
              const Text('Dark'),
              const SizedBox(width: 10),
              Radio(
                activeColor: colorScheme.inversePrimary,
                value: Brightness.light,
                groupValue: appTheme.brightness,
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
              const Text('Light'),
            ],
          ),
        ),
        BodyContainerItem(
          title: 'Color',
          trailing: Row(
            children: [
              IconButton(
                tooltip: 'Default',
                onPressed: () async {
                  ref.read(settingsProvider.notifier).update((state) => state =
                      state.copyWith(
                          looks:
                              state.looks.copyWith(color: defaultTheme.color)));

                  final newSettings = ref.read(settingsProvider);
                  await AppUtils.saveAppSettings(newSettings);
                },
                icon: const Icon(Icons.refresh_rounded),
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
                        BorderRadius.circular(appTheme.widgetRadius * 0.8),
                    border: Border.all(color: Colors.black),
                    color: appTheme.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        BodyContainerItem(
          title: 'Corner radius',
          trailing: SliderTheme(
            data: SliderThemeData(
              trackShape: CustomTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Default: 10',
                  onPressed: () async {
                    ref.read(settingsProvider.notifier).update((state) =>
                        state = state.copyWith(
                            looks: state.looks.copyWith(
                                widgetRadius: defaultTheme.widgetRadius)));

                    setState(() {
                      radius = defaultTheme.widgetRadius;
                    });

                    final newSettings = ref.read(settingsProvider);
                    await AppUtils.saveAppSettings(newSettings);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                ),
                SizedBox(
                  width: 150,
                  child: Slider(
                    divisions: 15,
                    min: 0,
                    max: 15,
                    value: radius,
                    onChangeEnd: (value) async {
                      final newSettings = ref.read(settingsProvider);
                      await AppUtils.saveAppSettings(newSettings);
                    },
                    onChanged: (v) {
                      radius = v;
                      setState(() {});
                      ref.read(settingsProvider.notifier).update((state) =>
                          state = state.copyWith(
                              looks: state.looks.copyWith(widgetRadius: v)));
                    },
                  ),
                ),
                SizedBox(
                    width: 30,
                    child: Text(radius.toInt().toString()).alignAtCenterRight())
              ],
            ),
          ),
        )
      ],
    );
  }
}
