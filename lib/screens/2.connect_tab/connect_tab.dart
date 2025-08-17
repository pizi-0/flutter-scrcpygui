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
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../db/db.dart';
import '../../providers/version_provider.dart';
import '../../utils/adb_utils.dart';
import '../1.home_tab/widgets/home/widgets/connection_error_dialog.dart';
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
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgScaffoldCustom(
      title: Text(el.connectLoc.title).bold.underline,
      appBarTrailing: [
        IconButton.ghost(
          icon: Icon(Icons.qr_code),
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
      scaffoldBody: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          return AnimatedSwitcher(
            duration: 200.milliseconds,
            child: sizeInfo.isMobile || sizeInfo.isTablet
                ? ConnectTabSmall(ipInput: ipInput)
                : ConnectTabBig(ipInput: ipInput),
          );
        },
      ),
    );
  }
}

class ConnectTabSmall extends ConsumerWidget {
  final TextEditingController ipInput;
  const ConnectTabSmall({super.key, required this.ipInput});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipHistory = ref.watch(ipHistoryProvider);
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);

    return Column(
      children: [
        Gap(6),
        Column(
          spacing: 8,
          children: [
            PgSectionCard(
              label: el.connectLoc.withIp.label,
              labelTrail: IconButton.ghost(
                density: ButtonDensity.dense,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => IPHistoryDialog(controller: ipInput),
                ),
                icon: Icon(Icons.history_rounded),
                leading: Text(el.ipHistoryLoc.title),
              ).showIf(ipHistory.isNotEmpty),
              children: [IPConnect(controller: ipInput)],
            ),
            PgSectionCard(
              cardPadding: const EdgeInsets.all(8),
              label: el.connectLoc.withMdns
                  .label(count: '${bonsoirDevices.length}'),
              labelTrail: const CircularProgressIndicator(),
              children: const [
                BonsoirResults(),
              ],
            ),
          ],
        ),
        Gap(8),
      ],
    );
  }
}

class ConnectTabBig extends ConsumerWidget {
  final TextEditingController ipInput;
  const ConnectTabBig({super.key, required this.ipInput});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);
    final ipHistory = ref.watch(ipHistoryProvider);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        LeftColumn(
          child: PgSectionCardNoScroll(
            label: el.connectLoc.withIp.label,
            expandContent: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                IPConnect(controller: ipInput),
                Divider(),
                Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.muted,
                      borderRadius: theme.borderRadiusSm,
                    ),
                    child: Text(el.ipHistoryLoc.title).textSmall),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemCount: ipHistory.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 8,
                              children: [
                                IpHistoryTile(
                                  ip: ipHistory[index],
                                  ipTextController: ipInput,
                                ),
                                Divider()
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RightColumn(
          child: PgSectionCardNoScroll(
            cardPadding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            label:
                el.connectLoc.withMdns.label(count: '${bonsoirDevices.length}'),
            labelTrail: CircularProgressIndicator(
              duration: 1000.milliseconds,
            ),
            expandContent: true,
            content: BonsoirResults(),
          ),
        ),
      ],
    );
  }
}

class IpHistoryTile extends ConsumerStatefulWidget {
  const IpHistoryTile({
    super.key,
    required this.ip,
    required this.ipTextController,
  });

  final String ip;
  final TextEditingController ipTextController;

  @override
  ConsumerState<IpHistoryTile> createState() => _IpHistoryTileState();
}

class _IpHistoryTileState extends ConsumerState<IpHistoryTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Basic(
      title: Text(widget.ip),
      trailing: Row(
        spacing: 8,
        children: [
          GhostButton(
            density: ButtonDensity.iconDense,
            onPressed: () {
              widget.ipTextController.text = widget.ip;
            },
            child: Icon(Icons.edit_rounded),
          ),
          GhostButton(
            density: ButtonDensity.iconDense,
            onPressed: () => _connect(widget.ip),
            child: loading
                ? SizedBox.square(
                    dimension: 20,
                    child: Center(child: const CircularProgressIndicator()))
                : Icon(Icons.link_rounded),
          ),
        ],
      ),
    );
  }

  Future<void> _connect(String ipport) async {
    loading = true;
    setState(() {});

    try {
      final workDir = ref.read(execDirProvider);
      final res = await AdbUtils.connectWithIp(workDir, ipport: ipport);

      if (res.success) {
        ref.read(ipHistoryProvider.notifier).update((state) {
          if (state.length == 10) {
            state.removeLast();
          }
          return [ipport, ...state.where((ip) => ip != ipport)];
        });

        await Db.saveWirelessHistory(ref.read(ipHistoryProvider));
        showToast(
          showDuration: 1.5.seconds,
          context: context,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) => SurfaceCard(
              child: Basic(
            title: Text(el.connectLoc.withIp.connected(to: ipport)),
            trailing: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
            ),
          )),
        );
      }

      if (!res.success) {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => ErrorDialog(
            title: el.statusLoc.error,
            content: [
              Text(
                res.errorMessage.replaceAtIndex(
                    index: 0,
                    replacement: res.errorMessage.substring(0, 1).capitalize),
              ),
            ],
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        loading = false;
        setState(() {});
      }

      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
            title: el.statusLoc.error, content: [Text(e.toString())]),
      );
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
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
