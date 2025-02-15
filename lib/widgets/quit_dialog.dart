import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:window_manager/window_manager.dart';

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
    final theme = FluentTheme.of(context);

    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final wifiDevices = ref
        .watch(adbProvider)
        .where((e) => e.id.contains(adbMdns) || e.id.isIpv4)
        .toList();

    return loading
        ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: ProgressRing(),
                ),
                SizedBox(height: 20),
                Text('Closing'),
              ],
            ),
          )
        : ContentDialog(
            title: const Text('Quit Scrcpy GUI?'),
            content: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (runningInstance.isNotEmpty)
                    ListTile(
                      tileColor: WidgetStatePropertyAll(theme.cardColor),
                      onPressed: () {
                        setState(() {
                          instance = !instance;
                        });
                      },
                      trailing: Checkbox(
                          checked: instance,
                          onChanged: (v) {
                            setState(() {
                              instance = !instance;
                            });
                          }),
                      title: const Text('Kill running servers?'),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('${runningInstance.length} server(s)'),
                      ),
                    ),
                  if (wifiDevices.isNotEmpty)
                    ListTile(
                      tileColor: WidgetStatePropertyAll(theme.cardColor),
                      onPressed: () {
                        setState(() {
                          wifi = !wifi;
                        });
                      },
                      trailing: Checkbox(
                          checked: wifi,
                          onChanged: (v) {
                            setState(() {
                              wifi = !wifi;
                            });
                          }),
                      title: const Text('Disconnect Wireless ADB?'),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '${wifiDevices.length} device(s)',
                        ),
                      ),
                    )
                ],
              ),
            ),
            actions: [
              Row(
                spacing: 8,
                children: [
                  if (runningInstance.isNotEmpty && wifiDevices.isNotEmpty)
                    Button(
                      onPressed: () {
                        if (wifi && instance) {
                          wifi = false;
                          instance = false;
                        } else {
                          wifi = true;
                          instance = true;
                        }

                        setState(() {});
                      },
                      child: const Text('Select all'),
                    ),
                  const Spacer(),
                  Button(
                    onPressed: () {
                      _onClose(wifi, instance);
                    },
                    child: const Text('Quit'),
                  ),
                  Button(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  )
                ],
              ),
            ],
          );
  }

  _onClose(bool wifi, bool instance) async {
    await windowManager.setPreventClose(true);
    setState(() {
      loading = true;
    });
    final connectedDevices = ref.read(adbProvider);
    final runningInstances = ref.read(scrcpyInstanceProvider);
    final workDir = ref.read(execDirProvider);

    for (final i
        in runningInstances.where((ins) => ins.config.windowOptions.noWindow)) {
      await ScrcpyUtils.killServer(i).then((a) {
        ref.read(scrcpyInstanceProvider.notifier).removeInstance(i);
      });
    }

    if (instance) {
      for (final i in runningInstances) {
        await ScrcpyUtils.killServer(i).then((a) {
          ref.read(scrcpyInstanceProvider.notifier).removeInstance(i);
        });
      }

      final strays = await AdbUtils.getScrcpyServerPIDs();
      if (strays.isNotEmpty) {
        await ScrcpyUtils.killStrays(strays, ProcessSignal.sigterm);
      }
    }

    if (wifi) {
      for (final d in connectedDevices
          .where((e) => e.id.contains(adbMdns) || e.id.isIpv4)) {
        await AdbUtils.disconnectWirelessDevice(workDir, d);
      }
    }
    await windowManager.isPreventClose();
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
    exit(0);
  }
}
