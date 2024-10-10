import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/adb_utils.dart';
import 'adb_provider.dart';

final shouldPollAdb = StateProvider<bool>((ref) => true);

final pollAdbProvider = StateProvider<void>((ref) async {
  while (ref.watch(shouldPollAdb)) {
    await Future.delayed(500.milliseconds);
    AdbUtils.connectedDevices(showLog: false).then((newAdb) {
      if (ref.read(shouldPollAdb)) {
        ref.read(adbProvider.notifier).setConnected(newAdb);
      }
      if (ref.read(selectedDeviceProvider) != null &&
          !newAdb.contains(ref.read(selectedDeviceProvider)) &&
          newAdb.isNotEmpty) {
        ref.read(selectedDeviceProvider.notifier).state = newAdb.first;
      }

      if (newAdb.isEmpty) {
        ref.read(selectedDeviceProvider.notifier).state = null;
      }
    });
    await Future.delayed(500.milliseconds);
  }
});
