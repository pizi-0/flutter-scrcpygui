import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

import '../models/adb_devices.dart';

class CommandRunner {
  static String _getExecutablePath(String workDir, String executableName) {
    if (Platform.isWindows) {
      return p.join(workDir, '$executableName.exe');
    } else if (Platform.isLinux || Platform.isMacOS) {
      return p.join(workDir, executableName);
    } else {
      throw UnsupportedError(
          'Unsupported platform: ${Platform.operatingSystem}');
    }
  }

  static Future<ProcessResult> runAdbCommand(String workDir,
      {List<String> args = const []}) async {
    final adbPath = _getExecutablePath(workDir, 'adb');

    return Process.run(adbPath, args,
        stdoutEncoding: Utf8Codec(),
        stderrEncoding: Utf8Codec(),
        workingDirectory: workDir);
  }

  static Future<Process> startAdbCommand(String workDir,
      {List<String> args = const []}) async {
    final adbPath = _getExecutablePath(workDir, 'adb');
    return Process.start(adbPath, args, workingDirectory: workDir);
  }

  static Future<ProcessResult> runAdbShellCommand(
      String workDir, AdbDevices device,
      {List<String> args = const []}) async {
    return CommandRunner.runAdbCommand(workDir,
        args: ['-s', device.id, 'shell', ...args]);
  }

  static Future<ProcessResult> runScrcpyCommand(
      String workDir, AdbDevices device,
      {List<String> args = const []}) async {
    final scrcpyPath = _getExecutablePath(workDir, 'scrcpy');
    return Process.run(scrcpyPath, ['-s', device.id, ...args],
        stdoutEncoding: Utf8Codec(),
        stderrEncoding: Utf8Codec(),
        workingDirectory: workDir);
  }

  static Future<Process> startScrcpyCommand(String workDir, AdbDevices device,
      {List<String> args = const []}) async {
    final scrcpyPath = _getExecutablePath(workDir, 'scrcpy');
    return Process.start(scrcpyPath, ['-s', device.id, ...args],
        workingDirectory: workDir);
  }
}
