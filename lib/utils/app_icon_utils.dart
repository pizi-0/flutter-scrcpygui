import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/missing_icon_model.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/const.dart';

import '../providers/missing_icon_provider.dart';
import 'command_runner.dart';

class IconScraper {
  static String googlePlayUrl(String packageIdentifier) {
    return "https://play.google.com/store/apps/details?id=$packageIdentifier";
  }

  static Future<String?> getIconUrl(String packageIdentifier) async {
    final url = Uri.parse(googlePlayUrl(packageIdentifier));
    final iconRegex = RegExp(r'https://play-lh.googleusercontent.com[^"]*');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final res = iconRegex.firstMatch(document.body?.innerHtml ?? '');
        return res?[0];
      } else {
        logger.w(
            'Failed to fetch app details for $packageIdentifier: HTTP ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching icon URL for $packageIdentifier: $e');
      return null;
    }
  }
}

class IconDb {
  static const String _iconDirName = 'app_icons';

  static Future<Directory> getIconsDirectory() async {
    final supportDir = await getApplicationSupportDirectory();
    final iconsDir = Directory(p.join(supportDir.path, _iconDirName));
    if (!await iconsDir.exists()) {
      await iconsDir.create(recursive: true);
    }
    return iconsDir;
  }

  static String _getIconFileName(String packageIdentifier) {
    return '$packageIdentifier.png';
  }

  static Future<File?> getIconFile(String packageIdentifier) async {
    try {
      final iconsDir = await getIconsDirectory();
      final iconFile =
          File(p.join(iconsDir.path, _getIconFileName(packageIdentifier)));
      if (await iconFile.exists()) {
        return iconFile;
      }
      return null;
    } catch (e) {
      logger.e('Error accessing icon file for $packageIdentifier: $e');
      return null;
    }
  }

  static Future<bool> iconExists(String packageIdentifier) async {
    return (await getIconFile(packageIdentifier)) != null;
  }

  static Future<File?> fetchAndSaveIcon(String packageIdentifier) async {
    try {
      final String? iconUrl = await IconScraper.getIconUrl(packageIdentifier);
      if (iconUrl == null) {
        logger.i('No icon URL found for $packageIdentifier');
        return null;
      }

      final response = await http.get(Uri.parse(iconUrl));
      if (response.statusCode == 200) {
        final iconsDir = await getIconsDirectory();
        final iconFile =
            File(p.join(iconsDir.path, _getIconFileName(packageIdentifier)));
        await iconFile.writeAsBytes(response.bodyBytes);
        logger.i('Icon saved for $packageIdentifier at ${iconFile.path}');
        return iconFile;
      } else {
        logger.w(
            'Failed to download icon for $packageIdentifier from $iconUrl: HTTP ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching and saving icon for $packageIdentifier: $e');
      return null;
    }
  }
}

class IconExtractor {
  static Future<void> runner(WidgetRef ref) async {
    List<MissingIcon> toExtract = [...ref.read(iconsToExtractProvider)];
    final workDir = ref.read(execDirProvider);
    final eifaDir = ref.read(eifaDirProvider);
    final connected = ref.read(adbProvider);

    while (toExtract.isNotEmpty) {
      toExtract = [...ref.read(iconsToExtractProvider)];

      for (final missing in toExtract) {
        final device =
            connected.firstWhereOrNull((c) => c.serialNo == missing.serialNo);
        if (device == null) continue;

        for (final app in missing.apps) {
          try {
            logger.i(
                'Pulling APK for ${app.packageName} from device ${device.serialNo}');

            final apkPath = await _pullApk(workDir, device: device, app: app);

            if (apkPath == null) {
              logger.w('Failed to pull APK for ${app.packageName}');
              continue;
            }

            logger.i(
                'Extracting icon for ${app.packageName} from device ${device.serialNo}');

            final success = await _pullIcon(eifaDir: eifaDir, apkPath: apkPath);
            if (success ?? false) {
              ref
                  .read(missingIconProvider.notifier)
                  .removeMissing(device.serialNo, app);
            }

            ref.read(iconsToExtractProvider.notifier).removeApp(app);
          } catch (e) {
            logger.e(
                'Failed to extract icon for ${app.packageName} on ${device.serialNo}: $e');
            // Optionally, remove the app from the queue to prevent retrying a failing app
            ref.read(iconsToExtractProvider.notifier).removeApp(app);
          }
        }
      }
    }
  }

  static Future<String?> _pullApk(String workDir,
      {required AdbDevices device, required ScrcpyApp app}) async {
    try {
      final pullDir = await getTemporaryDirectory();

      final res =
          await CommandRunner.runAdbShellCommand(workDir, device, args: [
        'pm',
        'path',
        app.packageName,
      ]);

      final lines = res.stdout.toString().split('\n');

      String apkPath = '';

      if (lines.length > 1) {
        apkPath = lines.firstWhereOrNull((l) => l.contains('base.apk')) ??
            lines.first;
      }

      await CommandRunner.runAdbCommand(workDir, args: [
        '-s',
        device.id,
        'pull',
        apkPath.replaceFirst('package:', ''),
        p.join(pullDir.path, '${app.packageName}.apk'),
      ]);

      File apkFile = File(p.join(pullDir.path, '${app.packageName}.apk'));

      if (!apkFile.existsSync()) {
        return null;
      }

      return apkFile.path;
    } on Exception catch (e) {
      logger.e('Error pulling APK for ${app.packageName}: $e');
      return null;
    }
  }

  static Future<bool?> _pullIcon(
      {required String eifaDir, required String apkPath}) async {
    try {
      final iconDir = await IconDb.getIconsDirectory();

      final res = await CommandRunner.runEifaRun(eifaDir,
          args: [apkPath, iconDir.path]);

      logger.i('out: ${res.stdout}');
      logger.e('err: ${res.stderr}');

      return res.exitCode == 0;
    } catch (e) {
      logger.e('Error pulling icon from $apkPath: $e');
      rethrow; // Rethrow to be caught by the runner
    }
  }
}
