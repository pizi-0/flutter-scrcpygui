import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:scrcpygui/utils/const.dart';

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

  static Future<Directory> _getIconsDirectory() async {
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
      final iconsDir = await _getIconsDirectory();
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
        final iconsDir = await _getIconsDirectory();
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
