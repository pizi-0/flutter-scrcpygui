// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_running_instance.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/scrcpy_provider.dart';
import '../../../../../providers/version_provider.dart';
import '../../../../../utils/adb_utils.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/scrcpy_utils.dart';
import 'device_control_dialog.dart';

class DeviceTile extends ConsumerStatefulWidget {
  const DeviceTile({
    super.key,
    required this.device,
  });

  final AdbDevices device;

  @override
  ConsumerState<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends ConsumerState<DeviceTile> {
  final contextMenuController = FlyoutController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    final selectedDevice = ref.watch(selectedDeviceProvider);
    final runningInstances = ref.watch(scrcpyInstanceProvider);
    final deviceInstance =
        runningInstances.where((i) => i.device.id == widget.device.id).toList();

    final isSelected = selectedDevice == widget.device;
    final hasRunningInstance = deviceInstance.isNotEmpty;
    final isWireless = widget.device.id.isIpv4 ||
        widget.device.id.isIpv6 ||
        widget.device.id.contains(adbMdns);

    return FlyoutTarget(
      controller: contextMenuController,
      child: Card(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.only(bottom: 4),
        child: SizedBox(
          height: 60,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onSecondaryTapUp: (details) => _showContextMenu(
                    details, hasRunningInstance, deviceInstance, isWireless),
                child: ListTile.selectable(
                  onPressed: () {
                    ref.read(selectedDeviceProvider.notifier).state =
                        widget.device;
                  },
                  tileColor: const WidgetStatePropertyAll(Colors.transparent),
                  leading: Icon(
                    widget.device.id.isIpv4 ||
                            widget.device.id.contains(adbMdns)
                        ? FluentIcons.wifi
                        : FluentIcons.usb,
                  ),
                  selected: isSelected,
                  title: Row(
                    spacing: 10,
                    children: [
                      Text(widget.device.name!),
                      if (hasRunningInstance)
                        Card(
                          backgroundColor: theme.selectionColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text('Running: ${deviceInstance.length}')
                              .fontSize(10)
                              .textColor(Colors.white),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    widget.device.id,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    children: [
                      IconButton(
                        icon: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(FluentIcons.app_icon_default),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) =>
                                  ControlDialog(widget.device));
                        },
                      ),
                      IconButton(
                        icon: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(FluentIcons.settings),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/dev_settings',
                            arguments: widget.device,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (loading)
                Card(
                  backgroundColor: Colors.black.withAlpha(100),
                  child: const SizedBox(),
                )
            ],
          ),
        ),
      ),
    );
  }

  _showContextMenu(TapUpDetails details, bool hasRunningInstance,
      List<ScrcpyRunningInstance> deviceInstance, bool isWireless) {
    contextMenuController.showFlyout(
      position: Offset(details.globalPosition.dx - kCompactNavigationPaneWidth,
          details.globalPosition.dy - kCompactNavigationPaneWidth),
      builder: (context) {
        return MenuFlyout(
          items: [
            if (hasRunningInstance)
              MenuFlyoutSubItem(
                leading: const Icon(FluentIcons.cancel),
                text: const Text('Kill running'),
                items: (context) => deviceInstance
                    .map(
                      (i) => MenuFlyoutItem(
                          text: Text('${i.instanceName}/${i.scrcpyPID}'),
                          onPressed: () {
                            try {
                              ScrcpyUtils.killServer(i);
                            } on Exception catch (e) {
                              debugPrint(e.toString());
                            }
                          }),
                    )
                    .toList(),
              ),
            if (isWireless)
              MenuFlyoutItem(
                  leading: const Icon(FluentIcons.remove_link),
                  text: const Text('Disconnect'),
                  onPressed: () async {
                    loading = true;
                    setState(() {});

                    try {
                      final workDir = ref.read(execDirProvider);

                      await AdbUtils.disconnectWirelessDevice(
                          workDir, widget.device);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                      displayInfoBar(context,
                          builder: (context, close) =>
                              Card(child: InfoLabel(label: 'Failed')));
                    }

                    if (mounted) {
                      loading = false;
                      setState(() {});
                    }
                  }),
            if (!isWireless)
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.wifi),
                text: const Text('To wireless'),
                onPressed: () async {
                  loading = true;
                  setState(() {});

                  final workDir = ref.read(execDirProvider);

                  try {
                    final ip =
                        await AdbUtils.getIpForUSB(workDir, widget.device);

                    await AdbUtils.tcpip5555(workDir, widget.device.id);

                    await AdbUtils.connectWithIp(ref, ipport: '$ip:5555');
                  } on Exception catch (e) {
                    debugPrint(e.toString());
                    displayInfoBar(context,
                        builder: (context, close) =>
                            Card(child: InfoLabel(label: 'Failed')));
                  }

                  if (mounted) {
                    loading = false;
                    setState(() {});
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
