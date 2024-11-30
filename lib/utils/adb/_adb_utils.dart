import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:scrcpygui/models/adb_devices.dart';

import '../const.dart';

Future<List<AdbDevices>> getAdbInfos(String workDir,
    {required List<String> connected}) async {
  List<AdbDevices> devices = [];
  for (var e in connected) {
    String? serialNo;
    String? modelName;

    final d = e.split('	').toList();
    final id = d[0];
    final status = d[1].trim() != 'offline' && d[1].trim() != 'unauthorized';

    try {
      if (status) {
        ProcessResult modelNameRes = await Process.run(
                eadb, ['-s', id, 'shell', 'getprop', 'ro.product.model'],
                workingDirectory: workDir)
            .timeout(2.seconds,
                onTimeout: () =>
                    ProcessResult(pid, 124, 'timed-out', 'timed-out'));

        modelName = modelNameRes.stdout.toString().trim();
      }

      if (id.contains(':')) {
        //get serial no if status != offline or unauth
        if (status) {
          final serialNoRes = await Process.run(
                  eadb, ['-s', id, 'shell', 'getprop', 'ro.boot.serialno'],
                  workingDirectory: workDir)
              .timeout(2.seconds,
                  onTimeout: () =>
                      ProcessResult(pid, exitCode, '', 'timed-out'));

          serialNo = serialNoRes.stdout.toString().trim();
        }
      } else {
        serialNo = id;
      }

      devices.add(
        AdbDevices(
          id: id,
          modelName: modelName ?? '',
          status: status,
          serialNo: serialNo ?? '',
        ),
      );
    } on Exception catch (e) {
      logger.e('Error getting info for $id from adb', error: e);
    }
  }

  return devices;
}
