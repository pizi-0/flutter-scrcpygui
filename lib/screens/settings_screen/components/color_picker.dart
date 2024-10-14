import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/const.dart';

class MyColorPicker extends ConsumerStatefulWidget {
  const MyColorPicker({super.key});

  @override
  ConsumerState<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends ConsumerState<MyColorPicker> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider.select((s) => s.looks));

    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(settings.widgetRadius * 0.8),
          // border:
          //     Border.all(color: ref.watch(settingsProvider.select((s)=> s.looks)).color, width: 2),
        ),
        width: appWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: appWidth,
                maxHeight: appWidth,
              ),
              child: SingleChildScrollView(
                child: ColorPicker(
                  color:
                      ref.watch(settingsProvider.select((s) => s.looks)).color,
                  heading: const Text('Colors'),
                  pickersEnabled: const {
                    ColorPickerType.accent: true,
                    ColorPickerType.primary: false,
                  },
                  borderColor: Colors.black,
                  hasBorder: true,
                  subheading: const Text('Shades'),
                  enableShadesSelection: true,
                  onColorChanged: (col) async {
                    final currentSettings = ref.read(settingsProvider);
                    final currentLooks = currentSettings.looks;

                    ref.read(settingsProvider.notifier).update((state) =>
                        state = state.copyWith(
                            looks: currentLooks.copyWith(color: col)));
                    AppUtils.saveAppSettings(currentSettings.copyWith(
                        looks: currentLooks.copyWith(color: col)));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
