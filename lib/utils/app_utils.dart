// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:window_manager/window_manager.dart';

import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/utils/tray_utils.dart';

import '../providers/adb_provider.dart';
import '../providers/scrcpy_provider.dart';
import '../widgets/navigation_shell.dart';
import '../widgets/quit_dialog.dart';
import 'const.dart';

class AppUtils {
  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    return info.version;
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
    String pidof = 'Unknown';

    if (Platform.isLinux || Platform.isMacOS) {
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
    final wifi = ref.read(adbProvider).where((d) => isWireless(d.id));
    final instance = ref.read(scrcpyInstanceProvider);
    final settings = ref.read(settingsProvider);

    if (wifi.isNotEmpty || instance.isNotEmpty) {
      showDialog(
        // barrierColor: Colors.black.withValues(alpha: 0.9),
        context: context,
        builder: (context) => const Center(child: QuitDialog()),
      );
    } else {
      if (settings.behaviour.rememberWinSize) {
        final size = await windowManager.getSize();
        await Db.saveWinSize(size);
      }

      final trackDevicesPID = ref.read(adbTrackDevicesPID);

      if (trackDevicesPID != null) {
        Process.killPid(trackDevicesPID);
      }

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
      await windowManager.unmaximize();
    }
    if (!isMaximized) {
      await windowManager.maximize();
    }
  }

  static Future<String> getLatestAppVersion() async {
    try {
      final res = await Dio().get(
          'https://api.github.com/repos/pizi-0/flutter-scrcpygui/releases');

      return res.data.first['tag_name'];
    } on DioException catch (_) {
      rethrow;
    }
  }

  static double findSidebarWidth() {
    final box = sidebarKey.currentContext?.findRenderObject();

    if (box != null) {
      return (box as RenderBox).size.width;
    } else {
      return 0;
    }
  }
}

bool isWireless(String id) {
  return id.contains(':') || id.contains(adbMdns) || id.isIpv4;
}
