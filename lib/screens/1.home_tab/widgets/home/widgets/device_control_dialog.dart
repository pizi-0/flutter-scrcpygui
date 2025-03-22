import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/device_key.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
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

        await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));

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

    return AlertDialog(
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
                // Select(
                //   itemBuilder: (context, value) => Text(value),
                //   onChanged: (value) {
                //     selectedApp = value!;
                //     setState(() {});
                //   },
                //   placeholder: const Text('Select app'),
                //   value: selectedApp,
                //   popup: SelectPopup(
                //     items: SelectItemList(
                //       children: widget.device.info!.appList!
                //           .map((app) => SelectItemButton(
                //                 value: app.packageName,
                //                 child: Text(app.name),
                //               ))
                //           .toList(),
                //     ),
                //   ).call,
                // ),
                const Text('On config:'),
                // Select(
                //   itemBuilder: (context, value) => Text(value.configName),
                //   onChanged: selectedApp == null
                //       ? null
                //       : (config) {
                //           selectedConfig = config as ScrcpyConfig?;

                //           setState(() {});
                //         },
                //   placeholder: const Text('Select config to launch the app on'),
                //   value: selectedConfig,
                //   popup: SelectPopup(
                //     items: SelectItemList(
                //       children: allconfigs
                //           .where((e) => !e.windowOptions.noWindow)
                //           .map((config) => SelectItemButton(
                //                 value: config,
                //                 child: Text(config.configName),
                //               ))
                //           .toList(),
                //     ),
                //   ).call,
                // ),
              ],
            ),
        ],
      ),
      actions: [
        FButton(
          style: FButtonStyle.secondary,
          label: const Text('Close'),
          onPress: () => ScrcpyUtils.newInstance(ref,
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
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.power).paddingAll(2),
        onPress: () => widget.device.sendKeyEvent(workDir, DeviceKey.power),
      ),
      const VerticalDivider(),
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.arrow_back).paddingAll(2),
        onPress: () => widget.device.sendKeyEvent(workDir, DeviceKey.back),
      ),
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.home).paddingAll(2),
        onPress: () => widget.device.sendKeyEvent(workDir, DeviceKey.home),
      ),
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.history).paddingAll(2),
        onPress: () => widget.device.sendKeyEvent(workDir, DeviceKey.recent),
      ),
      const VerticalDivider(),
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.skip_previous).paddingAll(2),
        onPress: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaPrevious),
      ),
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.play_arrow).paddingAll(2),
        onPress: () => widget.device.sendKeyEvent(workDir, DeviceKey.playPause),
      ),
      FButton(
        style: FButtonStyle.secondary,
        label: const Icon(Icons.skip_next).paddingAll(2),
        onPress: () => widget.device.sendKeyEvent(workDir, DeviceKey.mediaNext),
      ),
    ];
  }
}
