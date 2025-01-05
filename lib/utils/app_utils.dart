import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/adb_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../widgets/quit_dialog.dart';
import 'const.dart';

class AppUtils {
  static Future<void> push(BuildContext context, Widget page) async {
    await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => page));
  }

  static Future<Color> getPrimaryColor() async {
    File file = File('/home/pizi/.cache/wal/colors.css');
    Color color = Colors.blue;

    if (file.existsSync()) {
      await file.readAsString().then(
        (value) {
          var c = value.split('--color11:').last.split(';').first;

          color = HexColor.fromHex(c.trim());
        },
      );
    }

    return color;
  }

  static Future<String> getAppPid() async {
    String pidof;
    pidof = (await Process.run('pgrep', ['scrcpygui'])).stdout;

    return pidof;
  }

  static Future<void> saveAppSettings(AppSettings appSettings) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_APP_SETTINGS, appSettings.toJson());
  }

  static Future<AppSettings> getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsons = prefs.getString(PKEY_APP_SETTINGS);

    if (jsons == null) {
      return defaultSettings;
    } else {
      return AppSettings.fromJson(jsons);
    }
  }

  static Future<void> onAppCloseRequested(
      WidgetRef ref, BuildContext context) async {
    final wifi = ref
        .read(adbProvider)
        .where((d) => d.id.contains(adbMdns) || d.id.isIpv4);
    final instance = ref.read(scrcpyInstanceProvider);

    if (wifi.isNotEmpty || instance.isNotEmpty) {
      showAdaptiveDialog(
        barrierColor: Colors.black.withValues(alpha: 0.9),
        context: context,
        builder: (context) => const QuitDialog(),
      );
    } else {
      await windowManager.setPreventClose(false);
      windowManager.destroy();
    }
  }

  static Future<void> clearSharedPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(key);
  }

  static openFolder(String p) async {
    Uri folder = Uri.file(p);
    await launchUrl(folder);
  }
}
