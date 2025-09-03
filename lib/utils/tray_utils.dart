// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide MenuItem;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/adb_provider.dart';
import '../providers/config_provider.dart';
import 'scrcpy_utils.dart';

class TrayUtils {
  static String _trayIcon() {
    if (Platform.isWindows) {
      return 'assets/logo.ico';
    } else if (Platform.isLinux) {
      if (isFlatpak) {
        return 'io.github.pizi_0.flutter-scrcpygui';
      }
      return 'assets/logo.png';
    } else {
      return 'assets/logo.png';
    }
  }

  static Future<void> initTray(WidgetRef ref, BuildContext context) async {
    final behaviour = ref.read(settingsProvider.select((s) => s.behaviour));

    if (behaviour.traySupport) {
      await trayManager.setIcon(_trayIcon());
      if (!Platform.isLinux) {
        await trayManager.setToolTip('Scrcpy GUI');
      }

      final menu = await TrayUtils.trayMenu(ref, context);

      await trayManager.setContextMenu(menu);
    }
  }

  static Future<Menu> trayMenu(WidgetRef ref, BuildContext context) async {
    final connected = ref.read(adbProvider);
    final configs = ref.read(configsProvider);
    final running = ref.read(scrcpyInstanceProvider);
    final info = ref.read(infoProvider);

    bool windowVisible = await windowManager.isVisible();

    return Menu(
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
        ...connected.map((device) {
          final deviceInfo =
              info.firstWhereOrNull((info) => info.serialNo == device.serialNo);

          return MenuItem.submenu(
            key: device.id,
            label: isWireless(device.id)
                ? '[WiFi] ${deviceInfo?.deviceName.toUpperCase() ?? device.id}'
                : '[USB] ${deviceInfo?.deviceName.toUpperCase() ?? device.id}',
            sublabel: 'Config',
            submenu: Menu(
              items: configs
                  .where((c) => c.id != newConfig.id)
                  .map((c) => MenuItem(
                        key: c.configName,
                        label: c.configName,
                        onClick: (menuItem) async {
                          final hasApp = c.appOptions.selectedApp != null;

                          await ScrcpyUtils.newInstance(
                            ref,
                            selectedDevice: device,
                            selectedConfig: c,
                            customInstanceName: hasApp
                                ? '${c.appOptions.selectedApp!.name} (${c.configName})'
                                : '',
                          );
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
                          await ScrcpyUtils.killServer(r);
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
  }
}
