import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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

    return PgSectionCard(
      label: el.deviceSection.title,
      children: [
        ConfigCustom(
          onPressed:
              selectedConfig.windowOptions.noWindow ? null : _toggleStayAwake,
          childBackgroundColor: Colors.transparent,
          title: el.deviceSection.stayAwake.label,
          showinfo: showInfo,
          subtitle: selectedConfig.deviceOptions.stayAwake
              ? el.deviceSection.stayAwake.info.alt
              : el.deviceSection.stayAwake.info.default$,
          childExpand: false,
          child: Checkbox(
            state: selectedConfig.deviceOptions.stayAwake
                ? CheckboxState.checked
                : CheckboxState.unchecked,
            onChanged: selectedConfig.windowOptions.noWindow
                ? null
                : (value) => _toggleStayAwake(),
          ),
        ),
        const Divider(),
        ConfigCustom(
          onPressed:
              selectedConfig.windowOptions.noWindow ? null : _toggleShowTouches,
          childExpand: false,
          showinfo: showInfo,
          childBackgroundColor: Colors.transparent,
          title: el.deviceSection.showTouches.label,
          subtitle: selectedConfig.deviceOptions.showTouches
              ? el.deviceSection.showTouches.info.alt
              : el.deviceSection.showTouches.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
              state: selectedConfig.deviceOptions.showTouches
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
              onChanged: selectedConfig.windowOptions.noWindow
                  ? null
                  : (value) => _toggleShowTouches(),
            ),
          ),
        ),
        const Divider(),
        ConfigCustom(
          onPressed: selectedConfig.windowOptions.noWindow
              ? null
              : _toggleTurnOffDisplay,
          childExpand: false,
          showinfo: showInfo,
          childBackgroundColor: Colors.transparent,
          title: el.deviceSection.offDisplayStart.label,
          subtitle: selectedConfig.deviceOptions.turnOffDisplay
              ? el.deviceSection.offDisplayStart.info.alt
              : el.deviceSection.offDisplayStart.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
              state: selectedConfig.deviceOptions.turnOffDisplay
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
              onChanged: selectedConfig.windowOptions.noWindow
                  ? null
                  : (value) => _toggleTurnOffDisplay(),
            ),
          ),
        ),
        const Divider(),
        ConfigCustom(
          onPressed: selectedConfig.windowOptions.noWindow
              ? null
              : _toggleOffScreenOnClose,
          childExpand: false,
          showinfo: showInfo,
          childBackgroundColor: Colors.transparent,
          title: el.deviceSection.offDisplayExit.label,
          subtitle: selectedConfig.deviceOptions.offScreenOnClose
              ? el.deviceSection.offDisplayExit.info.alt
              : el.deviceSection.offDisplayExit.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
              state: selectedConfig.deviceOptions.offScreenOnClose
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
              onChanged: selectedConfig.windowOptions.noWindow
                  ? null
                  : (value) => _toggleOffScreenOnClose(),
            ),
          ),
        ),
        const Divider(),
        ConfigCustom(
          onPressed: _toggleScreenSaver,
          childExpand: false,
          showinfo: showInfo,
          childBackgroundColor: Colors.transparent,
          title: el.deviceSection.screensaver.label,
          subtitle: selectedConfig.deviceOptions.noScreensaver
              ? el.deviceSection.screensaver.info.alt
              : el.deviceSection.screensaver.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
              state: selectedConfig.deviceOptions.noScreensaver
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
              onChanged: (value) => _toggleScreenSaver(),
            ),
          ),
        ),
      ],
    );
  }

  _toggleStayAwake() {
    final config = ref.read(configScreenConfig)!;
    final stayAwake = config.deviceOptions.stayAwake;
    ref
        .read(configScreenConfig.notifier)
        .setDeviceConfig(stayAwake: !stayAwake);
  }

  _toggleShowTouches() {
    final config = ref.read(configScreenConfig)!;
    final showTouches = config.deviceOptions.showTouches;
    ref
        .read(configScreenConfig.notifier)
        .setDeviceConfig(showTouches: !showTouches);
  }

  _toggleTurnOffDisplay() {
    final config = ref.read(configScreenConfig)!;
    final turnOffDisplay = config.deviceOptions.turnOffDisplay;

    ref
        .read(configScreenConfig.notifier)
        .setDeviceConfig(turnOffDisplay: !turnOffDisplay);
  }

  _toggleOffScreenOnClose() {
    final config = ref.read(configScreenConfig)!;
    final offScreenOnClose = config.deviceOptions.offScreenOnClose;

    ref.read(configScreenConfig.notifier).setDeviceConfig(
          offScreenOnClose: !offScreenOnClose,
        );
  }

  _toggleScreenSaver() {
    final config = ref.read(configScreenConfig)!;
    final noScreensaver = config.deviceOptions.noScreensaver;

    ref.read(configScreenConfig.notifier).setDeviceConfig(
          noScreensaver: !noScreensaver,
        );
  }
}
