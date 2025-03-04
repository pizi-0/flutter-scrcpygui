// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';

import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/2.connect_tab/widgets/wifi_qr_pairing_dialog.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'widgets/ip_connect.dart';
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

    return PgScaffold(
      title: el.connectLoc.title,
      appBarTrailing: [
        IconButton.ghost(
          size: ButtonSize.small,
          icon: const Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.qr_code),
          ),
          onPressed: () async {
            final res = await showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => const WifiQrPairing(),
            );

            showToast(
              context: context,
              builder: (context, close) => Card(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ((res as bool?) == null)
                    ? Text(el.connectLoc.qrPair.status.cancelled)
                    : (res as bool)
                        ? Text(el.connectLoc.qrPair.status.success)
                        : Text(el.connectLoc.qrPair.status.failed),
              ),
            );
          },
        ),
      ],
      children: [
        PgSectionCard(
          label: el.connectLoc.withIp.label,
          children: const [
            IPConnect(),
          ],
        ),
        PgSectionCard(
          cardPadding: EdgeInsets.zero,
          borderColor: Colors.transparent,
          label:
              el.connectLoc.withMdns.label(count: '${bonsoirDevices.length}'),
          labelTrail: const CircularProgressIndicator(),
          children: const [
            BonsoirResults(),
          ],
        )
      ],
    );
  }
}
