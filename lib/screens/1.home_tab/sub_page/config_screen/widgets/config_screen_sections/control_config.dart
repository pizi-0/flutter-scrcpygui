import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final theme = Theme.of(context);

    return PgSectionCard(
      label: 'Control',
      children: [
        OutlinedContainer(
          backgroundColor: theme.colorScheme.accent,
          borderRadius: theme.borderRadiusMd,
          padding: EdgeInsets.all(4),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(child: Text(' Mouse').small),
              PgSectionCard(
                children: [
                  ConfigCustom(
                    title: 'Mouse mode',
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
                    title: 'Disable mouse hover effect',
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
              Label(child: Text(' Keyboard').small),
              PgSectionCard(
                children: [
                  ConfigCustom(
                    title: 'Keyboard mode',
                    dimTitle: false,
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
                    title: 'Disable key repeat',
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
              Label(child: Text(' Gamepad').small),
              PgSectionCard(
                children: [
                  ConfigCustom(
                    title: 'Gamepad mode',
                    dimTitle: false,
                    child: Select(
                      onChanged: (value) => ref
                          .read(configScreenConfig.notifier)
                          .setControlConfig(gamepadMode: value),
                      value: GamepadMode.disabled,
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
