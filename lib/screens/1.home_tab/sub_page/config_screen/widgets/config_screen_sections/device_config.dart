import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

import '../../../../../../providers/config_provider.dart';

class DeviceConfig extends ConsumerStatefulWidget {
  const DeviceConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeviceConfigState();
}

class _DeviceConfigState extends ConsumerState<DeviceConfig> {
  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final showInfo = ref.watch(configScreenShowInfo);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ConfigCustom(
            title: 'Device', child: Icon(FluentIcons.cell_phone)),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Stay awake',
                showinfo: showInfo,
                subtitle: selectedConfig.deviceOptions.stayAwake
                    ? "uses '--stay-awake' flag"
                    : "prevent the device from sleeping, only works with usb connection",
                child: Tooltip(
                  message: selectedConfig.windowOptions.noWindow
                      ? 'Hide window is active'
                      : '',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Checkbox(
                      checked: selectedConfig.deviceOptions.stayAwake,
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
              ),
              const Divider(),
              ConfigCustom(
                showinfo: showInfo,
                childBackgroundColor: Colors.transparent,
                title: 'Show touches',
                subtitle: selectedConfig.deviceOptions.showTouches
                    ? "uses '--show-touches' flag"
                    : 'show finger touches, only works with physical touches on the device',
                child: Tooltip(
                  message: selectedConfig.windowOptions.noWindow
                      ? 'Hide window is active'
                      : '',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Checkbox(
                      checked: selectedConfig.deviceOptions.showTouches,
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
              ),
              const Divider(),
              ConfigCustom(
                showinfo: showInfo,
                childBackgroundColor: Colors.transparent,
                title: 'Turn off display on start',
                subtitle: selectedConfig.deviceOptions.turnOffDisplay
                    ? "uses '--turn-screen-off' flag"
                    : 'turn device display off, on scrcpy start',
                child: Tooltip(
                  message: selectedConfig.windowOptions.noWindow
                      ? 'Hide window is active'
                      : '',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Checkbox(
                      checked: selectedConfig.deviceOptions.turnOffDisplay,
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
              ),
              const Divider(),
              ConfigCustom(
                showinfo: showInfo,
                childBackgroundColor: Colors.transparent,
                title: 'Turn off display on exit',
                subtitle: selectedConfig.deviceOptions.offScreenOnClose
                    ? "uses '--power-off-on-close' flag"
                    : 'turn device display off, on scrcpy end',
                child: Tooltip(
                  message: selectedConfig.windowOptions.noWindow
                      ? 'Hide window is active'
                      : '',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Checkbox(
                      checked: selectedConfig.deviceOptions.offScreenOnClose,
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
              ),
              const Divider(),
              ConfigCustom(
                showinfo: showInfo,
                childBackgroundColor: Colors.transparent,
                title: 'Disable screensaver (HOST)',
                subtitle: selectedConfig.deviceOptions.noScreensaver
                    ? "uses '--disable-screensaver' flag"
                    : 'disable screensaver',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Checkbox(
                    checked: selectedConfig.deviceOptions.noScreensaver,
                    onChanged: (value) => ref
                        .read(configScreenConfig.notifier)
                        .update((state) => state = state!.copyWith(
                            deviceOptions: state.deviceOptions
                                .copyWith(noScreensaver: value))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
