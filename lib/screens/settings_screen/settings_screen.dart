// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pg_scrcpy/providers/theme_provider.dart';
import 'package:pg_scrcpy/utils/app_utils.dart';
import 'package:pg_scrcpy/widgets/body_container.dart';

import '../../utils/const.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
    );
  }
}

class ThemeSection extends ConsumerStatefulWidget {
  const ThemeSection({super.key});

  @override
  ConsumerState<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends ConsumerState<ThemeSection> {
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
          trailing: InkWell(
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
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black),
                color: appTheme.color,
              ),
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
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
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
