// import 'package:flutter/material.dart';
// import 'package:pg_scrcpy/providers/scrcpy_provider.dart';
// import 'package:provider/provider.dart';

// class ModeSelector extends StatefulWidget {
//   const ModeSelector({super.key});

//   @override
//   State<ModeSelector> createState() => _ModeSelectorState();
// }

// class _ModeSelectorState extends State<ModeSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ScrcpyProvider>(builder: (context, spy, child) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         height: spy.device == null ? 0 : 96,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('Mode'),
//               ),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 60,
//                 width: 500,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.secondaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     onTap: () => spy.setMode(Mode.mirroring),
//                                     child: AnimatedContainer(
//                                       height: 44,
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       decoration: BoxDecoration(
//                                         color: spy.mode == Mode.mirroring
//                                             ? Theme.of(context)
//                                                 .colorScheme
//                                                 .onSecondary
//                                             : Colors.transparent,
//                                       ),
//                                       child: const Center(
//                                         child: Text('Mirroring'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     onTap: () => spy.setMode(Mode.recording),
//                                     child: AnimatedContainer(
//                                       height: 44,
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       decoration: BoxDecoration(
//                                         color: spy.mode == Mode.recording
//                                             ? Theme.of(context)
//                                                 .colorScheme
//                                                 .onSecondary
//                                             : Colors.transparent,
//                                       ),
//                                       child: const Center(
//                                         child: Text('Recording'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // spy.mode == Mode.recording
//                       //     ? Padding(
//                       //         padding: const EdgeInsets.all(8.0),
//                       //         child: Row(
//                       //           children: [
//                       //             Center(
//                       //               child: Text(spy.savePath == null
//                       //                   ? ''
//                       //                   : 'Save path:'),
//                       //             ),
//                       //             spy.savePath == null
//                       //                 ? const SizedBox.shrink()
//                       //                 : const SizedBox(width: 10),
//                       //             Expanded(
//                       //               child: ClipRRect(
//                       //                 borderRadius: BorderRadius.circular(10),
//                       //                 child: Material(
//                       //                   color: Colors.transparent,
//                       //                   child: InkWell(
//                       //                     onTap: () => Utils.setSaveFolder(spy),
//                       //                     child: Container(
//                       //                       decoration: BoxDecoration(
//                       //                         color: Theme.of(context)
//                       //                             .colorScheme
//                       //                             .onSecondary,
//                       //                       ),
//                       //                       height: 44,
//                       //                       child: Center(
//                       //                         child: Text(spy.savePath == null
//                       //                             ? 'Pick save directory'
//                       //                             : '${spy.savePath}'),
//                       //                       ),
//                       //                     ),
//                       //                   ),
//                       //                 ),
//                       //               ),
//                       //             ),
//                       //             spy.savePath == null
//                       //                 ? const SizedBox.shrink()
//                       //                 : IconButton(
//                       //                     tooltip: 'Open folder',
//                       //                     onPressed: () =>
//                       //                         Utils.openFolder(spy.savePath!),
//                       //                     icon: const Icon(Icons.folder))
//                       //           ],
//                       //         ),
//                       //       )
//                       //     : const SizedBox.shrink(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
