import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/automation_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

class AutomationUtils {
  static Future<void> autoconnectRunner(WidgetRef ref) async {
    final connected = ref.read(adbProvider);
    final workDir = ref.read(execDirProvider);
    final task = ref.read(autoConnectProvider);

    for (final t in task) {
      if (connected.where((d) => d.id == t.deviceIp).isEmpty) {
        AdbUtils.connectWithIp(workDir, ipport: t.deviceIp);
      }
    }
  }

  static Future<void> autoLaunchConfigRunner(WidgetRef ref) async {
    final connected = ref.read(adbProvider);
    final allConfigs = ref.read(configsProvider);

    final task = ref.read(autoLaunchProvider);

    for (final t in task) {
      final running = ref.read(scrcpyInstanceProvider);
      if (connected.where((d) => d.id == t.deviceId).isNotEmpty) {
        if (running.where((inst) => inst.device.id == t.deviceId).isEmpty) {
          final configToLaunch =
              allConfigs.firstWhereOrNull((c) => c.id == t.configId);

          final device = connected.firstWhereOrNull((d) => d.id == t.deviceId);

          if (configToLaunch == null || device == null) {
            continue;
          }

          final hasApp = configToLaunch.appOptions.selectedApp != null;

          ScrcpyUtils.newInstance(
            ref,
            selectedDevice: device,
            selectedConfig: configToLaunch,
            customInstanceName: hasApp
                ? '${configToLaunch.appOptions.selectedApp!.name} (${configToLaunch.configName})'
                : '',
          );
        }
      }
    }
  }
}
