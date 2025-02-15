// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/adb/adb_utils.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  children: [
                    QrImageView(
                      data: 'WIFI:T:ADB;S:ADB_WIFI_$id;P:${id.removeSpecial};',
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
          id.removeSpecial,
          ref);

      Navigator.pop(context, pairRes.contains('Successfully paired to'));
    } else {
      debugPrint('scan is null');
      if (mounted) {
        Navigator.pop(context, false);
      }
    }
  }
}
