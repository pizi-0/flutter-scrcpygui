// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/disconnect_dialog.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_running_instance.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/scrcpy_provider.dart';
import '../../../../../providers/version_provider.dart';
import '../../../../../utils/adb_utils.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_list_tile.dart';

class DeviceTile extends ConsumerStatefulWidget {
  const DeviceTile({
    super.key,
    required this.device,
  });

  final AdbDevices device;

  @override
  ConsumerState<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends ConsumerState<DeviceTile>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  late FPopoverController popoverController;

  @override
  void initState() {
    popoverController = FPopoverController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final runningInstances = ref.watch(scrcpyInstanceProvider);
    final deviceInstance =
        runningInstances.where((i) => i.device.id == widget.device.id).toList();

    final isSelected = selectedDevice == widget.device;
    final hasRunningInstance = deviceInstance.isNotEmpty;
    final isWireless = widget.device.id.isIpv4 ||
        widget.device.id.isIpv6 ||
        widget.device.id.contains(adbMdns);

    // final contextMenu = [
    //   MenuLabel(
    //     child: Text(el.deviceTileLoc
    //             .runningInstances(count: '${deviceInstance.length}'))
    //         .xSmall()
    //         .muted(),
    //   ),
    //   MenuButton(
    //     enabled: hasRunningInstance,
    //     leading: const Icon(Icons.close_rounded),
    //     subMenu: [
    //       MenuLabel(
    //           child: Text(el.deviceTileLoc.context.instances).xSmall().muted()),
    //       ...deviceInstance.map(
    //         (inst) => MenuButton(
    //           child: Text(inst.instanceName),
    //           onPressed: (context) => _killRunning([inst]),
    //         ),
    //       ),
    //       const MenuDivider(),
    //       MenuLabel(child: Text(el.deviceTileLoc.context.all).xSmall().muted()),
    //       MenuButton(
    //         onPressed: (context) => _killRunning(deviceInstance),
    //         child: Text(el.deviceTileLoc.context.allInstances),
    //       )
    //     ],
    //     child: Text(el.deviceTileLoc.context.killRunning),
    //   ),
    //   const MenuDivider(),
    //   MenuLabel(child: Text(el.deviceTileLoc.context.manage).xSmall().muted()),
    //   if (isWireless)
    //     MenuButton(
    //       leading: const Icon(Icons.link_off_rounded),
    //       onPressed: (context) => _disconnectWireless(),
    //       child: Text(el.deviceTileLoc.context.disconnect),
    //     ),
    //   if (!isWireless)
    //     MenuButton(
    //       leading: const Icon(Icons.wifi_rounded),
    //       onPressed: (context) => _toWireless(),
    //       child: Text(el.deviceTileLoc.context.toWireless),
    //     ),
    // ];

    return ClipRRect(
      borderRadius: theme.style.borderRadius,
      child: Stack(
        children: [
          PgListTile(
            onPress: () =>
                ref.read(selectedDeviceProvider.notifier).state = widget.device,
            title: widget.device.name ?? widget.device.modelName,
            leading: isWireless
                ? FIcon(FAssets.icons.wifi)
                : FIcon(FAssets.icons.usb),
            trailing: Row(
              children: [
                if (hasRunningInstance)
                  FTooltip(
                    tipBuilder: (context, value, child) => Text(
                      el.deviceTileLoc.runningInstances(
                          count: deviceInstance.length.toString()),
                    ),
                    child: FButton.icon(
                      style: FButtonStyle.ghost,
                      onPress: () {},
                      child: FIcon(FAssets.icons.play, color: Colors.green),
                    ),
                  ),
                FButton.icon(
                  style: FButtonStyle.ghost,
                  child: FIcon(FAssets.icons.settings),
                  onPress: () =>
                      context.push('/home/device-settings/${widget.device.id}'),
                ),
              ],
            ),
            subtitle: widget.device.id,
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 0,
            bottom: 0,
            child: SlideInLeft(
              duration: 150.milliseconds,
              from: 20,
              animate: isSelected,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2),
                child: Container(
                  height: 20,
                  width: 5,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          if (loading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: theme.style.borderRadius,
                ),
                child: SizedBox.expand(),
              ),
            )
        ],
      ),
    );
  }

  _toWireless() async {
    loading = true;
    setState(() {});

    final workDir = ref.read(execDirProvider);

    try {
      final ip = await AdbUtils.getIpForUSB(workDir, widget.device);

      await AdbUtils.tcpip5555(workDir, widget.device.id);

      await AdbUtils.connectWithIp(ref, ipport: '$ip:5555');
    } on Exception catch (e) {
      debugPrint(e.toString());
      // showToast(
      //     showDuration: 1.5.seconds,
      //     context: context,
      //     builder: (context, overlay) => Text(el.statusLoc.failed));
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }

  _disconnectWireless() async {
    loading = true;
    setState(() {});

    try {
      final res = await showDialog(
        context: context,
        builder: (context) => DisconnectDialog(device: widget.device),
      );

      if (res ?? false) {
        final workDir = ref.read(execDirProvider);
        await AdbUtils.disconnectWirelessDevice(workDir, widget.device);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      // showToast(
      //     showDuration: 1.5.seconds,
      //     context: context,
      //     builder: (context, overlay) => Text(el.statusLoc.failed));
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }

  _killRunning(List<ScrcpyRunningInstance> instances) async {
    try {
      for (final instance in instances) {
        await ScrcpyUtils.killServer(instance);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
