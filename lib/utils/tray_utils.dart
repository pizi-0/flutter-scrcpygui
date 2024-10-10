import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:tray_manager/tray_manager.dart';

import '../providers/adb_provider.dart';
import '../providers/config_provider.dart';
import 'scrcpy_utils.dart';

class TrayUtils {
  static const String _trayIcon = 'assets/logo.png';

  static Future<void> initTray(WidgetRef ref) async {
    final connected = ref.read(adbProvider);
    final saved = ref.read(savedAdbDevicesProvider);
    final configs = ref.read(configsProvider);

    await trayManager.setIcon(_trayIcon);
    if (!Platform.isLinux) await trayManager.setToolTip('Scrcpy GUI');

    final menu = Menu(
      items: connected.map((d) {
        final device = saved.firstWhere((s) => s.id == d.id, orElse: () => d);
        return MenuItem.submenu(
            key: d.id,
            label: device.name ?? device.id,
            sublabel: 'Config',
            submenu: Menu(
              items: configs
                  .where((c) => c != newConfig)
                  .map((c) => MenuItem(
                        key: c.configName,
                        label: c.configName,
                        onClick: (menuItem) async {
                          ref.read(selectedDeviceProvider.notifier).state =
                              device;
                          ref.read(selectedConfigProvider.notifier).state = c;
                          await ScrcpyUtils.newInstance(ref);
                        },
                      ))
                  .toList(),
            ));
      }).toList(),
    );

    await trayManager.setContextMenu(menu);
  }
}
