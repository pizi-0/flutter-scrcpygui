import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/device_key.dart';
import '../../../../../providers/version_provider.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';

class ControlButtons extends ConsumerStatefulWidget {
  final AdbDevices device;
  const ControlButtons({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends ConsumerState<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    return PgSectionCardNoScroll(
      cardPadding: EdgeInsets.all(15),
      label: el.loungeLoc.controls.label,
      content: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          spacing: 8,
          children: _buttonList(),
        ),
      ),
    );
  }

  List<Widget> _buttonList() {
    final workDir = ref.read(execDirProvider);
    return [
      DestructiveButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.power_settings_new_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.power),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.back),
        child: const Icon(Icons.arrow_back_rounded),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.home_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.home),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.history_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.recent),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.skip_previous_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaPrevious),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.play_arrow_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.playPause),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.skip_next_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaNext),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.volume_down_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.volumeDown),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.volume_up_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.volumeUp),
      ),
    ];
  }
}
