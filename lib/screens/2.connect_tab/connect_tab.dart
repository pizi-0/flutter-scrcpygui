// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart'
    show NumExtension, WidgetCommonExtension;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';

import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/2.connect_tab/widgets/wifi_qr_pairing_dialog.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
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
  void dispose() {
    ipInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgScaffold(
      title: el.connectLoc.title,
      appBarTrailing: [
        IconButton.ghost(
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
              showDuration: 1.5.seconds,
              builder: (context, close) => SurfaceCard(
                child: ((res as bool?) == null)
                    ? Basic(
                        title: Text(el.connectLoc.qrPair.status.cancelled),
                        trailing: const Icon(
                          Icons.cancel,
                          color: Colors.amber,
                        ),
                      )
                    : (res as bool)
                        ? Basic(
                            title: Text(el.connectLoc.qrPair.status.success),
                            trailing: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          )
                        : Basic(
                            title: Text(el.connectLoc.qrPair.status.failed),
                            trailing: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
              ),
              location: ToastLocation.bottomCenter,
            );
          },
        ),
      ],
      children: [
        ResponsiveBuilder(
          builder: (context, size) {
            final ipHistory = ref.watch(ipHistoryProvider);
            return PgSectionCard(
              label: el.connectLoc.withIp.label,
              labelTrail: IconButton.ghost(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => IPHistoryDialog(controller: ipInput),
                ),
                icon: Icon(Icons.history_rounded),
                leading: Text(el.ipHistoryLoc.title),
              ).showIf(
                  (size.isMobile || size.isTablet) && ipHistory.isNotEmpty),
              children: [
                IPConnect(controller: ipInput),
              ],
            );
          },
        ),
        PgSectionCard(
          cardPadding: const EdgeInsets.all(8),
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

class IPHistoryDialog extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const IPHistoryDialog({super.key, required this.controller});

  @override
  ConsumerState<IPHistoryDialog> createState() => _IPHistoryDialogState();
}

class _IPHistoryDialogState extends ConsumerState<IPHistoryDialog> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final ipHistory = ref.watch(ipHistoryProvider);

    return AlertDialog(
      title: Text(el.ipHistoryLoc.title),
      content: PgSectionCard(
        children: ipHistory
            .mapIndexed(
              (index, ip) => Column(
                spacing: 8,
                children: [
                  PgListTile(
                    title: ip,
                    trailing: IconButton.ghost(
                      onPressed: () => {
                        widget.controller.text = ip,
                        context.pop(),
                      },
                      icon: Icon(Icons.edit_rounded),
                    ),
                  ),
                  if (index != ipHistory.length - 1) const Divider()
                ],
              ),
            )
            .toList(),
      ),
      actions: [
        Button.secondary(
          onPressed: () => context.pop(),
          child: Text(el.buttonLabelLoc.close),
        ),
      ],
    );
  }
}
