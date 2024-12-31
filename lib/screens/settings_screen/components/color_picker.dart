import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/extension.dart';

import '../../../providers/settings_provider.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/const.dart';

class MyColorPicker extends ConsumerStatefulWidget {
  const MyColorPicker({super.key});

  @override
  ConsumerState<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends ConsumerState<MyColorPicker> {
  TextEditingController customColor = TextEditingController();
  late AnimationController anim;
  late String hexValue;

  @override
  void initState() {
    hexValue = ColorExtension(ref.read(settingsProvider).looks.color).hex;
    customColor.text =
        ColorExtension(ref.read(settingsProvider).looks.color).hex;
    super.initState();
  }

  @override
  void dispose() {
    customColor.dispose();
    super.dispose();
  }

  _textColor() {
    Color res = Colors.white;
    final color = ref.read(settingsProvider).looks.color;

    final lumi = color.computeLuminance();

    if (lumi > 0.4) {
      res = Colors.black;
    } else {
      res = Colors.white;
    }

    return res;
  }

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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: appWidth,
            maxHeight: appWidth,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  color: settings.color,
                  heading: const Text('Colors'),
                  pickersEnabled: const {
                    ColorPickerType.accent: true,
                    ColorPickerType.primary: false,
                    ColorPickerType.custom: true
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

                    setState(() {
                      customColor.text = ColorExtension(col).hex;
                    });

                    AppUtils.saveAppSettings(currentSettings.copyWith(
                        looks: currentLooks.copyWith(color: col)));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hex: '),
                      ShakeX(
                        duration: 200.milliseconds,
                        curve: Curves.linear,
                        manualTrigger: true,
                        from: 5,
                        controller: (p0) => anim = p0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: settings.color,
                              borderRadius: BorderRadius.circular(
                                  settings.widgetRadius * 0.8)),
                          width: 150,
                          height: 30,
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: TextField(
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _textColor()),
                                controller: customColor,
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                onSubmitted: (val) async {
                                  if (val.isHexColor) {
                                    final currentLooks =
                                        ref.read(settingsProvider).looks;
                                    ref.read(settingsProvider.notifier).update(
                                        (state) => state = state.copyWith(
                                            looks: currentLooks.copyWith(
                                                color: HexColor.fromHex(val))));

                                    final newSettings =
                                        ref.read(settingsProvider);

                                    await AppUtils.saveAppSettings(newSettings);
                                  } else {
                                    anim.reset();
                                    anim.animateTo(1);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
