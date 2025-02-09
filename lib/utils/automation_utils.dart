import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:string_extensions/string_extensions.dart';

class AutomationUtils {
  static autoconnectRunner(WidgetRef ref) async {
    final connected = ref.read(adbProvider);
    final bonsoirDevices = ref.read(bonsoirDeviceProvider);
    final task = ref
        .read(savedAdbDevicesProvider)
        .where((e) =>
            (e.id.isIpv4 || e.id.contains(adbMdns)) &&
            e.automationData != null &&
            e.automationData!.actions
                .where((a) => a.type == ActionType.autoconnect)
                .isNotEmpty)
        .toList();

    for (final t in task) {
      if (t.id.contains(adbMdns)) {
        if (bonsoirDevices.where((bd) => t.id.contains(bd.name)).isNotEmpty) {
          if (!connected.contains(t)) {
            AdbUtils.connectWithMdns(ref, id: t.id);
          }
        }
      }

      if (t.id.isIpv4 || t.id.isIpv6) {
        if (!connected.contains(t)) {
          AdbUtils.connectWithIp(ref, ipport: t.id);
        }
      }
    }
  }

  static Future<void> autoLaunchConfigRunner(WidgetRef ref) async {
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
      final running = ref.read(scrcpyInstanceProvider);
      if (connected.where((d) => d.id == t.id).isNotEmpty) {
        if (running.where((inst) => inst.device.id == t.id).isEmpty) {
          final configIdtoLaunch = t.automationData!.actions
              .firstWhere((act) => act.type == ActionType.launchConfig)
              .action;

          final config = ref
              .read(configsProvider)
              .firstWhere((conf) => conf.id == configIdtoLaunch);

          ScrcpyUtils.newInstance(ref,
              selectedDevice: t, selectedConfig: config);
        }
      }
    }
  }

  static setAutoConnect(WidgetRef ref, AdbDevices device) {
    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(device);
  }
}
