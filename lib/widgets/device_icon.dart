// // ignore_for_file: use_build_context_synchronously

// import 'package:awesome_extensions/awesome_extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_context_menu/flutter_context_menu.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
// import 'package:scrcpygui/providers/adb_provider.dart';
// import 'package:scrcpygui/providers/poll_provider.dart';
// import 'package:scrcpygui/providers/scrcpy_provider.dart';
// import 'package:scrcpygui/screens/device_settings_screen/device_settings_screen.dart';
// import 'package:scrcpygui/utils/adb/adb_utils.dart';
// import 'package:scrcpygui/utils/scrcpy_utils.dart';
// import 'package:scrcpygui/widgets/disconnect_dialog.dart';
// import 'package:string_extensions/string_extensions.dart';

// import '../models/adb_devices.dart';
// import '../providers/settings_provider.dart';
// import '../providers/toast_providers.dart';
// import '../providers/version_provider.dart';
// import 'simple_toast/simple_toast_item.dart';

// class DeviceIcon extends ConsumerStatefulWidget {
//   final AdbDevices? device;

//   const DeviceIcon({super.key, required this.device});

//   @override
//   ConsumerState<DeviceIcon> createState() => _DeviceIconState();
// }

// class _DeviceIconState extends ConsumerState<DeviceIcon>
//     with AutomaticKeepAliveClientMixin {
//   bool edit = false;
//   TextEditingController name = TextEditingController();
//   FocusNode focusNode = FocusNode();
//   bool loading = false;
//   late ScrcpyInfo info;

//   @override
//   void dispose() {
//     name.dispose();
//     focusNode.removeListener(_onFocusLoss);
//     super.dispose();
//   }

//   _onFocusLoss() {
//     if (!focusNode.hasFocus) {
//       setState(() => edit = false);
//       focusNode.removeListener(_onFocusLoss);
//       name.text = '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final colorScheme = Theme.of(context).colorScheme;

//     final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
//     final selectedDevice = ref.watch(selectedDeviceProvider);
//     final deviceServers = ref
//         .watch(scrcpyInstanceProvider)
//         .where((ins) => ins.device.id == widget.device!.id)
//         .toList();

//     final device = ref.watch(savedAdbDevicesProvider).firstWhere(
//         (d) => d.id == widget.device!.id,
//         orElse: () => widget.device!);

//     return Padding(
//       padding: const EdgeInsets.only(right: 4),
//       child: GestureDetector(
//         onSecondaryTapDown: (details) {
//           showContextMenu(
//             context,
//             contextMenu: ContextMenu(
//               entries: _buildContextmenuEntries(device),
//               position: Offset((details.globalPosition.dx + 2),
//                   (details.globalPosition.dy + 2)),
//             ),
//           );
//         },
//         child: AspectRatio(
//           aspectRatio: 1,
//           child: Stack(
//             children: [
//               Tooltip(
//                 message: device.id,
//                 verticalOffset: 50,
//                 waitDuration: const Duration(milliseconds: 200),
//                 child: ClipRRect(
//                   borderRadius:
//                       BorderRadius.circular(appTheme.widgetRadius * 0.8),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       focusColor: colorScheme.onPrimary,
//                       onTap: () {
//                         ref.read(selectedDeviceProvider.notifier).state =
//                             device;
//                       },
//                       child: AnimatedContainer(
//                         duration: 100.milliseconds,
//                         decoration: BoxDecoration(
//                           color: (selectedDevice != null &&
//                                   (selectedDevice.id) == device.id)
//                               ? colorScheme.secondaryContainer
//                               : Theme.of(context)
//                                   .colorScheme
//                                   .secondaryContainer
//                                   .withValues(alpha: 0.3),
//                           borderRadius: BorderRadius.circular(
//                               appTheme.widgetRadius * 0.8),
//                           // border: Border.all(
//                           //   color: (selectedDevice != null &&
//                           //           (selectedDevice.id) == widget.device!.id)
//                           //       ? colorScheme.primaryContainer
//                           //       : Colors.transparent,
//                           //   width: 4,
//                           // ),
//                         ),
//                         height: 100,
//                         width: 100,
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     device.id.isIpv4
//                                         ? Icon(Icons.wifi,
//                                             color: colorScheme.inverseSurface)
//                                         : Icon(Icons.usb,
//                                             color: colorScheme.inverseSurface),
//                                     Icon(
//                                       Icons.phone_android_rounded,
//                                       color: colorScheme.inverseSurface,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 edit
//                                     ? SizedBox(
//                                         height: 20,
//                                         child: _editname(),
//                                       )
//                                     : Row(
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               device.name?.toUpperCase() ??
//                                                   device.modelName
//                                                       .toUpperCase(),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.center,
//                                             ).textColor(
//                                                 colorScheme.inverseSurface),
//                                           ),
//                                         ],
//                                       ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               if (loading)
//                 Container(
//                   height: double.maxFinite,
//                   width: double.maxFinite,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primaryContainer
//                         .withValues(alpha: 0.5),
//                     borderRadius:
//                         BorderRadius.circular(appTheme.widgetRadius * 0.8),
//                   ),
//                   child: const Center(child: Icon(Icons.timer_rounded)),
//                 ),
//               if (deviceServers.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                       height: 20,
//                       width: 20,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4),
//                         color: selectedDevice == device
//                             ? colorScheme.inversePrimary
//                             : Theme.of(context)
//                                 .colorScheme
//                                 .onPrimary
//                                 .withValues(alpha: 0.2),
//                       ),
//                       child: Center(
//                           child: Text('${deviceServers.length}').fontSize(10)),
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   TextField _editname() {
//     return TextField(
//       textAlign: TextAlign.center,
//       onSubmitted: (v) async {
//         var dev = widget.device!;
//         final workDir = ref.read(execDirProvider);

//         if (dev.info == null) {
//           setState(() {
//             loading = true;
//           });
//           final info = await AdbUtils.getScrcpyDetailsFor(workDir, dev);
//           dev = dev.copyWith(info: info);
//         }

//         dev = dev.copyWith(name: v.trim());

//         ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);

//         final list = ref.read(savedAdbDevicesProvider);

//         await AdbUtils.saveAdbDevice(list);

//         setState(() {
//           edit = false;
//           loading = false;
//         });
//       },
//       controller: name,
//       focusNode: focusNode,
//       decoration: const InputDecoration.collapsed(
//         hintText: '',
//       ),
//     );
//   }

//   List<ContextMenuEntry> _buildContextmenuEntries(AdbDevices dev) {
//     final isWireless = dev.id.isIpv4;
//     final deviceServers = ref
//         .watch(scrcpyInstanceProvider)
//         .where((ins) => ins.device.id == dev.id)
//         .toList();

//     final appPID = ref.watch(appPidProvider);

//     if (isWireless) {
//       return [
//         if (deviceServers.isNotEmpty)
//           MenuItem.submenu(
//             icon: Icons.close_rounded,
//             label: 'Kill Servers',
//             items: [
//               ...deviceServers.map((s) => MenuItem(
//                     label: s.instanceName,
//                     onSelected: () async {
//                       await ScrcpyUtils.killServer(s, appPID);
//                       ref
//                           .read(scrcpyInstanceProvider.notifier)
//                           .removeInstance(s);
//                     },
//                   ))
//             ],
//           ),
//         if (deviceServers.isNotEmpty) const MenuDivider(),
//         MenuItem(
//           label: 'Disconnect',
//           icon: Icons.link_off_rounded,
//           onSelected: () async {
//             ref.read(shouldPollAdb.notifier).state = false;
//             final workDir = ref.read(execDirProvider);

//             setState(() {
//               loading = true;
//             });

//             int indexedOf = ref.read(adbProvider).indexOf(dev);

//             final disconnect = await showDialog(
//               context: context,
//               builder: (context) => DisconnectDialog(device: dev),
//             );

//             if (disconnect ?? false) {
//               await AdbUtils.disconnectWirelessDevice(workDir, dev);
//               _showToast();

//               final connected = await AdbUtils.connectedDevices(workDir);
//               ref.read(adbProvider.notifier).setConnected(connected);
//               if (ref.read(selectedDeviceProvider) != null) {
//                 if (ref.read(selectedDeviceProvider)!.id == dev.id) {
//                   if (indexedOf != -1 && ref.read(adbProvider).isNotEmpty) {
//                     ref.read(selectedDeviceProvider.notifier).state = ref
//                         .read(adbProvider)[indexedOf == 0 ? 0 : indexedOf - 1];
//                   } else {
//                     ref.read(selectedDeviceProvider.notifier).state = null;
//                   }
//                 }
//               }
//             }
//             setState(() {
//               loading = false;
//             });
//             ref.read(shouldPollAdb.notifier).state = true;
//           },
//         ),
//         const MenuDivider(),
//         MenuItem(
//           icon: Icons.settings,
//           label: 'Device settings',
//           onSelected: () async {
//             final workDir = ref.read(execDirProvider);

//             setState(() {
//               loading = true;
//             });

//             if (dev.info == null) {
//               final info = await AdbUtils.getScrcpyDetailsFor(workDir, dev);

//               dev = dev.copyWith(info: info);

//               ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
//               final saved = ref.read(savedAdbDevicesProvider);
//               await AdbUtils.saveAdbDevice(saved);
//             }

//             setState(() {
//               loading = false;
//             });

//             Navigator.push(
//               context,
//               PageTransition(
//                   child: DeviceSettingsScreen(device: dev),
//                   type: PageTransitionType.rightToLeft),
//             );
//           },
//         ),
//         const MenuDivider(),
//         MenuItem(
//           label: 'Rename',
//           icon: Icons.edit_rounded,
//           onSelected: () {
//             focusNode.requestFocus();
//             focusNode.addListener(_onFocusLoss);
//             setState(() {
//               if (dev.name != null) {
//                 name.text = dev.name!;
//               }
//               edit = true;
//             });
//           },
//         ),
//       ];
//     } else {
//       final connected = ref.read(adbProvider);
//       final wirelessAreadyConnected = connected
//           .where((d) => d.serialNo == dev.serialNo && d.id.isIpv4)
//           .isNotEmpty;

//       return [
//         if (deviceServers.isNotEmpty)
//           MenuItem.submenu(
//             icon: Icons.close_rounded,
//             label: 'Kill Servers',
//             items: [
//               ...deviceServers.map((s) => MenuItem(
//                     label: s.instanceName,
//                     onSelected: () async {
//                       await ScrcpyUtils.killServer(s, appPID);
//                       ref
//                           .read(scrcpyInstanceProvider.notifier)
//                           .removeInstance(s);
//                     },
//                   ))
//             ],
//           ),
//         if (deviceServers.isNotEmpty) const MenuDivider(),
//         if (!wirelessAreadyConnected)
//           MenuItem(
//             label: 'To wireless',
//             icon: Icons.wifi,
//             onSelected: () async {
//               final workDir = ref.read(execDirProvider);

//               setState(() {
//                 loading = true;
//               });
//               final ip = '${await AdbUtils.getIpForUSB(workDir, dev)}:5555';
//               await AdbUtils.tcpip5555(workDir, widget.device!.id);
//               await AdbUtils.connectWifiDebugging(ref, ip: ip);
//               final connected = await AdbUtils.connectedDevices(workDir);

//               if (connected.where((d) => d.id == ip).isNotEmpty) {
//                 await AdbUtils.saveWirelessDeviceHistory(ref, ip);
//               }

//               setState(() {
//                 loading = false;
//               });
//             },
//           ),
//         if (!wirelessAreadyConnected) const MenuDivider(),
//         MenuItem(
//           label: 'Rename',
//           icon: Icons.edit_rounded,
//           onSelected: () {
//             focusNode.requestFocus();
//             focusNode.addListener(_onFocusLoss);
//             setState(() {
//               edit = true;
//             });
//           },
//         ),
//       ];
//     }
//   }

//   _showToast() {
//     ref.read(toastProvider.notifier).addToast(
//           SimpleToastItem(
//             icon: Icons.link_off_rounded,
//             message:
//                 '${widget.device!.name?.toUpperCase() ?? widget.device!.modelName.toUpperCase()} disconnected',
//             toastStyle: SimpleToastStyle.info,
//             key: UniqueKey(),
//           ),
//         );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
