import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrcpygui/models/installed_scrcpy.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:string_extensions/string_extensions.dart';

import 'const.dart';

final downloadPercentageProvider = StateProvider<double>((ref) => 0);
final updateStatusProvider = StateProvider((ref) => '');

class UpdateUtils {
  static Future<void> startUpdateProcess(WidgetRef ref, Dio dio) async {
    try {
      final newversion = await checkForScrcpyUpdate(ref);

      await _downloadLatest(ref, dio, newversion!);
      await _untar(ref, newversion);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<InstalledScrcpy>> listInstalledScrcpy() async {
    final sep = Platform.pathSeparator;
    final supportDir = await getApplicationSupportDirectory();
    final execDir = Directory('${supportDir.path}${sep}exec');

    final installed = execDir.listSync();

    return installed
        .map((i) =>
            InstalledScrcpy(version: i.path.split(sep).last, path: i.path))
        .toList();
  }

  static Future<String?> checkForScrcpyUpdate(WidgetRef ref) async {
    String? latest;

    logger.i('Checking for scrcpy update...');

    try {
      ref.read(updateStatusProvider.notifier).state =
          'Getting new version number';
      await Future.delayed(500.milliseconds);
      final res = await Dio().get(scrcpyLatestUrl);

      String version = res.data['tag_name'];
      latest = version.removeLetters;
      logger.i('Latest available scrcpy version: $latest');
    } catch (e) {
      logger.e([e.toString(), 'URL: $scrcpyLatestUrl'],
          error: 'New version check failed');

      throw Exception(
          ['New version check failed: $e', 'URL: $scrcpyLatestUrl']);
    }

    return latest;
  }

  static Future _downloadLatest(
      WidgetRef ref, Dio dio, String newversion) async {
    final cache = (await getApplicationCacheDirectory()).path;

    final sep = Platform.pathSeparator;
    final downloadPath = Directory('$cache${sep}download');

    try {
      ref.read(downloadPercentageProvider.notifier).state = 0;

      if (!await downloadPath.exists()) {
        await downloadPath.create();
      }

      ref.read(updateStatusProvider.notifier).state =
          'Latest version: v$newversion';
      await Future.delayed(500.milliseconds);

      ref.read(updateStatusProvider.notifier).state =
          'Downloading scrcpy v$newversion';
      await Future.delayed(500.milliseconds);

      await dio.download(
        downloadLink(newversion),
        Platform.isLinux
            ? '${downloadPath.path}${sep}v$newversion.tar.gz'
            : '${downloadPath.path}${sep}v$newversion.zip',
        onReceiveProgress: (count, total) => ref
            .read(downloadPercentageProvider.notifier)
            .state = ((count / total) * 100),
      );

      ref.read(updateStatusProvider.notifier).state = 'Download complete';
      await Future.delayed(500.milliseconds);
    } catch (e) {
      logger.e([
        e.toString(),
        'URL: https://github.com/Genymobile/scrcpy/releases/download/v$newversion/scrcpy-linux-x86_64-v$newversion.tar.gz',
      ], error: 'Update download failed');

      throw Exception([
        'Download failed: $e',
        'URL: https://github.com/Genymobile/scrcpy/releases/download/v$newversion/scrcpy-linux-x86_64-v$newversion.tar.gz'
      ]);
    }
  }

  static String downloadLink(String newversion) {
    if (Platform.isWindows) {
      return 'https://github.com/Genymobile/scrcpy/releases/download/v$newversion/scrcpy-win64-v$newversion.zip';
    } else {
      return 'https://github.com/Genymobile/scrcpy/releases/download/v$newversion/scrcpy-linux-x86_64-v$newversion.tar.gz';
    }
  }

  static Future _untar(WidgetRef ref, String newversion) async {
    final cache = (await getApplicationCacheDirectory()).path;
    final supportDir = (await getApplicationSupportDirectory()).path;

    final sep = Platform.pathSeparator;

    final downloadPath = Directory('$cache${sep}download');
    final filepath = Platform.isLinux
        ? '${downloadPath.path}${sep}v$newversion.tar.gz'
        : '${downloadPath.path}${sep}v$newversion.zip';

    final newExecDir = Directory('$supportDir${sep}exec');
    final newVersionDir = Directory('${newExecDir.path}$sep$newversion');

    try {
      if (await newVersionDir.exists()) {
        await newVersionDir.delete(recursive: true);
      }
      ref.read(updateStatusProvider.notifier).state = 'Extracting archive';
      await Future.delayed(500.milliseconds);

      //extract
      await extractFileToDisk(filepath, newExecDir.path);

      final entities = newExecDir.listSync();

      await entities.last.rename(newVersionDir.path);

      //set executable
      if (Platform.isLinux || Platform.isMacOS) {
        ref.read(updateStatusProvider.notifier).state =
            'Marking as executables';
        await Future.delayed(500.milliseconds);
        await Process.run('bash', ['-c', 'chmod +x adb'],
            workingDirectory: newVersionDir.path);

        await Process.run('bash', ['-c', 'chmod +x scrcpy'],
            workingDirectory: newVersionDir.path);
      }

      ref.read(updateStatusProvider.notifier).state =
          'Setting v$newversion as default';

      await SetupUtils.saveCurrentScrcpyVersion(newversion);
      await Future.delayed(500.milliseconds);

      ref.read(execDirProvider.notifier).state = newVersionDir.path;
      ref.read(scrcpyVersionProvider.notifier).state = newversion;
      ref.read(updateStatusProvider.notifier).state = 'Update complete';
      await Future.delayed(500.milliseconds);
    } catch (e) {
      logger
          .e([e, 'File: $filepath'], error: 'Error extracting update archive');

      throw Exception(
          ['Error extracting update archive: $e', 'File: $filepath']);
    }
  }
}
