// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:uuid/uuid.dart';

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

class BonsoirResults extends ConsumerStatefulWidget {
  const BonsoirResults({super.key});

  @override
  ConsumerState<BonsoirResults> createState() => _BonsoirResultsState();
}

class _BonsoirResultsState extends ConsumerState<BonsoirResults> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);

    return ListView.builder(
      itemCount: bonsoirDevices.length,
      itemBuilder: (context, index) {
        return BdTile(bonsoirDevice: bonsoirDevices[index]);
      },
    );
  }
}

class BdTile extends ConsumerStatefulWidget {
  final BonsoirService bonsoirDevice;
  const BdTile({super.key, required this.bonsoirDevice});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BdTileState();
}

class _BdTileState extends ConsumerState<BdTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final savedDevices = ref.watch(savedAdbDevicesProvider);
    final connectedDevices = ref.watch(adbProvider);
    final theme = FluentTheme.of(context);
    AdbDevices? device;
    final bd = widget.bonsoirDevice;
    final isSaved =
        savedDevices.where((e) => e.id.contains(bd.name)).isNotEmpty;

    if (isSaved) {
      device = savedDevices.firstWhere((e) => e.id.contains(bd.name));
    }

    bool connected =
        connectedDevices.where((e) => e.id.contains(bd.name)).isNotEmpty;
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      key: ValueKey(bd),
      padding: EdgeInsets.zero,
      child: ListTile(
        title: Text('${bd.name} ${isSaved ? '[${device!.name!}]' : ''}'),
        subtitle: Text('${bd.toJson()['service.host']}:${bd.port}'),
        trailing: IconButton(
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loading
                ? SizedBox.square(
                    dimension: theme.iconTheme.size! - 4,
                    child: const ProgressRing())
                : connected
                    ? const Icon(
                        FluentIcons.check_mark,
                        color: Colors.successPrimaryColor,
                      )
                    : const Icon(FluentIcons.link),
          ),
          style: ButtonStyle(
            backgroundColor: connected
                ? const WidgetStatePropertyAll(Colors.transparent)
                : null,
          ),
          onPressed: loading || connected
              ? null
              : () async {
                  loading = true;
                  setState(() {});
                  final res = await AdbUtils.connectWithMdns(ref,
                      id: bd.name, from: 'device tile');

                  if (mounted) {
                    if (!res.success) {
                      if (res.errorMessage
                          .toLowerCase()
                          .contains('unauthenticated')) {
                        showDialog(
                          context: context,
                          builder: (context) => const ErrorDialog(
                            title: 'Unauthenticated',
                            content: [
                              Text('Check your phone.'),
                              Text('Click allow debugging.')
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => ErrorDialog(
                            title: 'Failed',
                            content: [
                              Text(res.errorMessage.capitalizeFirst),
                              const Text(
                                  'Make sure your device is paired to your PC\'s adb.'),
                              const Text(
                                  'Otherwise, try turning wireless Adb off and on.'),
                              const Text('\nIf not paired:'),
                              const Text(
                                  '1. Use the pair windows (top-right button) '),
                              const Text(
                                  '2. Plug you device into your PC, allow debugging, and retry.'),
                            ],
                          ),
                        );
                      }
                    }
                    loading = false;
                    setState(() {});
                  }
                },
        ),
      ),
    );
  }
}

class ErrorDialog extends ConsumerWidget {
  final String title;
  final List<Widget> content;
  const ErrorDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContentDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
      actions: [
        Button(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class WifiQrPairing extends ConsumerStatefulWidget {
  const WifiQrPairing({super.key});

  @override
  ConsumerState<WifiQrPairing> createState() => _WifiQrPairingState();
}

class _WifiQrPairingState extends ConsumerState<WifiQrPairing> {
  late MDnsClient client;
  final String id = const Uuid().v1();
  bool loading = false;
  late Stream stream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (a) {
        _startScan();
      },
    );
  }

  @override
  void dispose() {
    client.stop();
    super.dispose();
  }

  _startScan() async {
    client = MDnsClient();
    late PtrResourceRecord? scanResult;
    late String pairRes;

    await client.start();
    debugPrint('Start scan for device to pair');

    stream = client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_adb-tls-pairing._tcp'),
        timeout: 180.seconds);

    scanResult = await stream.first.onError((error, stackTrace) => null);

    client.stop();

    if (scanResult != null) {
      if (mounted) {
        loading = true;
        setState(() {});
      }

      debugPrint('Start pairing');

      pairRes = await AdbUtils.pairWithCode(
          scanResult.domainName.replaceAll('._adb-tls-pairing._tcp.local', ''),
          'scrcpygui',
          ref);

      Navigator.pop(context, pairRes.contains('Successfully paired to'));
    } else {
      debugPrint('scan is null');
      if (mounted) {
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Pair device'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          const Text(
              '[Developer option] > [Wireless debugging] > [Pair device with QR code]'),
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                children: [
                  QrImageView(
                    data: 'WIFI:T:ADB;S:ADB_WIFI_$id;P:scrcpygui;',
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  if (loading)
                    SizedBox.expand(
                      child: Container(
                        color: Colors.grey.withAlpha(200),
                        child: const Center(
                          child: ProgressRing(),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class PairDialog extends ConsumerStatefulWidget {
  final BonsoirService service;
  const PairDialog({super.key, required this.service});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PairDialogState();
}

class _PairDialogState extends ConsumerState<PairDialog> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Pairing'),
      content: loading
          ? const Center(child: ProgressRing())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Text('Attempting to pair with ${widget.service.name}'),
                const Text('\nInstruction:'),
                const Text(
                    'Go to [Developer options] > [Wireless debugging] > [Pair device with pairing code]'),
                const SizedBox(height: 10),
                TextBox(
                  placeholder: 'Insert code and press [Enter]',
                  onSubmitted: (value) async {
                    loading = true;
                    setState(() {});
                    await AdbUtils.pairWithCode(
                        widget.service.name, value.trim(), ref);

                    await AdbUtils.connectWithMdns(
                      ref,
                      id: widget.service.name,
                      from: 'pair dialog',
                    );

                    loading = false;
                    setState(() {});
                  },
                ),
              ],
            ),
      actions: [
        Button(child: const Text('Cancel'), onPressed: () {}),
      ],
    );
  }
}
