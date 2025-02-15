import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/device_key.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

class ControlDialog extends ConsumerStatefulWidget {
  final AdbDevices device;
  const ControlDialog(this.device, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ControlDialogState();
}

class _ControlDialogState extends ConsumerState<ControlDialog> {
  bool loading = false;
  String? selectedApp;
  ScrcpyConfig? selectedConfig;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      final workDir = ref.read(execDirProvider);
      if (widget.device.info == null) {
        loading = true;
        setState(() {});
        final info = await AdbUtils.getScrcpyDetailsFor(workDir, widget.device);
        ref
            .read(savedAdbDevicesProvider.notifier)
            .addEditDevices(widget.device.copyWith(info: info));

        await AdbUtils.saveAdbDevice(ref.read(savedAdbDevicesProvider));

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allconfigs = ref.read(configsProvider);

    return ContentDialog(
      title: Text(widget.device.name ?? widget.device.modelName),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: _buttonList(),
          ),
          if (widget.device.info != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text('Launch:'),
                ComboBox(
                  onChanged: (value) {
                    selectedApp = value!;
                    setState(() {});
                  },
                  placeholder: const Text('Select app'),
                  value: selectedApp,
                  items: widget.device.info!.appList!
                      .map((app) => ComboBoxItem(
                            value: app.packageName,
                            child: Text(app.name),
                          ))
                      .toList(),
                ),
                const Text('On config:'),
                ComboBox(
                  onChanged: selectedApp == null
                      ? null
                      : (config) {
                          selectedConfig = config as ScrcpyConfig?;

                          setState(() {});
                        },
                  placeholder: const Text('Select config to launch the app on'),
                  value: selectedConfig,
                  items: allconfigs
                      .where((e) => !e.windowOptions.noWindow)
                      .map((config) => ComboBoxItem(
                            value: config,
                            child: Text(config.configName),
                          ))
                      .toList(),
                ),
              ],
            ),
        ],
      ),
      actions: [
        Button(
          child: const Text('Close'),
          onPressed: () => ScrcpyUtils.newInstance(ref,
              selectedDevice: widget.device,
              selectedConfig: selectedConfig!.copyWith(
                  additionalFlags: '--new-display --start-app=$selectedApp')),
        )
      ],
    );
  }

  _buttonList() {
    final workDir = ref.read(execDirProvider);
    return [
      Button(
        child: const Icon(FluentIcons.power_button).paddingAll(2),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.power),
      ),
      const Divider(
        direction: Axis.vertical,
        size: 10,
      ),
      Button(
        child: const Icon(FluentIcons.back).paddingAll(2),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.back),
      ),
      Button(
        child: const Icon(FluentIcons.home).paddingAll(2),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.home),
      ),
      Button(
        child: const Icon(FluentIcons.recent).paddingAll(2),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.recent),
      ),
      const Divider(
        direction: Axis.vertical,
        size: 10,
      ),
      Button(
        child: const Icon(FluentIcons.previous).paddingAll(2),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaPrevious),
      ),
      Button(
        child: const Icon(FluentIcons.play).paddingAll(2),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.playPause),
      ),
      Button(
        child: const Icon(FluentIcons.next).paddingAll(2),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaNext),
      ),
    ];
  }
}
