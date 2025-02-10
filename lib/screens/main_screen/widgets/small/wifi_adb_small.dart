// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrcpygui/providers/bonsoir_devices.dart';

import '../shared/wifi_qr_pairing_dialog.dart';
import '../shared/wifi_scan_result.dart';

class WifiScanner extends ConsumerStatefulWidget {
  const WifiScanner({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WifiScannerState();
}

class _WifiScannerState extends ConsumerState<WifiScanner> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: PageHeader(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Connect'),
            IconButton(
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(FluentIcons.q_r_code),
              ),
              onPressed: () async {
                final res = await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const WifiQrPairing(),
                );

                displayInfoBar(
                  context,
                  builder: (context, close) => Card(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ((res as bool?) == null)
                        ? InfoLabel(label: 'Pairing cancelled')
                        : (res as bool)
                            ? InfoLabel(label: 'Pairing successful')
                            : InfoLabel(label: 'Pairing failed'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discovered devices (${bonsoirDevices.length})')
                  .textStyle(theme.typography.body)
                  .fontWeight(FontWeight.w600),
              const SizedBox.square(dimension: 18, child: ProgressRing()),
            ],
          ),
          const Expanded(
            child: BonsoirResults(),
          )
        ],
      ),
    );
  }
}

// class PairDialog extends ConsumerStatefulWidget {
//   final BonsoirService service;
//   const PairDialog({super.key, required this.service});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _PairDialogState();
// }

// class _PairDialogState extends ConsumerState<PairDialog> {
//   bool loading = false;

//   @override
//   Widget build(BuildContext context) {
//     return ContentDialog(
//       title: const Text('Pairing'),
//       content: loading
//           ? const Center(child: ProgressRing())
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               spacing: 2,
//               children: [
//                 Text('Attempting to pair with ${widget.service.name}'),
//                 const Text('\nInstruction:'),
//                 const Text(
//                     'Go to [Developer options] > [Wireless debugging] > [Pair device with pairing code]'),
//                 const SizedBox(height: 10),
//                 TextBox(
//                   placeholder: 'Insert code and press [Enter]',
//                   onSubmitted: (value) async {
//                     loading = true;
//                     setState(() {});
//                     await AdbUtils.pairWithCode(
//                         widget.service.name, value.trim(), ref);

//                     await AdbUtils.connectWithMdns(
//                       ref,
//                       id: widget.service.name,
//                       from: 'pair dialog',
//                     );

//                     loading = false;
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//       actions: [
//         Button(child: const Text('Cancel'), onPressed: () {}),
//       ],
//     );
//   }
// }
