import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:string_extensions/string_extensions.dart';

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

  static Future<void> startPairingDiscovery(
      BonsoirDiscovery discovery, WidgetRef ref) async {
    await discovery.ready;
    await discovery.start();

    discovery.eventStream!.listen((event) async {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        print(event.service);
        await discovery.serviceResolver.resolveService(event.service!);
        ref.read(pairingDeviceProvider.notifier).addService(event.service!);
      } else if (event.type ==
          BonsoirDiscoveryEventType.discoveryServiceResolved) {
        ref.read(pairingDeviceProvider.notifier).addService(event.service!);
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        ref.read(pairingDeviceProvider.notifier).removeService(event.service!);
      }
    });
  }

  static Future<void> scan() async {
    MDnsClient client = MDnsClient();

    print('starting');
    await client.start();

    await for (final ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_adb-tls-pairing._tcp'),
        timeout: 20.seconds)) {
      print(ptr.domainName);
      await for (final ip in client.lookup<IPAddressResourceRecord>(
          ResourceRecordQuery.addressIPv4(ptr.domainName))) {
        print(ip.address);
      }
    }

    client.stop();

    // client.stop();
  }
}
