import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ControlConfig extends ConsumerStatefulWidget {
  const ControlConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ControlConfigState();
}

class _ControlConfigState extends ConsumerState<ControlConfig> {
  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final showInfo = ref.watch(configScreenShowInfo);

    final theme = Theme.of(context);

    return PgSectionCard(
      label: el.controlSection.title,
      children: [
        OutlinedContainer(
          backgroundColor: theme.colorScheme.accent,
          borderRadius: theme.borderRadiusMd,
          padding: EdgeInsets.all(4),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(child: Text(' ${el.controlSection.mouse.title}').small),
              PgSectionCard(
                children: [
                  ConfigCustom(
                    title: el.controlSection.mouse.mode.label,
                    subtitle: selectedConfig.controlOptions.mouseMode ==
                            MouseMode.sdk
                        ? el.controlSection.mouse.mode.info.default$
                        : "${el.controlSection.mouse.mode.info.alt(command: selectedConfig.controlOptions.mouseMode.command)} ${selectedConfig.controlOptions.mouseMode == MouseMode.aoa ? el.controlSection.info.ifAoa : ''}",
                    showinfo: showInfo,
                    dimTitle: false,
                    child: Select(
                      onChanged: (value) {
                        ref
                            .read(configScreenConfig.notifier)
                            .setControlConfig(mouseMode: value);
                      },
                      value: selectedConfig.controlOptions.mouseMode,
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: MouseMode.values
                              .map((m) => SelectItemButton(
                                  value: m, child: Text(m.name)))
                              .toList(),
                        ),
                      ).call,
                      itemBuilder: (context, mode) => Text(mode.name),
                    ),
                  ),
                  Divider(),
                  ConfigCustom(
                    title: el.controlSection.mouse.mouseHover.label,
                    subtitle: selectedConfig.controlOptions.mouseMode !=
                            MouseMode.sdk
                        ? el.controlSection.mouse.mouseHover.info.blocked
                        : selectedConfig.controlOptions.mouseNoHover
                            ? el.controlSection.mouse.mouseHover.info.alt
                            : el.controlSection.mouse.mouseHover.info.default$,
                    showinfo: showInfo ||
                        selectedConfig.controlOptions.mouseMode !=
                            MouseMode.sdk,
                    childExpand: false,
                    dimTitle: selectedConfig.controlOptions.mouseMode !=
                        MouseMode.sdk,
                    onPressed:
                        selectedConfig.controlOptions.mouseMode != MouseMode.sdk
                            ? null
                            : () => toggleMouseNoHover(),
                    child: Checkbox(
                      state: selectedConfig.controlOptions.mouseNoHover
                          ? CheckboxState.checked
                          : CheckboxState.unchecked,
                      onChanged: selectedConfig.controlOptions.mouseMode !=
                              MouseMode.sdk
                          ? null
                          : (value) => toggleMouseNoHover(),
                    ),
                  ),
                ],
              ),
              Label(child: Text(' ${el.controlSection.keyboard.title}}').small),
              PgSectionCard(
                children: [
                  ConfigCustom(
                    title: el.controlSection.keyboard.mode.label,
                    dimTitle: false,
                    subtitle: selectedConfig.controlOptions.keyboardMode ==
                            KeyboardMode.sdk
                        ? el.controlSection.keyboard.mode.info.default$
                        : "${el.controlSection.keyboard.mode.info.alt(command: selectedConfig.controlOptions.keyboardMode.command)} ${selectedConfig.controlOptions.keyboardMode == KeyboardMode.aoa ? el.controlSection.info.ifAoa : ''}",
                    showinfo: showInfo,
                    child: Select(
                      value: selectedConfig.controlOptions.keyboardMode,
                      onChanged: (value) => ref
                          .read(configScreenConfig.notifier)
                          .setControlConfig(keyboardMode: value),
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: KeyboardMode.values
                              .map((m) => SelectItemButton(
                                  value: m, child: Text(m.name)))
                              .toList(),
                        ),
                      ).call,
                      itemBuilder: (context, mode) => Text(mode.name),
                    ),
                  ),
                  Divider(),
                  ConfigCustom(
                    title: el.controlSection.keyboard.keyRepeat.label,
                    subtitle: selectedConfig.controlOptions.keyboardMode !=
                            KeyboardMode.sdk
                        ? el.controlSection.keyboard.keyRepeat.info.blocked
                        : selectedConfig.controlOptions.keyboardDisableRepeat
                            ? el.controlSection.keyboard.keyRepeat.info.alt
                            : el.controlSection.keyboard.keyRepeat.info
                                .default$,
                    showinfo: showInfo ||
                        selectedConfig.controlOptions.keyboardMode !=
                            KeyboardMode.sdk,
                    childExpand: false,
                    dimTitle: selectedConfig.controlOptions.keyboardMode !=
                        KeyboardMode.sdk,
                    onPressed: selectedConfig.controlOptions.keyboardMode !=
                            KeyboardMode.sdk
                        ? null
                        : () => toggleKeyboardDisableRepeat(),
                    child: Checkbox(
                      enabled: selectedConfig.controlOptions.keyboardMode ==
                          KeyboardMode.sdk,
                      state: selectedConfig.controlOptions.keyboardDisableRepeat
                          ? CheckboxState.checked
                          : CheckboxState.unchecked,
                      onChanged: (value) => toggleKeyboardDisableRepeat(),
                    ),
                  ),
                ],
              ),
              Label(child: Text(' ${el.controlSection.gamepad.title}').small),
              PgSectionCard(
                children: [
                  ConfigCustom(
                    title: el.controlSection.gamepad.mode.label,
                    dimTitle: false,
                    subtitle: selectedConfig.controlOptions.gamepadMode ==
                            GamepadMode.disabled
                        ? el.controlSection.gamepad.mode.info.default$
                        : "${el.controlSection.gamepad.mode.info.alt(command: selectedConfig.controlOptions.gamepadMode.command)} ${selectedConfig.controlOptions.gamepadMode == GamepadMode.aoa ? el.controlSection.info.ifAoa : ''}",
                    showinfo: showInfo,
                    child: Select(
                      onChanged: (value) => ref
                          .read(configScreenConfig.notifier)
                          .setControlConfig(gamepadMode: value),
                      value: selectedConfig.controlOptions.gamepadMode,
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: GamepadMode.values
                              .map((m) => SelectItemButton(
                                  value: m, child: Text(m.name)))
                              .toList(),
                        ),
                      ).call,
                      itemBuilder: (context, mode) => Text(mode.name),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void toggleMouseNoHover({bool? value}) {
    final current = ref.read(configScreenConfig)!.controlOptions.mouseNoHover;
    ref
        .read(configScreenConfig.notifier)
        .setControlConfig(mouseNoHover: !current);
  }

  void toggleKeyboardDisableRepeat({bool? value}) {
    final current =
        ref.read(configScreenConfig)!.controlOptions.keyboardDisableRepeat;
    ref
        .read(configScreenConfig.notifier)
        .setControlConfig(keyboardDisableRepeat: !current);
  }
}
