import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupUtils {
  static final String _appPath = Platform.resolvedExecutable;

  static String get appDir =>
      _appPath.substring(0, _appPath.lastIndexOf(Platform.pathSeparator));

  static List<FileSystemEntity> get getLinuxExec =>
      Directory("$appDir/data/flutter_assets/assets/exec/linux").listSync();

  static initScrcpy(WidgetRef ref) async {
    final scrcpyVersion = await getCurrentScrcpyVersion();

    final execDir = await DirectoryUtils.getExecDir();

    final bundledVersionDir = await DirectoryUtils.getScrcpyVersionDir(
        BUNDLED_VERSION,
        createIfNot: true);

    if (scrcpyVersion == BUNDLED_VERSION) {
      await _setupBundledScrcpy();
      await saveCurrentScrcpyVersion(BUNDLED_VERSION);

      logger.i('Using bundled scrcpy version $scrcpyVersion');

      ref.read(scrcpyVersionProvider.notifier).state = scrcpyVersion;
      ref.read(execDirProvider.notifier).state = bundledVersionDir.path;
    } else {
      logger.i('Using scrcpy version $scrcpyVersion');
      ref.read(scrcpyVersionProvider.notifier).state = scrcpyVersion;

      final newexec =
          execDir.listSync().firstWhere((f) => f.path.endsWith(scrcpyVersion));

      ref.read(execDirProvider.notifier).state = newexec.path;
    }
  }

  static Future<void> saveCurrentScrcpyVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PKEY_SCRCPYVERSION, version);
  }

  static Future<String> getCurrentScrcpyVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(PKEY_SCRCPYVERSION) ?? BUNDLED_VERSION;
  }

  static Future<void> _setupBundledScrcpy() async {
    final bundledVersionDir =
        await DirectoryUtils.getScrcpyVersionDir(BUNDLED_VERSION);
    final bundledDirContent = bundledVersionDir.listSync();

    final execPath = Platform.isLinux
        ? getLinuxExec
        : Platform.isMacOS
            ? getLinuxExec
            : getLinuxExec;

    for (final f in execPath) {
      final filename = f.path.split(Platform.pathSeparator).last;

      if (bundledDirContent.where((c) => c.path.endsWith(filename)).isEmpty) {
        final byte = File(f.path).readAsBytesSync();

        await File(
                '${bundledVersionDir.path}${Platform.pathSeparator}$filename')
            .writeAsBytes(byte);
      }
    }

    _markAsExecutable(bundledVersionDir.path);
  }

  static Future<void> _markAsExecutable(String path) async {
    if (Platform.isLinux || Platform.isMacOS) {
      await Process.run('bash', ['-c', 'chmod +x adb'], workingDirectory: path);

      await Process.run('bash', ['-c', 'chmod +x scrcpy'],
          workingDirectory: path);
    }
  }
}
