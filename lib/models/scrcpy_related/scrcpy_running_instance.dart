import 'dart:io';

import 'package:pg_scrcpy/models/adb_devices.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config.dart';

class ScrcpyRunningInstance {
  final AdbDevices device;
  final ScrcpyConfig config;
  final String scrcpyPID;
  final Process process;
  final String instanceName;
  final DateTime startTime;

  ScrcpyRunningInstance({
    required this.instanceName,
    required this.process,
    required this.device,
    required this.config,
    required this.scrcpyPID,
    required this.startTime,
  });
}
