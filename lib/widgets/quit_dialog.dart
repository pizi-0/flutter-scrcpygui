import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/settings_provider.dart';
import '../providers/version_provider.dart';
import '../utils/adb/adb_utils.dart';
import '../utils/const.dart';
import '../utils/scrcpy_utils.dart';

class QuitDialog extends ConsumerStatefulWidget {
  const QuitDialog({super.key});

  @override
  ConsumerState<QuitDialog> createState() => _QuitDialogState();
}

class _QuitDialogState extends ConsumerState<QuitDialog> {
  bool wifi = false;
  bool instance = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.titleSmall;
    final colorScheme = Theme.of(context).colorScheme;
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final wifiDevices =
        ref.watch(adbProvider).where((e) => e.id.contains(':')).toList();
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    final noWin = runningInstance
        .where((ins) => ins.config.windowOptions.noWindow)
        .toList();

    return loading
        ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator.adaptive(),
                ),
                SizedBox(height: 20),
                Material(child: Text('Closing')),
              ],
            ),
          )
        : AlertDialog(
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(appTheme.widgetRadius),
            ),
            title: const Text('Quit?'),
            content: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (noWin.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '*Servers with no window will be killed regardless. (${noWin.length})',
                        style: style,
                      )
                          .italic()
                          .fontSize(11)
                          .textColor(colorScheme.inverseSurface),
                    ),
                  if (noWin.isNotEmpty) const SizedBox(height: 5),
                  if (runningInstance.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(appTheme.widgetRadius * 0.8),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            instance = !instance;
                          });
                        },
                        trailing: Checkbox(
                            value: instance,
                            onChanged: (v) {
                              setState(() {
                                instance = !instance;
                              });
                            }),
                        title: Text(
                          'Kill running servers?',
                          style: style,
                        ).textColor(colorScheme.inverseSurface),
                        subtitle: Text(
                          '${runningInstance.length} server(s)',
                        ).textColor(
                            colorScheme.inverseSurface.withOpacity(0.8)),
                      ),
                    ),
                  if (wifiDevices.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(appTheme.widgetRadius * 0.8),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            wifi = !wifi;
                          });
                        },
                        trailing: Checkbox(
                            value: wifi,
                            onChanged: (v) {
                              setState(() {
                                wifi = !wifi;
                              });
                            }),
                        title: Text(
                          'Disconnect Wireless ADB?',
                          style: style,
                        ).textColor(colorScheme.inverseSurface),
                        subtitle: Text(
                          '${wifiDevices.length} device(s)',
                        ).textColor(
                            colorScheme.inverseSurface.withOpacity(0.8)),
                      ),
                    )
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (runningInstance.isNotEmpty && wifiDevices.isNotEmpty)
                    Checkbox(
                      tristate: true,
                      value: wifi && instance
                          ? true
                          : wifi
                              ? null
                              : instance
                                  ? null
                                  : false,
                      onChanged: (v) {
                        if (wifi && instance) {
                          wifi = false;
                          instance = false;
                        } else {
                          wifi = true;
                          instance = true;
                        }

                        setState(() {});
                      },
                    ),
                  if (runningInstance.isNotEmpty && wifiDevices.isNotEmpty)
                    InkWell(
                        onTap: () {
                          if (wifi && instance) {
                            wifi = false;
                            instance = false;
                          } else {
                            wifi = true;
                            instance = true;
                          }

                          setState(() {});
                        },
                        child: const Text('Select all')),
                  const Spacer(),
                  TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      _onClose(wifi, instance);
                    },
                    child: const Text('Quit')
                        .textColor(colorScheme.inverseSurface),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    autofocus: true,
                    style: buttonStyle,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel')
                        .textColor(colorScheme.inverseSurface),
                  ),
                ],
              )
            ],
          );
  }

  _onClose(bool wifi, bool instance) async {
    setState(() {
      loading = true;
    });
    final connectedDevices = ref.read(adbProvider);
    final runningInstances = ref.read(scrcpyInstanceProvider);
    final appPID = ref.read(appPidProvider);
    final workDir = ref.read(execDirProvider);

    for (final i
        in runningInstances.where((ins) => ins.config.windowOptions.noWindow)) {
      ScrcpyUtils.killServer(i, appPID).then((a) {
        ref.read(scrcpyInstanceProvider.notifier).removeInstance(i);
      });
    }

    if (instance) {
      for (final i in runningInstances) {
        ScrcpyUtils.killServer(i, appPID).then((a) {
          ref.read(scrcpyInstanceProvider.notifier).removeInstance(i);
        });
      }

      final strays = await AdbUtils.getScrcpyServerPIDs();
      if (strays.isNotEmpty) {
        ScrcpyUtils.killStrays(strays, ProcessSignal.sigterm);
      }
    }

    if (wifi) {
      for (final d in connectedDevices.where((e) => e.id.contains(':'))) {
        await AdbUtils.disconnectWirelessDevice(workDir, d);
      }
    }
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }
}
