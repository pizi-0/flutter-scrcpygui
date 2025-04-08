// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:scrcpygui/utils/extension.dart';
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
        ref.read(scrcpyVersionProvider.notifier).state = scrcpyVersion;
        ref.read(execDirProvider.notifier).state = bundledVersionDir.path;
      } else {
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
    final version = prefs.getString(PKEY_SCRCPYVERSION) ?? BUNDLED_VERSION;

    logger.i(
        'Using scrcpy version $version${version.parseVersionToInt() == BUNDLED_VERSION.parseVersionToInt() ? ' (bundled)' : ''}');

    return version;
  }

  static Future<void> _setupBundledScrcpy() async {
    try {
      final bundledVersionDir = await DirectoryUtils.getScrcpyVersionDir(
          BUNDLED_VERSION,
          createIfNot: true);
      final bundledDirContent = bundledVersionDir.listSync();

      final execPath = await _getExecPath();

      logger.i('Setting up scrcpy. Copying scrcpy...');

      logger.i(
          'From: ${execPath.first.path.substring(0, execPath.first.path.lastIndexOf(Platform.pathSeparator))}');

      logger.i('To: ${bundledVersionDir.path}');

      for (final (i, f) in execPath.indexed) {
        final filename = f.path.split(Platform.pathSeparator).last;

        if (bundledDirContent.where((c) => c.path.endsWith(filename)).isEmpty) {
          logger.i('$i. $filename');
          final byte = File(f.path).readAsBytesSync();

          await File(
                  '${bundledVersionDir.path}${Platform.pathSeparator}$filename')
              .writeAsBytes(byte);
        }
      }
      logger.i('Scrcpy copied!');

      _markAsExecutable(bundledVersionDir.path);
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  static Future<void> _markAsExecutable(String path) async {
    if (Platform.isLinux || Platform.isMacOS) {
      try {
        logger.i('Marking adb as executable...');
        await Process.run('chmod', ['+x', 'adb'], workingDirectory: path);

        logger.i('Marking scrcpy as executable...');
        await Process.run('chmod', ['+x', 'scrcpy'], workingDirectory: path);
      } on Exception catch (_) {
        rethrow;
      }
    }
  }

  static Future<List<FileSystemEntity>> _getExecPath() async {
    logger.i('OS: ${Platform.operatingSystem}');

    if (Platform.isLinux) {
      final info = await DeviceInfoPlugin().linuxInfo;
      logger.i(info.prettyName);

      return getLinuxExec;
    } else if (Platform.isMacOS) {
      final info = await DeviceInfoPlugin().macOsInfo;
      final arch = info.arch;

      logger.i('Arch: $arch');

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
