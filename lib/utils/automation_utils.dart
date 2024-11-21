import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:string_extensions/string_extensions.dart';

class AutomationUtils {
  static autoconnectRunner(WidgetRef ref) async {
    final connected = ref.read(adbProvider);
    final task = ref
        .read(savedAdbDevicesProvider)
        .where((e) =>
            e.id.isIpv4 &&
            e.automationData != null &&
            e.automationData!.actions
                .where((a) => a.type == ActionType.autoconnect)
                .isNotEmpty)
        .toList();
    for (final t in task) {
      final ping = Ping(t.id.split(':').first);

      final res = (await ping.stream.first).error;

      if (res == null) {
        if (!connected.contains(t)) {
          await AdbUtils.connectWifiDebugging(ip: t.id);
        }
      }
      // else {
      //   if (connected.contains(t)) {
      //     await AdbUtils.disconnectWirelessDevice(t);
      //     ref.read(adbProvider.notifier).removeDevice(t);
      //   }
      // }
    }
  }

  static autoLaunchConfigRunner(WidgetRef ref) async {
    final connected = ref.read(adbProvider);

    final task = ref
        .read(savedAdbDevicesProvider)
        .where((auto) =>
            auto.automationData?.actions
                .where((act) => act.type == ActionType.launchConfig)
                .isNotEmpty ??
            false)
        .toList();

    for (final t in task) {
      if (connected.where((d) => d.id == t.id).isNotEmpty) {
        final running = ref.read(scrcpyInstanceProvider);

        if (running.where((inst) => inst.device == t).isEmpty) {
          final configIdtoLaunch = t.automationData!.actions
              .firstWhere((act) => act.type == ActionType.launchConfig)
              .action;

          final config = ref
              .read(configsProvider)
              .firstWhere((conf) => conf.id == configIdtoLaunch);

          await ScrcpyUtils.newInstance(ref, t, config);
        }
      }
    }
  }

  static setAutoConnect(WidgetRef ref, AdbDevices device) {
    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(device);
  }
}
