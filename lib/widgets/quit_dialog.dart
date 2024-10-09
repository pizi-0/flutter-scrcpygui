import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/providers/adb_provider.dart';
import 'package:pg_scrcpy/providers/scrcpy_provider.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/adb_utils.dart';
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
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final wifiDevices = ref.watch(adbProvider).where((e) => e.id.contains(':'));
    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))));

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
              borderRadius: BorderRadius.circular(10),
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
                        '*Servers with no window will be killed regardless. (${noWin.length} servers)',
                        style: style,
                      ).italic().fontSize(11),
                    ),
                  if (runningInstance.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        trailing: Checkbox(
                            value: instance,
                            onChanged: (v) {
                              setState(() {
                                instance = v!;
                              });
                            }),
                        title: Text(
                          'Kill running servers?',
                          style: style,
                        ),
                        subtitle: Text(
                          '${runningInstance.length} server(s)',
                        ),
                      ),
                    ),
                  if (wifiDevices.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        trailing: Checkbox(
                            value: wifi,
                            onChanged: (v) {
                              setState(() {
                                wifi = v!;
                              });
                            }),
                        title: Text(
                          'Disconnect Wireless ADB?',
                          style: style,
                        ),
                        subtitle: Text(
                          '${wifiDevices.length} device(s)',
                        ),
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
                  TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      _onClose(wifi, instance);
                    },
                    child: const Text('Yes'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    autofocus: true,
                    style: buttonStyle,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
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
        await AdbUtils.disconnectWirelessDevice(d);
      }
    }
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }
}
