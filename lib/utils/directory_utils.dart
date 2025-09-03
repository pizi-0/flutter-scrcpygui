import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:url_launcher/url_launcher.dart';

String? defaultSavePath;

class DirectoryUtils {
  static var sep = Platform.pathSeparator;

  static Future<Directory> getExecDir() async {
    final supportDir = await getApplicationSupportDirectory();

    final dir = Directory('${supportDir.path}${sep}exec');

    if (!dir.existsSync()) {
      await dir.create();
    }

    return dir;
  }

  static Future<Directory> getScrcpyVersionDir(String version,
      {bool createIfNot = false}) async {
    final execDir = await getExecDir();
    final dir = Directory('${execDir.path}$sep$version');

    if (createIfNot && !dir.existsSync()) {
      await dir.create();
    }

    return Directory('${execDir.path}$sep$version');
  }

  static Future<Directory> getDownloadDir() async {
    final cacheDir = await getApplicationCacheDirectory();
    final dir = Directory('${cacheDir.path}${sep}download');

    if (!dir.existsSync()) {
      await dir.create();
    }

    return dir;
  }

  static Future<void> openFolder(String p) async {
    Uri folder = Uri.file(p, windows: Platform.isWindows);

    await launchUrl(folder);
  }

  static Future<String> getDefaultSavePath() async {
    if (Platform.isLinux) {
      final dir = await getApplicationDocumentsDirectory();

      if (isFlatpak) {
        return dir.path;
      }

      return Platform.environment['HOME']!;
    } else if (Platform.isMacOS) {
      return Platform.environment['HOME']!;
    } else {
      return '${Platform.environment['USERPROFILE']}';
    }
  }
}
