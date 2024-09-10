// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/scrcpy_running_instance.dart';
// import '../providers/scrcpy_provider.dart';
// import '../utils/scrcpy_command.dart';

// class BottomBar extends StatelessWidget {
//   final List<ScrcpyRunningInstance> pids;
//   final TextEditingController customName;
//   final Function() onPressed;
//   final Function() onNewInstance;
//   final bool multiInstance;
//   const BottomBar(
//       {super.key,
//       required this.pids,
//       required this.customName,
//       required this.onPressed,
//       required this.multiInstance,
//       required this.onNewInstance});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Consumer<ScrcpyProvider>(builder: (context, spy, child) {
//             return spy.device == null
//                 ? const Text('Command preview')
//                 : SelectableText(
//                     'scrcpy ${ScrcpyCommand.buildCommand(spy.selectedConfig, spy.device!, customName: customName.text == '' ? null : customName.text, noWindowOverride: false).toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '')}');
//           }),
//         ),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           width: pids.isNotEmpty ? 90 : 40,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             physics: const NeverScrollableScrollPhysics(),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 pids.isNotEmpty
//                     ? Row(
//                         children: [
//                           FloatingActionButton(
//                             key: const ValueKey('Multi'),
//                             mini: true,
//                             tooltip: 'New instance',
//                             onPressed: onNewInstance,
//                             child: const Icon(Icons.add_rounded),
//                           ),
//                           const SizedBox(width: 10),
//                         ],
//                       )
//                     : const SizedBox.shrink(),
//                 FloatingActionButton(
//                   key: const ValueKey('Start'),
//                   mini: true,
//                   tooltip: pids.isEmpty ? 'Start server' : 'Stop all server',
//                   backgroundColor: pids.isEmpty
//                       ? null
//                       : Theme.of(context).colorScheme.onError,
//                   onPressed: onPressed,
//                   child: pids.isEmpty
//                       ? const Icon(Icons.play_arrow_rounded)
//                       : const Icon(Icons.stop_rounded),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
