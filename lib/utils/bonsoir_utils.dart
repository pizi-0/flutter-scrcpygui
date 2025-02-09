import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';

class BonsoirUtils {
  static Future<void> startDiscovery(
      BonsoirDiscovery discovery, WidgetRef ref) async {
    await discovery.ready;
    await discovery.start();

    discovery.eventStream!.listen((event) async {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        await discovery.serviceResolver.resolveService(event.service!);
      } else if (event.type ==
          BonsoirDiscoveryEventType.discoveryServiceResolved) {
        ref.read(bonsoirDeviceProvider.notifier).addService(event.service!);
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        ref.read(bonsoirDeviceProvider.notifier).removeService(event.service!);
      }
    });
  }
}
