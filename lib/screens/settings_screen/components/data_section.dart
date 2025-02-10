// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:scrcpygui/widgets/config_tiles.dart';
// import 'package:scrcpygui/widgets/section_button.dart';

// import '../../../widgets/body_container.dart';
// import '../../../widgets/clear_preferences_dialog.dart';

// class DataSection extends ConsumerStatefulWidget {
//   const DataSection({super.key});

//   @override
//   ConsumerState<DataSection> createState() => _DataSectionState();
// }

// class _DataSectionState extends ConsumerState<DataSection> {
//   @override
//   Widget build(BuildContext context) {
//     return BodyContainer(
//       headerTitle: 'Data',
//       children: [
//         ConfigCustom(
//           childBackgroundColor: Colors.transparent,
//           title: 'Clear preferences',
//           child: SectionButton(
//             ontap: () async {
//               showAdaptiveDialog(
//                 context: context,
//                 builder: (context) {
//                   return const ClearPreferencesDialog();
//                 },
//               );
//             },
//             icondata: Icons.delete_rounded,
//           ),
//         ),
//       ],
//     );
//   }
// }
