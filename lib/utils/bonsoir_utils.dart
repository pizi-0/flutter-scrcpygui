import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BonsoirUtils {
  static Future<void> startDiscovery(
      BonsoirDiscovery discovery, WidgetRef ref) async {
    try {
      if (discovery.isReady) {
        await discovery.start();

        discovery.eventStream!.listen((event) async {
          if (event.service?.type ==
              BonsoirDiscoveryServiceFoundEvent.discoveryServiceFound) {
            // await discovery.serviceResolver.resolveService(event.service!);
            ref.read(bonsoirDeviceProvider.notifier).addService(event.service!);
          } else if (event.service?.type ==
              BonsoirDiscoveryServiceResolvedEvent.discoveryServiceResolved) {
          } else if (event.service?.type ==
              BonsoirDiscoveryServiceLostEvent.discoveryServiceLost) {
            ref
                .read(bonsoirDeviceProvider.notifier)
                .removeService(event.service!);
          }
        });
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<Stream<BonsoirDiscoveryEvent>?> startPairDiscovery(
      BonsoirDiscovery discovery, WidgetRef ref) async {
    try {
      if (discovery.isReady) {
        await discovery.start();

        return discovery.eventStream!;
      } else {
        await discovery.initialize();
        await discovery.start();

        return discovery.eventStream!;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
