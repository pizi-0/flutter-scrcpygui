import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/widgets/config_dropdown.dart';

import '../../providers/settings_provider.dart';
import '../../utils/const.dart';

class DeviceConfig extends ConsumerStatefulWidget {
  const DeviceConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeviceConfigState();
}

class _DeviceConfigState extends ConsumerState<DeviceConfig> {
  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Device',
            style: Theme.of(context).textTheme.titleLarge,
          ).textColor(colorScheme.inverseSurface),
        ),
        Container(
          decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(appTheme.widgetRadius)),
          width: appWidth,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Stay awake',
                  child: Tooltip(
                    message: selectedConfig.windowOptions.noWindow
                        ? 'Hide window is active'
                        : '',
                    child: Checkbox(
                      value: selectedConfig.deviceOptions.stayAwake,
                      onChanged: selectedConfig.windowOptions.noWindow
                          ? null
                          : (value) => ref
                              .read(configScreenConfig.notifier)
                              .update((state) => state = state!.copyWith(
                                  deviceOptions: state.deviceOptions
                                      .copyWith(stayAwake: value))),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Show touches',
                  child: Tooltip(
                    message: selectedConfig.windowOptions.noWindow
                        ? 'Hide window is active'
                        : '',
                    child: Checkbox(
                      value: selectedConfig.deviceOptions.showTouches,
                      onChanged: selectedConfig.windowOptions.noWindow
                          ? null
                          : (value) => ref
                              .read(configScreenConfig.notifier)
                              .update((state) => state = state!.copyWith(
                                  deviceOptions: state.deviceOptions
                                      .copyWith(showTouches: value))),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Turn off display on start',
                  child: Tooltip(
                    message: selectedConfig.windowOptions.noWindow
                        ? 'Hide window is active'
                        : '',
                    child: Checkbox(
                      value: selectedConfig.deviceOptions.turnOffDisplay,
                      onChanged: selectedConfig.windowOptions.noWindow
                          ? null
                          : (value) => ref
                              .read(configScreenConfig.notifier)
                              .update((state) => state = state!.copyWith(
                                  deviceOptions: state.deviceOptions
                                      .copyWith(turnOffDisplay: value))),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Turn off display on exit',
                  child: Tooltip(
                    message: selectedConfig.windowOptions.noWindow
                        ? 'Hide window is active'
                        : '',
                    child: Checkbox(
                      value: selectedConfig.deviceOptions.offScreenOnClose,
                      onChanged: selectedConfig.windowOptions.noWindow
                          ? null
                          : (value) => ref
                              .read(configScreenConfig.notifier)
                              .update((state) => state = state!.copyWith(
                                  deviceOptions: state.deviceOptions
                                      .copyWith(offScreenOnClose: value))),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Disable screensaver (HOST)',
                  child: Checkbox(
                    value: selectedConfig.deviceOptions.noScreensaver,
                    onChanged: (value) => ref
                        .read(configScreenConfig.notifier)
                        .update((state) => state = state!.copyWith(
                            deviceOptions: state.deviceOptions
                                .copyWith(noScreensaver: value))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
