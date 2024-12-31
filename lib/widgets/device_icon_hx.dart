import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';

import '../models/adb_devices.dart';
import '../providers/settings_provider.dart';

class DeviceHistoryIcon extends ConsumerStatefulWidget {
  final AdbDevices? device;

  final Function()? hxOntap;
  const DeviceHistoryIcon({super.key, required this.device, this.hxOntap});

  @override
  ConsumerState<DeviceHistoryIcon> createState() => _DeviceHistoryIconState();
}

class _DeviceHistoryIconState extends ConsumerState<DeviceHistoryIcon> {
  bool edit = false;
  late final ping = Ping(widget.device!.id.split(':').first);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    final isConnected = ref
        .watch(adbProvider)
        .where((d) => d.id == widget.device!.id)
        .isNotEmpty;

    final device = ref.watch(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == widget.device!.id,
        orElse: () => widget.device!);

    return GestureDetector(
      onSecondaryTapDown: (details) {
        showContextMenu(
          context,
          contextMenu: ContextMenu(
            position: Offset((details.globalPosition.dx + 2),
                (details.globalPosition.dy + 2)),
            entries: _buildContextmenuEntries(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Tooltip(
          message: widget.device?.id ?? '',
          verticalOffset: 50,
          waitDuration: const Duration(milliseconds: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Theme.of(context).colorScheme.onPrimary,
                onTap: widget.hxOntap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withValues(alpha: 0.3),
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
                              Icon(Icons.phone_android_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  device.name?.toUpperCase() ??
                                      device.modelName.toUpperCase().toString(),
                                ),
                                if (isConnected)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              widget.device!.id,
                            ),
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
      ),
    );
  }

  List<ContextMenuEntry> _buildContextmenuEntries() {
    final isAuto = ref.read(autoConnectDevicesProvider).contains(widget.device);
    return [
      isAuto
          ? MenuItem(
              icon: Icons.close_rounded,
              label: 'Disable auto connect',
              onSelected: () async {
                ref.read(autoConnectDevicesProvider.notifier).update((state) =>
                    state = state.where((e) => e != widget.device!).toList());

                final devs = ref.read(autoConnectDevicesProvider);
                await AdbUtils.saveAutoConnectDevices(devs);
              },
            )
          : MenuItem(
              icon: Icons.add_rounded,
              label: 'Enable auto connect',
              onSelected: () async {
                ref.read(autoConnectDevicesProvider.notifier).update((state) =>
                    state = [
                      ...state.where((e) => e.id != widget.device!.id),
                      widget.device!
                    ]);
                final devs = ref.read(autoConnectDevicesProvider);
                await AdbUtils.saveAutoConnectDevices(devs);
              },
            ),
      const MenuDivider(),
      MenuItem(
        icon: Icons.remove,
        label: 'Remove from history',
        onSelected: () {
          final hx = [...ref.read(wirelessDevicesHistoryProvider)];
          hx.remove(widget.device!);

          ref.read(wirelessDevicesHistoryProvider.notifier).state = hx;
          AdbUtils.saveWirelessHistory(hx);
        },
      ),
    ];
  }
}
