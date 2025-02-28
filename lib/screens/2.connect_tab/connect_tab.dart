// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
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
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: PageHeader(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(el.connectLoc.title),
              Tooltip(
                message: el.connectLoc.qrPair.label,
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
                            ? InfoLabel(
                                label: el.connectLoc.qrPair.status.cancelled)
                            : (res as bool)
                                ? InfoLabel(
                                    label: el.connectLoc.qrPair.status.success)
                                : InfoLabel(
                                    label: el.connectLoc.qrPair.status.failed),
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
          ConfigCustom(title: el.connectLoc.withIp.label),
          const IPConnect(),
          ConfigCustom(
              title: el.connectLoc.withMdns
                  .label(count: '${bonsoirDevices.length}'),
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
