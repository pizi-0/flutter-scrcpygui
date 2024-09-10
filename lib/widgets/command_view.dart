// import 'package:flutter/material.dart';

// import '../providers/scrcpy_provider.dart';

// class CommandView extends StatelessWidget {
//   const CommandView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Consumer<ScrcpyProvider>(
//         builder: (context, spy, child) {
//           // var arguments = spy.config?.args
//           //         .toString()
//           //         .replaceAll('[', '')
//           //         .replaceAll(']', '')
//           //         .replaceAll(',', '') ??
//           //     '';

//           return Row(
//             children: [
//               const Text('Command: '),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondaryContainer,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   // child: SelectableText(
//                   //   ' scrcpy -s ${spy.deviceId ?? ''} $arguments',
//                   //   maxLines: 1,
//                   // ),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               FloatingActionButton(
//                 mini: true,
//                 onPressed: () {},
//                 child: const Icon(Icons.play_arrow_rounded),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
