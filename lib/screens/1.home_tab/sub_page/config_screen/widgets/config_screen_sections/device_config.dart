import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
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
        ConfigCustom(
            title: el.deviceSection.title,
            child: const Icon(FluentIcons.cell_phone)),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: el.deviceSection.stayAwake.label,
                showinfo: showInfo,
                subtitle: selectedConfig.deviceOptions.stayAwake
                    ? el.deviceSection.stayAwake.info.alt
                    : el.deviceSection.stayAwake.info.default$,
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
                title: el.deviceSection.showTouches.label,
                subtitle: selectedConfig.deviceOptions.showTouches
                    ? el.deviceSection.showTouches.info.alt
                    : el.deviceSection.showTouches.info.default$,
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
                title: el.deviceSection.offDisplayStart.label,
                subtitle: selectedConfig.deviceOptions.turnOffDisplay
                    ? el.deviceSection.offDisplayStart.info.alt
                    : el.deviceSection.offDisplayStart.info.default$,
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
                title: el.deviceSection.offDisplayExit.label,
                subtitle: selectedConfig.deviceOptions.offScreenOnClose
                    ? el.deviceSection.offDisplayExit.info.alt
                    : el.deviceSection.offDisplayExit.info.default$,
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
                title: el.deviceSection.screensaver.label,
                subtitle: selectedConfig.deviceOptions.noScreensaver
                    ? el.deviceSection.screensaver.info.alt
                    : el.deviceSection.screensaver.info.default$,
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
