import 'dart:io';

import '../models/adb_devices.dart';

class CommandRunner {
  static Future<ProcessResult> runAdbCommand(String workDir,
      {List<String> args = const []}) async {
    try {
      if (Platform.isWindows) {
        return await Process.run('$workDir\\adb.exe', args,
            workingDirectory: workDir);
      } else if (Platform.isLinux || Platform.isMacOS) {
        return await Process.run('$workDir/adb', args,
            workingDirectory: workDir);
      } else {
        throw Exception('Unsupported platform');
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Future<Process> startAdbCommand(String workDir,
      {List<String> args = const []}) async {
    try {
      if (Platform.isWindows) {
        final res = await Process.start('$workDir\\adb.exe', args,
            workingDirectory: workDir);
        return res;
      } else if (Platform.isLinux || Platform.isMacOS) {
        final res = await Process.start('$workDir/adb', args,
            workingDirectory: workDir);

        return res;
      } else {
        throw Exception('Unsupported platform');
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  static Future<ProcessResult> runAdbShellCommand(
      String workDir, AdbDevices device,
      {List<String> args = const []}) async {
    return await CommandRunner.runAdbCommand(workDir,
        args: ['-s', device.id, 'shell', ...args]);
  }

  static Future<ProcessResult> runScrcpyCommand(
      String workDir, AdbDevices device,
      {List<String> args = const []}) async {
    if (Platform.isWindows) {
      final res = await Process.run(
          '$workDir\\scrcpy.exe', ['-s', device.id, ...args],
          workingDirectory: workDir);
      return res;
    } else if (Platform.isLinux || Platform.isMacOS) {
      final res = await Process.run(
          '$workDir/scrcpy', ['-s', device.id, ...args],
          workingDirectory: workDir);
      return res;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  static Future<Process> startScrcpyCommand(String workDir, AdbDevices device,
      {List<String> args = const []}) async {
    if (Platform.isWindows) {
      final res = await Process.start(
          '$workDir\\scrcpy.exe', ['-s', device.id, ...args],
          workingDirectory: workDir);
      return res;
    } else if (Platform.isLinux || Platform.isMacOS) {
      final res = await Process.start(
          '$workDir/scrcpy', ['-s', device.id, ...args],
          workingDirectory: workDir);

      return res;
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
