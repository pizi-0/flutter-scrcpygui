import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/version_provider.dart';

import '../utils/adb/adb_utils.dart';
import 'adb_provider.dart';

final shouldPollAdb = StateProvider<bool>((ref) => true);

final pollAdbProvider = StateProvider<void>((ref) async {
  while (ref.watch(shouldPollAdb)) {
    await Future.delayed(500.milliseconds);
    final workDir = ref.read(execDirProvider);

    AdbUtils.connectedDevices(workDir, showLog: false).then((newAdb) {
      final saved = ref.read(savedAdbDevicesProvider);

      ref.read(adbProvider.notifier).setConnected(newAdb, saved);

      if (ref.read(selectedDeviceProvider) != null &&
          newAdb
              .where((n) => n.id == ref.read(selectedDeviceProvider)!.id)
              .isEmpty &&
          newAdb.isNotEmpty) {
        ref.read(selectedDeviceProvider.notifier).state = null;
      }

      if (newAdb.isEmpty) {
        ref.read(selectedDeviceProvider.notifier).state = null;
      }
    });
    await Future.delayed(500.milliseconds);
  }
});
