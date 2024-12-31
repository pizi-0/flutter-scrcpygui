import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupUtils {
  static final String _appPath = Platform.resolvedExecutable;

  static String get appDir =>
      _appPath.substring(0, _appPath.lastIndexOf(Platform.pathSeparator));

  static List<FileSystemEntity> get getLinuxExec =>
      Directory("$appDir/data/flutter_assets/assets/exec/linux").listSync();

  static initScrcpy(WidgetRef ref) async {
    final scrcpyVersion = await _getCurrentScrcpyVersion();
    final supportDir = await getApplicationSupportDirectory();
    final separator = Platform.pathSeparator;
    final execDir = Directory('${supportDir.path}${separator}exec');

    final execPath = Platform.isLinux
        ? getLinuxExec
        : Platform.isMacOS
            ? getLinuxExec
            : getLinuxExec;

    final versionDir = Directory(
        '${supportDir.path}${separator}exec$separator$BUNDLED_VERSION');

    if (!execDir.existsSync()) {
      await execDir.create();
      await versionDir.create();

      for (final f in execPath) {
        final byte = File(f.path).readAsBytesSync();
        final filename = f.path.split(separator).last;
        await File('${versionDir.path}$separator$filename').writeAsBytes(byte);
      }

      if (Platform.isLinux || Platform.isMacOS) {
        await Process.run('bash', ['-c', 'chmod +x adb'],
            workingDirectory: versionDir.path);

        await Process.run('bash', ['-c', 'chmod +x scrcpy_bin'],
            workingDirectory: versionDir.path);

        await Process.run('bash', ['-c', 'chmod +x scrcpy'],
            workingDirectory: versionDir.path);
      }

      await _saveCurrentScrcpyVersion(BUNDLED_VERSION);
    }
    logger.i('Using scrcpy version $scrcpyVersion');
    ref.read(scrcpyVersionProvider.notifier).state = scrcpyVersion;

    ref.read(execDirProvider.notifier).state = versionDir.path;
  }

  static Future<void> _saveCurrentScrcpyVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PKEY_SCRCPYVERSION, version);
  }

  static Future<String> _getCurrentScrcpyVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PKEY_SCRCPYVERSION) ?? '';
  }

  // ignore: unused_element
  static Future<String> _getLatestScrcpyVersion() async {
    try {
      final res = await Dio().get(scrcpyLatestUrl);
      return res.data['tag_name'];
    } catch (e) {
      return '-';
    }
  }
}
