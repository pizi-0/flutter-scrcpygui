import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:string_extensions/string_extensions.dart';

import '../utils/adb_utils.dart';
import 'adb_provider.dart';

final shouldPollAdb = StateProvider<bool>((ref) => true);

final pollAdbProvider = StateProvider<void>((ref) async {
  while (ref.watch(shouldPollAdb)) {
    await Future.delayed(500.milliseconds);
    final workDir = ref.read(execDirProvider);

    try {
      final newAdb = await AdbUtils.connectedDevices(workDir, showLog: false);
      final saved = ref.read(savedAdbDevicesProvider);
      final currentAdb = ref.read(adbProvider);
      final newSaved = newAdb
          .map((d) => saved.firstWhere((e) => e.id == d.id, orElse: () => d));

      if (newAdb.length < currentAdb.length) {
        final disconnected = currentAdb
            .where((d) => !newSaved.contains(d))
            .map((e) =>
                '${e.id.isIpv4 || e.id.contains(adbMdns) ? '(WIFI)' : '(USB)'}-${e.name ?? e.id}')
            .toList();

        logger.i('Device disconnected $disconnected');
      }

      if (newAdb.length > currentAdb.length) {
        final disconnected = newSaved
            .where((d) => !currentAdb.contains(d))
            .map((e) =>
                '${e.id.isIpv4 || e.id.contains(adbMdns) ? '(WIFI)' : '(USB)'}-${e.name ?? e.id}')
            .toList();

        logger.i('Device connected $disconnected');
      }

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
    } on Exception catch (e) {
      logger.e('Adb polling failed', error: e);
      ref.read(shouldPollAdb.notifier).state = false;
    }
    await Future.delayed(500.milliseconds);
  }
});
