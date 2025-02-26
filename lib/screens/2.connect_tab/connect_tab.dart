// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

import 'widgets/ip_connect.dart';
import 'widgets/wifi_qr_pairing_dialog.dart';
import 'widgets/wifi_scan_result.dart';

class ConnectTab extends ConsumerStatefulWidget {
  static const route = '/connect';
  const ConnectTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConnectTabState();
}

class _ConnectTabState extends ConsumerState<ConnectTab> {
  TextEditingController ipInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);

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
          const IPConnect(),
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
