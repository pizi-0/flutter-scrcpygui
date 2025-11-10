// ignore_for_file: use_build_context_synchronously

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/adb_utils.dart';
import '../../../utils/bonsoir_utils.dart';

class WifiQrPairing extends ConsumerStatefulWidget {
  const WifiQrPairing({super.key});

  @override
  ConsumerState<WifiQrPairing> createState() => _WifiQrPairingState();
}

class _WifiQrPairingState extends ConsumerState<WifiQrPairing> {
  late BonsoirDiscovery discovery;
  final String id = const Uuid().v1();
  bool loading = false;
  late Stream<BonsoirDiscoveryEvent>? stream;

  @override
  void initState() {
    super.initState();
    try {
      discovery = BonsoirDiscovery(type: adbPairMdns);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      stream = (await BonsoirUtils.startPairDiscovery(discovery, ref));

      if (stream != null) {
        await _pair(stream!);
      }
    });
  }

  @override
  void dispose() {
    discovery.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: sectionWidth),
      child: AlertDialog(
        title: Text(el.connectLoc.qrPair.pair),
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
                        data:
                            'WIFI:T:ADB;S:ADB_WIFI_$id;P:${id.removeSpecial};',
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      if (loading)
                        SizedBox.expand(
                          child: Container(
                            color: Colors.neutral.withAlpha(200),
                            child: const Center(
                              child: CircularProgressIndicator(),
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
          SecondaryButton(
            child: Text(el.buttonLabelLoc.close),
            onPressed: () => context.pop(),
          )
        ],
      ),
    );
  }

Future<void> _pair(Stream<BonsoirDiscoveryEvent> stream) async {
  late String pairRes;
  
  final foundEvent = await stream.firstWhere(
    (e) => e is BonsoirDiscoveryServiceFoundEvent,
    orElse: () => BonsoirDiscoveryUnknownEvent(),
  );
  
  if (foundEvent is BonsoirDiscoveryServiceFoundEvent) {
    foundEvent.service.resolve(discovery.serviceResolver);
    
    // Now wait for the resolved event
    final toPair = await stream.firstWhere(
      (e) {
        if (e is BonsoirDiscoveryServiceResolvedEvent) {
          return e.service.name == foundEvent.service.name && 
                 e.service.port > 0 && 
                 e.service.host != null;
        }
        return false;
      },
      orElse: () => BonsoirDiscoveryUnknownEvent(),
    );
    
    if (toPair is BonsoirDiscoveryServiceResolvedEvent) {
      if (mounted) {
        loading = true;
        setState(() {});
      }
      
      pairRes = await AdbUtils.pairWithCode(
        toPair.service.name, id.removeSpecial, ref);
        context.pop(pairRes.contains('Successfully paired to'));
    } else {
      if (mounted) {
        context.pop();
      }
    }
  } else {
    if (mounted) {
      context.pop();
    }
  }
}
}
