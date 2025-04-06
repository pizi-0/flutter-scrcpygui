// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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

  static String get macAppDir {
    final macos =
        appDir.substring(0, _appPath.lastIndexOf(Platform.pathSeparator));

    final contents =
        macos.substring(0, macos.lastIndexOf(Platform.pathSeparator));
    return contents;
  }

  static List<FileSystemEntity> get getLinuxExec =>
      Directory("$appDir/data/flutter_assets/assets/exec/linux").listSync();

  static List<FileSystemEntity> get getWindowsExec =>
      Directory("$appDir\\data\\flutter_assets\\assets\\exec\\windows")
          .listSync();

  static List<FileSystemEntity> get getIntelMacExec => Directory(
          "$macAppDir/Frameworks/App.framework/Versions/A/Resources/flutter_assets/assets/exec/mac-intel")
      .listSync();

  static List<FileSystemEntity> get getAppleMacExec => Directory(
          "$macAppDir/Frameworks/App.framework/Versions/A/Resources/flutter_assets/assets/exec/mac-apple")
      .listSync();

  static initScrcpy(WidgetRef ref) async {
    try {
      String scrcpyVersion = await getCurrentScrcpyVersion();

      final execDir = await DirectoryUtils.getExecDir();

      final bundledVersionDir =
          await DirectoryUtils.getScrcpyVersionDir(BUNDLED_VERSION);

      if (!bundledVersionDir.existsSync()) {
        await _setupBundledScrcpy();
      }

      if (scrcpyVersion == BUNDLED_VERSION) {
        logger.i('Using bundled scrcpy version $scrcpyVersion');

        ref.read(scrcpyVersionProvider.notifier).state = scrcpyVersion;
        ref.read(execDirProvider.notifier).state = bundledVersionDir.path;
      } else {
        logger.i('Using scrcpy version $scrcpyVersion');
        ref.read(scrcpyVersionProvider.notifier).state = scrcpyVersion;

        final newexec = execDir
            .listSync()
            .firstWhere((f) => f.path.endsWith(scrcpyVersion), orElse: () {
          logger.e(
              'Unable to locate scrcpy version $scrcpyVersion, reverting to bundled version ($BUNDLED_VERSION)');

          ref.read(scrcpyVersionProvider.notifier).state = BUNDLED_VERSION;

          SharedPreferences.getInstance().then(
            (value) => value.remove(PKEY_SCRCPYVERSION),
          );

          return bundledVersionDir;
        });

        if (newexec.path.endsWith(BUNDLED_VERSION)) {
          await initScrcpy(ref);
        } else {
          ref.read(execDirProvider.notifier).state = newexec.path;
        }
      }
      await saveCurrentScrcpyVersion(ref.read(scrcpyVersionProvider));
    } on Exception catch (e) {
      logger.e('Init scrcpy error', error: e);
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
    final bundledVersionDir = await DirectoryUtils.getScrcpyVersionDir(
        BUNDLED_VERSION,
        createIfNot: true);
    final bundledDirContent = bundledVersionDir.listSync();

    final execPath = await _getExecPath();

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
      await Process.run('chmod', ['+x', 'adb'], workingDirectory: path);

      await Process.run('chmod', ['+x', 'scrcpy'], workingDirectory: path);
    }
  }

  static Future<List<FileSystemEntity>> _getExecPath() async {
    final devInfo = await DeviceInfoPlugin().deviceInfo;
    final arch = devInfo.data['arch'];

    if (Platform.isLinux) {
      return getLinuxExec;
    } else if (Platform.isMacOS) {
      if (arch == 'x86_64') {
        return getIntelMacExec;
      }
      return getAppleMacExec;
    } else if (Platform.isWindows) {
      return getWindowsExec;
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
