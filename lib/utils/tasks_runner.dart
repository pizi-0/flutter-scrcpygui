import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/tasks/task_type.dart';
import 'package:scrcpygui/models/tasks/task_type_ids.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/const.dart';

import '../models/tasks/task_model.dart';
import 'scrcpy_utils.dart';

class TasksRunner {
  static Future<void> runTask(WidgetRef ref, {required Tasks tasks}) async {
    for (final task in tasks.tasks) {
      switch (task.id) {
        //
        case TaskId.startScrcpy:
          final t = task as StartScrcpyTask;
          final allConfigs = ref.read(configsProvider);
          final connectedDevices = ref.read(adbProvider);

          final config =
              allConfigs.firstWhereOrNull((c) => c.id == t.configId) ??
                  defaultMirror;

          final device = connectedDevices
                  .where((c) => c.serialNo == t.serialNo)
                  .firstWhereOrNull((c) {
                if (t.preferWireless ?? false) {
                  return isWireless(c.id);
                } else {
                  return !isWireless(c.id);
                }
              }) ??
              connectedDevices.firstOrNull;

          if (device != null) {
            await ScrcpyUtils.newInstance(ref,
                selectedConfig: config, selectedDevice: device);
          }

          break;
        //
        case TaskId.stopScrcpy:
          final t = task as StopScrcpyTask;
          final connectedDevices = ref.read(adbProvider);

          final device =
              connectedDevices.firstWhereOrNull((d) => d.id == t.deviceId);

          final runningInstances = ref.read(scrcpyInstanceProvider);

          if (device != null) {
            final toKill = runningInstances
                .lastWhereOrNull((inst) => inst.device.id == device.id);

            if (toKill != null) {
              await ScrcpyUtils.killServer(toKill);
            }
          } else {
            if (runningInstances.isNotEmpty) {
              await ScrcpyUtils.killServer(runningInstances.last);
            }
          }

          break;
        //
        // case TaskId.connectWireless:
        //   final t = task as ConnectWirelessTask;
        //   break;
        // //
        // case TaskId.disconnectWireless:
        //   final t = task as DisconnectWirelessTask;
        //   break;
        // //
        // case TaskId.runAdbCommand:
        //   final t = task as RunAdbCommandTask;
        //   break;
        // //
        default:
          throw Exception('Unknown TaskType: $task');
      }
    }
  }
}
