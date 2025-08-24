// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/connection_error_dialog.dart';
import 'package:scrcpygui/widgets/disconnect_dialog.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
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

class _DeviceTileState extends ConsumerState<DeviceTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final runningInstances = ref.watch(scrcpyInstanceProvider);
    final deviceInstance =
        runningInstances.where((i) => i.device.id == widget.device.id).toList();

    final isSelected = selectedDevice == widget.device;
    final hasRunningInstance = deviceInstance.isNotEmpty;
    final isWireless = widget.device.id.isIpv4 ||
        widget.device.id.isIpv6 ||
        widget.device.id.contains(adbMdns);

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == widget.device.serialNo);

    final contextMenu = [
      MenuLabel(
        child: Text(el.deviceTileLoc
                .runningInstances(count: '${deviceInstance.length}'))
            .xSmall()
            .muted(),
      ),
      MenuButton(
        enabled: hasRunningInstance,
        leading: const Icon(Icons.close_rounded),
        subMenu: [
          MenuLabel(
              child: Text(el.deviceTileLoc.context.scrcpy).xSmall().muted()),
          ...deviceInstance.map(
            (inst) => MenuButton(
              child: Text(inst.instanceName),
              onPressed: (context) => _killRunning([inst]),
            ),
          ),
          const MenuDivider(),
          MenuLabel(child: Text(el.deviceTileLoc.context.all).xSmall().muted()),
          MenuButton(
            onPressed: (context) => _killRunning(deviceInstance),
            child: Text(el.deviceTileLoc.context.allScrcpy),
          )
        ],
        child: Text(el.deviceTileLoc.context.stopRunning),
      ),
      const MenuDivider(),
      MenuLabel(child: Text(el.deviceTileLoc.context.manage).xSmall().muted()),
      if (isWireless)
        MenuButton(
          leading: const Icon(Icons.link_off_rounded),
          onPressed: (context) => _disconnectWireless(),
          child: Text(el.deviceTileLoc.context.disconnect),
        ),
      if (!isWireless)
        MenuButton(
          leading: const Icon(Icons.wifi_rounded),
          onPressed: (context) => _toWireless(),
          child: Text(el.deviceTileLoc.context.toWireless),
        ),
    ];

    return IntrinsicHeight(
      child: Stack(
        children: [
          ContextMenu(
            items: contextMenu,
            child: GhostButton(
              density: ButtonDensity.dense,
              onPressed: () => ref.read(selectedDeviceProvider.notifier).state =
                  widget.device,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: PgListTile(
                  key: ValueKey(widget.device.id),
                  leading: isWireless
                      ? const Icon(Icons.wifi)
                      : const Icon(Icons.usb),
                  title: deviceInfo?.deviceName ?? widget.device.modelName,
                  subtitle: widget.device.id,
                  showSubtitle: true,
                  showSubtitleLeading: false,
                  titleOverflow: true,
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (hasRunningInstance)
                        Row(
                          children: [
                            const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.green,
                            ),
                            Text('( ${deviceInstance.length} )').xSmall()
                          ],
                        ),
                      IconButton.ghost(
                        icon: Icon(Icons.apps),
                        onPressed: () {
                          ref.read(selectedDeviceProvider.notifier).state =
                              widget.device;

                          context.push('/home/device-control',
                              extra: widget.device);
                        },
                      ),
                      IconButton.ghost(
                        icon: const Icon(Icons.settings),
                        onPressed: () => context
                            .push('/home/device-settings/${widget.device.id}'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: SlideInLeft(
              duration: 150.milliseconds,
              from: 15,
              animate: isSelected,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 20),
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: theme.borderRadiusSm,
                  ),
                ),
              ),
            ),
          ),
          if (loading)
            Positioned.fill(
              child: const OutlinedContainer(
                child: SizedBox(),
              ).withOpacity(0.5),
            )
        ],
      ),
    ).clipRRect();
  }

  Future<void> _toWireless() async {
    loading = true;
    setState(() {});

    final workDir = ref.read(execDirProvider);

    try {
      final ip = await AdbUtils.getIpForUSB(workDir, widget.device);

      await AdbUtils.tcpip5555(workDir, widget.device.id);

      final result = await AdbUtils.connectWithIp(workDir, ipport: '$ip:5555');

      if (!result.success) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: el.statusLoc.error,
            content: [Text(result.errorMessage)],
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      showToast(
          showDuration: 1.5.seconds,
          context: context,
          builder: (context, overlay) => Text(el.statusLoc.failed));
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }

  Future<void> _disconnectWireless() async {
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
      showToast(
          showDuration: 1.5.seconds,
          context: context,
          builder: (context, overlay) => Text(el.statusLoc.failed));
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }

  Future<void> _killRunning(List<ScrcpyRunningInstance> instances) async {
    try {
      for (final instance in instances) {
        await ScrcpyUtils.killServer(instance);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
