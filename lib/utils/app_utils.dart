// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:window_manager/window_manager.dart';

import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/utils/tray_utils.dart';

import '../providers/adb_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../widgets/quit_dialog.dart';
import 'const.dart';

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
    String pidof = 'Unknown';

    if (Platform.isLinux) {
      pidof = (await Process.run('pgrep', ['scrcpygui'])).stdout;
    }

    if (Platform.isWindows) {
      String tasklist = (await Process.run('tasklist', [])).stdout;

      pidof = tasklist
          .splitLines()
          .firstWhere((e) => e.contains('scrcpygui.exe'))
          .trimAll
          .split(' ')[1]
          .trim();
    }

    return pidof;
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
      await windowManager.isPreventClose();
      await windowManager.setPreventClose(false);
      await windowManager.destroy();
      exit(0);
    }
  }

  static Future<void> onAppMinimizeRequested(
      WidgetRef ref, BuildContext context) async {
    final behaviour = ref.read(settingsProvider).behaviour;

    switch (behaviour.minimizeAction) {
      case MinimizeAction.toTaskBar:
        await windowManager.minimize();
      case MinimizeAction.toTray:
        await windowManager.hide();
        await TrayUtils.initTray(ref, context);
    }
  }

  static Future<void> onAppMaximizeRequested() async {
    bool isMaximized = await windowManager.isMaximized();

    if (isMaximized) {
      await windowManager.restore();
    }
    if (!isMaximized) {
      await windowManager.maximize();
    }
  }
}
