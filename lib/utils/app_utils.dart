import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/app_theme.dart';
import 'package:scrcpygui/providers/theme_provider.dart';
import 'package:scrcpygui/providers/toast_providers.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/utils/prefs_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/adb_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../widgets/quit_dialog.dart';

class AppUtils {
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

  static Future<void> saveAppTheme(AppTheme apptheme) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_APPTHEME, apptheme.toJson());
  }

  static Future<AppTheme> getAppTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final jsons = prefs.getString(PKEY_APPTHEME);

    if (jsons == null) {
      return defaultTheme;
    } else {
      return AppTheme.fromJson(jsons);
    }
  }

  static Future<void> saveNotiPreference(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(PKEY_NOTI, ref.read(toastEnabledProvider));
  }

  static Future<bool> getNotiPreference() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(PKEY_NOTI) ?? true;
  }

  static Future<void> onAppCloseRequested(
      WidgetRef ref, BuildContext context) async {
    final wifi = ref.read(adbProvider).where((d) => d.id.contains(':'));
    final instance = ref.read(scrcpyInstanceProvider);

    if (wifi.isNotEmpty || instance.isNotEmpty) {
      showAdaptiveDialog(
        barrierColor: Colors.black.withOpacity(0.9),
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
}
