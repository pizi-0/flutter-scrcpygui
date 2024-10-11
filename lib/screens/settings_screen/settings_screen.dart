// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrcpygui/providers/theme_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/body_container.dart';

import '../../utils/const.dart';
import '../../widgets/custom_slider_track_shape.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appTheme = ref.watch(appThemeProvider);

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              style: buttonStyle,
              tooltip: 'ESC',
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              'Settings',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: const Center(
            child: SizedBox(
              width: appWidth,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ThemeSection(),
                      DataSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeSection extends ConsumerStatefulWidget {
  const ThemeSection({super.key});

  @override
  ConsumerState<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends ConsumerState<ThemeSection> {
  late double radius;

  @override
  void initState() {
    radius = ref.read(appThemeProvider).widgetRadius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appTheme = ref.watch(appThemeProvider);

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
                  var theme = ref.read(appThemeProvider);
                  ref.read(appThemeProvider.notifier).setBrightness(val!);
                  AppUtils.saveAppTheme(theme.copyWith(brightness: val));
                },
              ),
              const Text('Dark'),
              const SizedBox(width: 10),
              Radio(
                activeColor: colorScheme.inversePrimary,
                value: Brightness.light,
                groupValue: appTheme.brightness,
                onChanged: (val) {
                  var theme = ref.read(appThemeProvider);
                  ref.read(appThemeProvider.notifier).setBrightness(val!);
                  AppUtils.saveAppTheme(theme.copyWith(brightness: val));
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
                  ref
                      .read(appThemeProvider.notifier)
                      .setColor(defaultTheme.color);

                  final theme = ref.read(appThemeProvider);
                  await AppUtils.saveAppTheme(theme);
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
                    ref
                        .read(appThemeProvider.notifier)
                        .setWidgetRadius(defaultTheme.widgetRadius);

                    setState(() {
                      radius = defaultTheme.widgetRadius;
                    });

                    final theme = ref.read(appThemeProvider);
                    await AppUtils.saveAppTheme(theme);
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
                      final theme = ref.read(appThemeProvider);
                      await AppUtils.saveAppTheme(theme);
                    },
                    onChanged: (v) {
                      radius = v;
                      setState(() {});
                      ref.read(appThemeProvider.notifier).setWidgetRadius(v);
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

class DataSection extends ConsumerStatefulWidget {
  const DataSection({super.key});

  @override
  ConsumerState<DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends ConsumerState<DataSection> {
  @override
  Widget build(BuildContext context) {
    final colorSheme = Theme.of(context).colorScheme;
    return BodyContainer(
      headerTitle: 'Data',
      children: [
        BodyContainerItem(
          title: 'Clear preferences',
          trailing: IconButton(
            onPressed: () async {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return const SizedBox.shrink();
                },
              );
            },
            icon: Icon(
              Icons.delete_rounded,
              color: colorSheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

class MyColorPicker extends ConsumerStatefulWidget {
  const MyColorPicker({super.key});

  @override
  ConsumerState<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends ConsumerState<MyColorPicker> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(appThemeProvider);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(settings.widgetRadius * 0.8),
          // border:
          //     Border.all(color: ref.watch(appThemeProvider).color, width: 2),
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
                  color: ref.watch(appThemeProvider).color,
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
                    var theme = ref.read(appThemeProvider);
                    ref.read(appThemeProvider.notifier).setColor(col);
                    AppUtils.saveAppTheme(theme.copyWith(color: col));
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
