// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/adb_provider.dart';
import '../providers/config_provider.dart';
import 'scrcpy_utils.dart';

class TrayUtils {
  static const String _trayIcon = 'assets/logo.png';

  static Future<void> initTray(WidgetRef ref, BuildContext context) async {
    final connected = ref.read(adbProvider);
    final saved = ref.read(savedAdbDevicesProvider);
    final configs = ref.read(configsProvider);
    final running = ref.read(scrcpyInstanceProvider);

    bool windowVisible = await windowManager.isVisible();

    await trayManager.setIcon(_trayIcon);
    if (!Platform.isLinux) await trayManager.setToolTip('Scrcpy GUI');

    final menu = Menu(
      items: [
        if (windowVisible)
          MenuItem(
            label: 'Hide window',
            onClick: (menuItem) async {
              await windowManager.hide();
              await trayManager.destroy();
              await TrayUtils.initTray(ref, context);
            },
          ),
        if (!windowVisible)
          MenuItem(
            label: 'Show window',
            onClick: (menuItem) async {
              await windowManager.show();
              await trayManager.destroy();
              await TrayUtils.initTray(ref, context);
            },
          ),
        MenuItem.separator(),
        MenuItem(label: 'New instance:', disabled: true),
        ...connected.map((d) {
          final device = saved.firstWhere((s) => s.serialNo == d.serialNo,
              orElse: () => d);
          return MenuItem.submenu(
            key: d.id,
            label: d.id.contains(':')
                ? '${device.name ?? device.id} (WiFi)'
                : '${device.name ?? device.id} (USB)',
            sublabel: 'Config',
            submenu: Menu(
              items: configs
                  .where((c) => c != newConfig)
                  .map((c) => MenuItem(
                        key: c.configName,
                        label: c.configName,
                        onClick: (menuItem) async {
                          ref.read(selectedDeviceProvider.notifier).state = d;
                          ref.read(selectedConfigProvider.notifier).state = c;

                          await ScrcpyUtils.newInstance(ref);
                        },
                      ))
                  .toList(),
            ),
          );
        }),
        MenuItem.separator(),
        MenuItem(
            label: 'Running instances: (${running.length})', disabled: true),
        if (running.isNotEmpty)
          MenuItem.submenu(
            label: 'Kill instance',
            submenu: Menu(
              items: running
                  .map((r) => MenuItem(
                        toolTip: 'Kill instance',
                        label: r.instanceName,
                        onClick: (menuItem) async {
                          final appPID = ref.read(appPidProvider);
                          await ScrcpyUtils.killServer(r, appPID);
                          ref
                              .read(scrcpyInstanceProvider.notifier)
                              .removeInstance(r);
                        },
                      ))
                  .toList(),
            ),
          ),
        MenuItem.separator(),
        MenuItem(
          label: 'Quit',
          onClick: (menuItem) async {
            final windowVisible = await windowManager.isVisible();

            if (!windowVisible) {
              await windowManager.show();
            }

            await AppUtils.onAppCloseRequested(ref, context);
          },
        ),
      ],
    );

    await trayManager.setContextMenu(menu);
  }
}
