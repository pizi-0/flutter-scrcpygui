// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/info_provider.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/disconnect_dialog.dart';
import 'package:tray_manager/tray_manager.dart' hide MenuItem;

import '../models/adb_devices.dart';
import '../providers/settings_provider.dart';
import '../providers/toast_providers.dart';
import '../utils/tray_utils.dart';
import 'simple_toast/simple_toast_item.dart';

class DeviceIcon extends ConsumerStatefulWidget {
  final AdbDevices? device;

  const DeviceIcon({super.key, required this.device});

  @override
  ConsumerState<DeviceIcon> createState() => _DeviceIconState();
}

class _DeviceIconState extends ConsumerState<DeviceIcon>
    with AutomaticKeepAliveClientMixin {
  bool edit = false;
  TextEditingController name = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool loading = false;
  late ScrcpyInfo info;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (mounted) {
        await trayManager.destroy();
        await TrayUtils.initTray(ref, context);
        final existingInfo = ref.read(infoProvider);

        if (existingInfo
            .where((i) => i.device.serialNo == widget.device!.serialNo)
            .isEmpty) {
          setState(() {
            loading = true;
          });
          info = await AdbUtils.getScrcpyDetailsFor(widget.device!);
          ref.read(infoProvider.notifier).addInfo(info);
          setState(() {
            loading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    name.dispose();
    focusNode.removeListener(_onFocusLoss);
    super.dispose();
  }

  _onFocusLoss() {
    if (!focusNode.hasFocus) {
      setState(() => edit = false);
      focusNode.removeListener(_onFocusLoss);
      name.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final deviceServers = ref
        .watch(scrcpyInstanceProvider)
        .where((ins) => ins.device.id == widget.device!.id)
        .toList();

    final device = ref.watch(savedAdbDevicesProvider).firstWhere(
        (d) => d.serialNo == widget.device!.serialNo,
        orElse: () => widget.device!);

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onSecondaryTapDown: (details) {
          showContextMenu(
            context,
            contextMenu: ContextMenu(
              entries: _buildContextmenuEntries(),
              position: Offset((details.globalPosition.dx + 2),
                  (details.globalPosition.dy + 2)),
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Tooltip(
                message: widget.device?.id ?? '',
                verticalOffset: 50,
                waitDuration: const Duration(milliseconds: 200),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(appTheme.widgetRadius * 0.8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Theme.of(context).colorScheme.onPrimary,
                      onTap: () {
                        ref.read(selectedDeviceProvider.notifier).state =
                            widget.device;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: (selectedDevice != null &&
                                  (selectedDevice.id) == widget.device!.id)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                              appTheme.widgetRadius * 0.8),
                          //   border: Border.all(
                          //     color: Theme.of(context)
                          //         .colorScheme
                          //         .onPrimary
                          //         .withOpacity(0.5),
                          //     width: 2,
                          //   ),
                        ),
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.device!.id.contains('.')
                                        ? const Icon(Icons.wifi)
                                        : const Icon(Icons.usb),
                                    Icon(
                                      Icons.phone_android_rounded,
                                      color: widget.device!.status
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                edit
                                    ? SizedBox(
                                        height: 20,
                                        child: _editname(),
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              device.name?.toUpperCase() ??
                                                  device.modelName
                                                      .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (loading)
                Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(appTheme.widgetRadius * 0.8),
                  ),
                  child: const Center(child: Icon(Icons.timer_rounded)),
                ),
              if (deviceServers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: selectedDevice == widget.device
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.2),
                      ),
                      child: Center(
                          child: Text('${deviceServers.length}').fontSize(10)),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  TextField _editname() {
    return TextField(
      textAlign: TextAlign.center,
      onSubmitted: (v) async {
        final list = [...ref.read(savedAdbDevicesProvider)];

        if (list.where((d) => d.serialNo == widget.device!.serialNo).isEmpty) {
          list.add(widget.device!.copyWith(name: v.trimRight().trimLeft()));
        } else {
          final toEdit =
              list.firstWhere((d) => d.serialNo == widget.device!.serialNo);

          list.remove(toEdit);

          final edited = toEdit.copyWith(name: v.trimRight().trimLeft());
          list.add(edited);
        }

        ref.read(savedAdbDevicesProvider.notifier).state = list;
        await AdbUtils.saveAdbDevice(list);

        setState(() {
          edit = false;
        });
      },
      controller: name,
      focusNode: focusNode,
      decoration: const InputDecoration.collapsed(
        hintText: '',
      ),
    );
  }

  List<ContextMenuEntry> _buildContextmenuEntries() {
    final isWireless = widget.device!.id.contains(':');
    final deviceServers = ref
        .watch(scrcpyInstanceProvider)
        .where((ins) => ins.device.serialNo == widget.device!.serialNo)
        .toList();

    final appPID = ref.watch(appPidProvider);

    if (isWireless) {
      return [
        if (deviceServers.isNotEmpty)
          MenuItem.submenu(
            icon: Icons.close_rounded,
            label: 'Kill Servers',
            items: [
              ...deviceServers.map((s) => MenuItem(
                    label: s.instanceName,
                    onSelected: () async {
                      await ScrcpyUtils.killServer(s, appPID);
                      ref
                          .read(scrcpyInstanceProvider.notifier)
                          .removeInstance(s);
                    },
                  ))
            ],
          ),
        if (deviceServers.isNotEmpty) const MenuDivider(),
        MenuItem(
          label: 'Disconnect',
          icon: Icons.link_off_rounded,
          onSelected: () async {
            ref.read(shouldPollAdb.notifier).state = false;

            setState(() {
              loading = true;
            });

            int indexedOf = ref.read(adbProvider).indexOf(widget.device!);

            final disconnect = await showDialog(
              context: context,
              builder: (context) => DisconnectDialog(device: widget.device!),
            );

            if (disconnect ?? false) {
              await AdbUtils.disconnectWirelessDevice(widget.device!);
              _showToast();

              final connected = await AdbUtils.connectedDevices();
              ref.read(adbProvider.notifier).setConnected(connected);
              if (ref.read(selectedDeviceProvider) != null) {
                if (ref.read(selectedDeviceProvider)!.id == widget.device!.id) {
                  if (indexedOf != -1 && ref.read(adbProvider).isNotEmpty) {
                    ref.read(selectedDeviceProvider.notifier).state = ref
                        .read(adbProvider)[indexedOf == 0 ? 0 : indexedOf - 1];
                  } else {
                    ref.read(selectedDeviceProvider.notifier).state = null;
                  }
                }
              }

              // ref.read(adbProvider.notifier).removeDevice(widget.device!);
              // final connected = await AdbUtils.connectedDevices();
              // ref.read(adbProvider.notifier).setConnected(connected);
            }
            setState(() {
              loading = false;
            });
            ref.read(shouldPollAdb.notifier).state = true;
          },
        ),
        const MenuDivider(),
        MenuItem(
          label: 'Rename',
          icon: Icons.edit_rounded,
          onSelected: () {
            focusNode.requestFocus();
            focusNode.addListener(_onFocusLoss);
            setState(() {
              edit = true;
            });
          },
        ),
      ];
    } else {
      return [
        if (deviceServers.isNotEmpty)
          MenuItem.submenu(
            icon: Icons.close_rounded,
            label: 'Kill Servers',
            items: [
              ...deviceServers.map((s) => MenuItem(
                    label: s.instanceName,
                    onSelected: () async {
                      await ScrcpyUtils.killServer(s, appPID);
                      ref
                          .read(scrcpyInstanceProvider.notifier)
                          .removeInstance(s);
                    },
                  ))
            ],
          ),
        if (deviceServers.isNotEmpty) const MenuDivider(),
        MenuItem(
          label: 'Rename',
          icon: Icons.edit_rounded,
          onSelected: () {
            focusNode.requestFocus();
            focusNode.addListener(_onFocusLoss);
            setState(() {
              edit = true;
            });
          },
        ),
      ];
    }
  }

  _showToast() {
    final named = ref.read(savedAdbDevicesProvider);

    if (named.where((d) => d.serialNo == widget.device!.serialNo).isNotEmpty) {
      final dev =
          named.firstWhere((d) => d.serialNo == widget.device!.serialNo);
      ref.read(toastProvider.notifier).addToast(
            SimpleToastItem(
              icon: Icons.link_off_rounded,
              message: '${dev.name!.toUpperCase()} disconnected',
              toastStyle: SimpleToastStyle.info,
              key: UniqueKey(),
            ),
          );
    } else {
      ref.read(toastProvider.notifier).addToast(
            SimpleToastItem(
              icon: Icons.link_off_rounded,
              message: '${widget.device!.modelName.toUpperCase()} disconnected',
              toastStyle: SimpleToastStyle.info,
              key: UniqueKey(),
            ),
          );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
