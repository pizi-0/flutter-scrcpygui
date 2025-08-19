import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../utils/themes.dart';

class ThemeSection extends ConsumerStatefulWidget {
  const ThemeSection({super.key});

  @override
  ConsumerState<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends ConsumerState<ThemeSection> {
  @override
  Widget build(BuildContext context) {
    final looks = ref.watch(settingsProvider.select((sett) => sett.looks));
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgSectionCard(
      label: el.settingsLoc.looks.label,
      children: [
        PgListTile(
          title: el.settingsLoc.looks.mode.label,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Select(
              placeholder: const Text('Theme mode'),
              canUnselect: false,
              filled: true,
              autoClosePopover: true,
              itemBuilder: (context, value) => Text(value.$2.capitalize),
              value: themeModeDD(context)
                  .firstWhere((mode) => mode.$1 == looks.themeMode),
              onChanged: (mode) async {
                ref.read(settingsProvider.notifier).changeThememode(mode!.$1);
                await Db.saveAppSettings(ref.read(settingsProvider));
              },
              popup: SelectPopup(
                autoClose: true,
                canUnselect: false,
                items: SelectItemList(
                  children: themeModeDD(context)
                      .map((mode) =>
                          SelectItemButton(value: mode, child: Text(mode.$2)))
                      .toList(),
                ),
              ).call,
            ),
          ),
        ),
        const Divider(),
        PgListTile(
          title: el.settingsLoc.looks.accentColor.label,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Select(
              filled: true,
              itemBuilder: (context, value) => Text(mySchemes()
                  .firstWhere(
                    (scheme) => scheme == value,
                    orElse: () => mySchemes().first,
                  )
                  .name),
              value: looks.scheme,
              onChanged: (scheme) async {
                ref.read(settingsProvider.notifier).changeColorScheme(scheme!);
                await Db.saveAppSettings(ref.read(settingsProvider));
              },
              popup: SelectPopup(
                items: SelectItemList(
                    children: mySchemes()
                        .map(
                          (scheme) => SelectItemButton(
                            value: scheme,
                            child: Text(scheme.name),
                          ),
                        )
                        .toList()),
              ).call,
            ),
          ),
        ),
        const Divider(),
        Column(
          children: [
            InkWell(
              onTap: _toggleOldScheme,
              child: PgListTile(
                title: el.settingsLoc.looks.oldScheme.label,
                trailing: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 180, maxWidth: 180, minHeight: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Checkbox(
                      state: looks.useOldScheme
                          ? CheckboxState.checked
                          : CheckboxState.unchecked,
                      onChanged: (b) => _toggleOldScheme(),
                    ),
                  ),
                ),
              ),
            ),
            PgExpandable(
              expand: !looks.useOldScheme,
              child: Column(
                spacing: 8,
                children: [
                  SizedBox(),
                  const Divider(),
                  PgListTile(
                    title: looks.themeMode == ThemeMode.dark
                        ? 'Dimness'
                        : 'Brightness',
                    trailing: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: 180, maxWidth: 180, minHeight: 30),
                      child: Row(
                        spacing: 8,
                        children: [
                          Text(looks.accentTintLevel.toStringAsFixed(0))
                              .small()
                              .medium(),
                          Expanded(
                            child: Slider(
                              min: 90,
                              max: 100,
                              hintValue:
                                  SliderValue.single(looks.accentTintLevel),
                              value: SliderValue.single(looks.accentTintLevel),
                              onChanged: (value) =>
                                  _onTintLevelChange(value.value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        PgListTile(
          title: el.settingsLoc.looks.cornerRadius.label,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Row(
              spacing: 8,
              children: [
                Text(looks.widgetRadius.toStringAsFixed(1)).small().medium(),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 3,
                    hintValue: SliderValue.single(looks.widgetRadius),
                    value: SliderValue.single(looks.widgetRadius),
                    onChanged: (value) => _onRadiusChange(value.value),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        PgListTile(
          title: 'Surface opacity',
          subtitle: 'Known to cause flickering in Linux',
          showSubtitle: Platform.isLinux,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Row(
              spacing: 8,
              children: [
                Text(looks.surfaceOpacity.toStringAsFixed(1)).small().medium(),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 1,
                    hintValue: SliderValue.single(looks.surfaceOpacity),
                    value: SliderValue.single(looks.surfaceOpacity),
                    onChanged: (value) => _onOpacityChange(value.value),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        PgListTile(
          title: 'Surface blur',
          subtitle: 'Known to cause flickering in Linux',
          showSubtitle: Platform.isLinux,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Row(
              spacing: 8,
              children: [
                Text(looks.surfaceBlur.toStringAsFixed(1)).small().medium(),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 20,
                    hintValue: SliderValue.single(looks.surfaceBlur),
                    value: SliderValue.single(looks.surfaceBlur),
                    onChanged: (value) => _onBlurChange(value.value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleOldScheme() async {
    ref.read(settingsProvider.notifier).toggleOldScheme();
    await Db.saveAppSettings(ref.read(settingsProvider));
  }

  Future<void> _onRadiusChange(double value) async {
    ref.read(settingsProvider.notifier).changeCornerRadius(value);
    await Db.saveAppSettings(ref.read(settingsProvider));
  }

  Future<void> _onOpacityChange(double value) async {
    ref.read(settingsProvider.notifier).changeOpacity(value);
    await Db.saveAppSettings(ref.read(settingsProvider));
  }

  Future<void> _onBlurChange(double value) async {
    ref.read(settingsProvider.notifier).changeBlur(value);
    await Db.saveAppSettings(ref.read(settingsProvider));
  }

  Future<void> _onTintLevelChange(double value) async {
    ref.read(settingsProvider.notifier).changeTintLevel(value);
    await Db.saveAppSettings(ref.read(settingsProvider));
  }
}

// ddvalue

List<(ThemeMode, String)> themeModeDD(BuildContext context) {
  return [
    (ThemeMode.system, el.settingsLoc.looks.mode.value.system),
    (ThemeMode.light, el.settingsLoc.looks.mode.value.light),
    (ThemeMode.dark, el.settingsLoc.looks.mode.value.dark),
  ];
}
