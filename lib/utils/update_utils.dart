import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:string_extensions/string_extensions.dart';

import 'const.dart';

final downloadPercentageProvider = StateProvider<double>((ref) => 0);
final updateStatusProvider = StateProvider((ref) => '');

class UpdateUtils {
  static Future<String?> checkForScrcpyUpdate() async {
    String? latest;

    logger.i('Checking for scrcpy update...');

    try {
      final res = await Dio().get(scrcpyLatestUrl);

      String version = res.data['tag_name'];
      latest = version.removeLetters;
    } catch (e) {
      logger.e('Error checking for scrcpy update', error: e);
    }

    logger.i('Latest scrcpy version: $latest');

    return latest;
  }

  static Future downloadLatest(WidgetRef ref, Dio dio) async {
    final cache = (await getApplicationCacheDirectory()).path;

    final sep = Platform.pathSeparator;
    final downloadPath = Directory('$cache${sep}download');

    try {
      ref.read(downloadPercentageProvider.notifier).state = 0;
      if (!await downloadPath.exists()) {
        await downloadPath.create();
      }

      ref.read(updateStatusProvider.notifier).state = 'Getting version number';
      final version = await checkForScrcpyUpdate();
      ref.read(updateStatusProvider.notifier).state =
          'Latest version: v$version';

      ref.read(updateStatusProvider.notifier).state =
          'Downloading scrcpy v$version';

      await dio.download(
        'https://github.com/Genymobile/scrcpy/releases/download/v$version/scrcpy-linux-x86_64-v$version.tar.gz',
        '${downloadPath.path}/v$version.tar.gz',
        onReceiveProgress: (count, total) => ref
            .read(downloadPercentageProvider.notifier)
            .state = ((count / total) * 100),
      );

      ref.read(updateStatusProvider.notifier).state = 'Download complete';

      await untar(ref, '${downloadPath.path}/v$version.tar.gz', version!);

      // ref.read(downloadPercentageProvider.notifier).state = 0;
    } catch (e) {
      ref.read(updateStatusProvider.notifier).state = 'Download failed';

      debugPrint(e.toString());
    }
  }

  static Future untar(WidgetRef ref, String filepath, String version) async {
    final sep = Platform.pathSeparator;
    final supportDir = (await getApplicationSupportDirectory()).path;
    final newExecDir = Directory('$supportDir${sep}exec');
    final newVersionDir = Directory('${newExecDir.path}$sep$version');

    if (await newVersionDir.exists()) {
      await newVersionDir.delete(recursive: true);
    }

    await extractFileToDisk(filepath, newExecDir.path);

    final entities = newExecDir.listSync();

    await entities.last.rename(newVersionDir.path);

    if (Platform.isLinux || Platform.isMacOS) {
      await Process.run('bash', ['-c', 'chmod +x adb'],
          workingDirectory: newVersionDir.path);

      await Process.run('bash', ['-c', 'chmod +x scrcpy'],
          workingDirectory: newVersionDir.path);
    }

    await SetupUtils.saveCurrentScrcpyVersion(version);

    ref.read(execDirProvider.notifier).state = newVersionDir.path;
    ref.read(scrcpyVersionProvider.notifier).state = version;
    ref.read(updateStatusProvider.notifier).state = 'Update complete';
  }
}
