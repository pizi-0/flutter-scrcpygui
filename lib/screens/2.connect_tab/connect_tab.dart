// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/adb_provider.dart';

import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/connection_error_dialog.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:string_extensions/string_extensions.dart';

import 'widgets/wifi_qr_pairing_dialog.dart';
import 'widgets/wifi_scan_result.dart';

class WifiScanner extends ConsumerStatefulWidget {
  const WifiScanner({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WifiScannerState();
}

class _WifiScannerState extends ConsumerState<WifiScanner> {
  TextEditingController ipInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);
    final ipHistory = ref.watch(ipHistoryProvider);

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: PageHeader(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Connect'),
              Tooltip(
                message: 'QR pairing',
                child: IconButton(
                  icon: const Padding(
                    padding: EdgeInsets.all(3.0),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ((res as bool?) == null)
                            ? InfoLabel(label: 'Pairing cancelled')
                            : (res as bool)
                                ? InfoLabel(label: 'Pairing successful')
                                : InfoLabel(label: 'Pairing failed'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ConfigCustom(title: 'Connect with IP'),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: AutoSuggestBox(
                  controller: ipInput,
                  noResultsFoundBuilder: (context) => const SizedBox(),
                  items: ipHistory
                      .map((e) => AutoSuggestBoxItem(value: e, label: e))
                      .toList(),
                ),
              ),
              Button(
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text('Connect'),
                ),
                onPressed: () async {
                  final res =
                      await AdbUtils.connectWithIp(ref, ipport: ipInput.text);

                  if (res.success) {
                    ref.read(ipHistoryProvider.notifier).update((state) => [
                          ...state.where(
                            (ip) => !ip.contains(ipInput.text.split(':').first),
                          ),
                          ipInput.text.trim(),
                        ]);

                    await Db.saveWirelessHistory(ref.read(ipHistoryProvider));
                    displayInfoBar(context,
                        builder: (context, close) =>
                            InfoLabel(label: 'Connected to ${ipInput.text}'));
                  }

                  if (!res.success) {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => ErrorDialog(
                        title: 'Error',
                        content: [
                          Text(
                            res.errorMessage.replaceAtIndex(
                                index: 0,
                                replacement: res.errorMessage
                                    .substring(0, 1)
                                    .capitalize),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          ConfigCustom(
              title: 'MDNS devices (${bonsoirDevices.length})',
              child:
                  const SizedBox.square(dimension: 10, child: ProgressRing())),
          const Expanded(
            child: BonsoirResults(),
          )
        ],
      ),
    );
  }
}
