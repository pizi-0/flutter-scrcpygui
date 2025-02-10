// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:scrcpygui/widgets/config_tiles.dart';
// import 'package:tray_manager/tray_manager.dart';

// import '../../../providers/settings_provider.dart';
// import '../../../utils/app_utils.dart';
// import '../../../utils/tray_utils.dart';
// import '../../../widgets/body_container.dart';

// class AppBehaviourSection extends ConsumerStatefulWidget {
//   const AppBehaviourSection({super.key});

//   @override
//   ConsumerState<AppBehaviourSection> createState() =>
//       _AppBehaviourSectionState();
// }

// class _AppBehaviourSectionState extends ConsumerState<AppBehaviourSection> {
//   @override
//   Widget build(BuildContext context) {
//     final behaviour = ref.watch(settingsProvider.select((s) => s.behaviour));
//     final colorScheme = Theme.of(context).colorScheme;

//     return BodyContainer(
//       headerTitle: 'App behaviour',
//       spacing: 4,
//       children: [
//         ConfigCustom(
//           childBackgroundColor: Colors.transparent,
//           title: 'Show tray icon',
//           child: Checkbox(
//             value: behaviour.traySupport,
//             checkColor: colorScheme.surface,
//             onChanged: (v) async {
//               ref.read(settingsProvider.notifier).update((state) => state =
//                   state.copyWith(
//                       behaviour: state.behaviour.copyWith(traySupport: v)));

//               if (v == true) {
//                 await trayManager.destroy();
//                 await TrayUtils.initTray(ref, context);
//               } else {
//                 await trayManager.destroy();
//               }

//               final newSettings = ref.read(settingsProvider);

//               await AppUtils.saveAppSettings(newSettings);
//             },
//           ),
//         ),
//         ConfigCustom(
//           childBackgroundColor: Colors.transparent,
//           title: 'Quitting kill instances with no window',
//           child: Checkbox(
//             value: behaviour.traySupport,
//             checkColor: colorScheme.surface,
//             onChanged: (v) async {
//               ref.read(settingsProvider.notifier).update((state) => state =
//                   state.copyWith(
//                       behaviour: state.behaviour.copyWith(traySupport: v)));

//               if (v == true) {
//                 await trayManager.destroy();
//                 await TrayUtils.initTray(ref, context);
//               } else {
//                 await trayManager.destroy();
//               }

//               final newSettings = ref.read(settingsProvider);

//               await AppUtils.saveAppSettings(newSettings);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
