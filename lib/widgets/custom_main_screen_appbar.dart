// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:scrcpygui/screens/settings_screen/settings_screen.dart';
// import 'package:scrcpygui/screens/update_screen/update_screen.dart';
// import 'package:scrcpygui/utils/tray_utils.dart';
// import 'package:scrcpygui/widgets/section_button.dart';
// import 'package:window_manager/window_manager.dart';

// import '../providers/settings_provider.dart';
// import '../utils/app_utils.dart';

// class CustomAppbar extends ConsumerStatefulWidget
//     implements PreferredSizeWidget {
//   const CustomAppbar({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _CustomAppbarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(56);
// }

// class _CustomAppbarState extends ConsumerState<CustomAppbar> {
//   // _pollColor() {
//   //   File file = File('/home/pizi/.cache/wal/colors.css');

//   //   colorStream = file.watch().listen(
//   //     (event) {
//   //       if (event.type == FileSystemEvent.modify) {
//   //         AppUtils.getPrimaryColor().then((c) {
//   //           if (c != ref.read(settingsProvider).looks.color) {
//   //             ref.read(settingsProvider.notifier).update((state) => state =
//   //                 state.copyWith(looks: state.looks.copyWith(color: c)));
//   //           }
//   //         });
//   //       }
//   //     },
//   //   );
//   // }

//   @override
//   void initState() {
//     // if (ref.read(settingsProvider).looks.fromWall) {
//     //   _pollColor();
//     // }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

//     final buttonStyle = ButtonStyle(
//         shape: WidgetStatePropertyAll(RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         IconButton(
//           tooltip: 'Exit',
//           style: buttonStyle,
//           onPressed: () async {
//             await AppUtils.onAppCloseRequested(ref, context);
//           },
//           icon: const Icon(Icons.close_rounded, color: Colors.red),
//         ),
//         IconButton(
//           style: buttonStyle,
//           tooltip: 'Hide window',
//           onPressed: () async {
//             await windowManager.hide();
//             await TrayUtils.initTray(ref, context);
//           },
//           icon: const Icon(Icons.minimize_rounded, color: Colors.orange),
//         ),
//         const Expanded(child: DragToMoveArea(child: SizedBox())),
//         IconButton(
//           style: buttonStyle,
//           tooltip: appTheme.brightness == Brightness.dark
//               ? 'Light mode'
//               : 'Dark mode',
//           onPressed: () {
//             var val = appTheme.brightness;

//             if (appTheme.brightness == Brightness.dark) {
//               val = Brightness.light;
//             } else {
//               val = Brightness.dark;
//             }

//             ref.read(settingsProvider.notifier).update((state) => state =
//                 state.copyWith(looks: state.looks.copyWith(brightness: val)));
//           },
//           icon: Icon(
//             appTheme.brightness == Brightness.dark
//                 ? Icons.sunny
//                 : Icons.nightlight_round,
//             color: Colors.orange,
//           ),
//         ),
//         SectionButton(
//           icondata: Icons.system_update_alt,
//           tooltipmessage: 'Update',
//           ontap: () {
//             Navigator.push(context,
//                 CupertinoPageRoute(builder: (context) => const UpdateScreen()));
//           },
//         ),
//         IconButton(
//           style: buttonStyle,
//           tooltip: 'Settings',
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                     builder: (context) => const SettingsScreen()));
//           },
//           icon: Icon(
//             Icons.settings_rounded,
//             color: Theme.of(context).colorScheme.onPrimaryContainer,
//           ),
//         ),
//       ],
//     );
//   }
// }
