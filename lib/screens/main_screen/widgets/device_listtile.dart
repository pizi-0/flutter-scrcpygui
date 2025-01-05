import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/disconnect_dialog.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../models/adb_devices.dart';
import '../../../providers/adb_provider.dart';
import '../../../utils/const.dart';
import '../../device_settings_screen/device_settings_screen.dart';

class DeviceListtile extends ConsumerStatefulWidget {
  final AdbDevices device;

  const DeviceListtile({super.key, required this.device});

  @override
  ConsumerState<DeviceListtile> createState() => _DeviceListtileState();
}

class _DeviceListtileState extends ConsumerState<DeviceListtile> {
  bool loading = false;
  Ping? ping;
  int retries = 0;
  Timer? pingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) {
      _pingWireless();
    });
  }

  @override
  void dispose() {
    ping?.stop();
    pingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final theme = Theme.of(context);
    final isWireless =
        widget.device.id.contains(adbMdns) || widget.device.id.isIpv4;
    final workDir = ref.watch(execDirProvider);
    final instances = ref.watch(scrcpyInstanceProvider);

    final selected = selectedDevice == widget.device;

    final deviceInstance =
        instances.where((i) => i.device.id == widget.device.id).toList();

    return GestureDetector(
      onSecondaryTapDown: (details) {
        showContextMenu(
          context,
          contextMenu: ContextMenu(
            position: Offset((details.globalPosition.dx + 2),
                (details.globalPosition.dy + 2)),
            entries: [
              MenuItem.submenu(
                label: 'Kill running scrcpy',
                items: deviceInstance.isEmpty
                    ? const [
                        MenuHeader(
                            text: 'No running scrcpy', disableUppercase: true)
                      ]
                    : deviceInstance
                        .map(
                          (ins) => MenuItem(
                            label: ins.instanceName,
                            onSelected: () async {
                              loading = true;
                              setState(() {});

                              await ScrcpyUtils.killServer(
                                  ins, ref.read(appPidProvider));

                              loading = false;
                              setState(() {});
                            },
                          ),
                        )
                        .toList(),
              ),
              const MenuDivider(),
              if (isWireless)
                MenuItem(
                  label: 'Disconnect',
                  icon: Icons.link_off,
                  onSelected: () async {
                    final proceed = await showDialog(
                      context: context,
                      builder: (context) =>
                          DisconnectDialog(device: widget.device),
                    );

                    if (proceed) {
                      loading = true;
                      setState(() {});

                      // await Future.delayed(5.seconds);

                      await AdbUtils.disconnectWirelessDevice(
                          workDir, widget.device);

                      await Future.delayed(1.5.seconds);

                      // await AdbUtils.connectedDevices(workDir);

                      if (mounted) {
                        loading = false;
                        setState(() {});
                      }
                    }
                  },
                ),
              if (!isWireless)
                MenuItem(
                  label: 'To wireless',
                  icon: Icons.link_off,
                  onSelected: () async {
                    loading = true;
                    setState(() {});

                    List<AdbDevices> connected = ref.read(adbProvider);

                    final ip =
                        await AdbUtils.getIpForUSB(workDir, widget.device);

                    if (connected.where((c) => c.id.contains(ip)).isEmpty) {
                      await AdbUtils.tcpip5555(workDir, widget.device.id);

                      await Future.delayed(1.5.seconds);

                      connected = await AdbUtils.connectedDevices(workDir);

                      await AdbUtils.connectWithIp(workDir, ip: ip);
                    }

                    if (mounted) {
                      loading = false;
                      setState(() {});
                    }
                  },
                ),
            ],
          ),
        );
      },
      child: AnimatedContainer(
        duration: 200.milliseconds,
        decoration: BoxDecoration(
          color: widget.device == selectedDevice
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.secondaryContainer,
        ),
        child: ListTile(
          enabled: !loading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          dense: true,
          onTap: () =>
              ref.read(selectedDeviceProvider.notifier).state = widget.device,
          minLeadingWidth: 10,
          leading: Icon(
            widget.device.id.isIpv4 || widget.device.id.contains(adbMdns)
                ? Icons.wifi_rounded
                : Icons.usb_rounded,
          ),
          title: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  widget.device.name?.toUpperCase() ?? widget.device.modelName),
              if (deviceInstance.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.surface
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                      child: Text('Running: ${deviceInstance.length}')
                          .fontSize(8)),
                ),
            ],
          ),
          subtitle: Text(
            widget.device.id,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: loading
              ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: CupertinoActivityIndicator())
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                DeviceSettingsScreen(device: widget.device)));
                  },
                  icon: const Icon(Icons.settings_rounded),
                ),
        ),
      ),
    );
  }

  _pingWireless() async {
    if (widget.device.ip.isIpv4) {
      ping = Ping(widget.device.ip!.split(':').first);
      final workDir = ref.read(execDirProvider);

      ping?.stream.listen((p) {
        if (p.error != null) {
          if (retries < 10) {
            retries += 1;
            setState(() {});
          } else {
            ping?.stop();
            AdbUtils.disconnectWirelessDevice(workDir, widget.device);
          }
        }
      });
    }
  }
}
