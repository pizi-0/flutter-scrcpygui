import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart'
    show AlignExtensions;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/version_provider.dart';
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
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final wifiDevices = ref
        .watch(adbProvider)
        .where((e) => e.id.contains(adbMdns) || e.id.isIpv4)
        .toList();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: appWidth),
      child: IntrinsicHeight(
        child: loading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 20),
                    Text('Closing'),
                  ],
                ),
              )
            : AlertDialog(
                title: const Text('Quit Scrcpy GUI?'),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: appWidth, maxWidth: appWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      if (runningInstance.isNotEmpty)
                        OutlineButton(
                          onPressed: () {
                            setState(() {
                              instance = !instance;
                            });
                          },
                          child: PgListTile(
                            trailing: Checkbox(
                                state: instance
                                    ? CheckboxState.checked
                                    : CheckboxState.unchecked,
                                onChanged: (v) {
                                  setState(() {
                                    instance = !instance;
                                  });
                                }).alignAtCenterRight(),
                            title: 'Kill running',
                            subtitle: '${runningInstance.length} server(s)',
                          ),
                        ),
                      if (runningInstance.isNotEmpty && wifiDevices.isNotEmpty)
                        const Divider(),
                      if (wifiDevices.isNotEmpty)
                        OutlineButton(
                          onPressed: () {
                            setState(() {
                              wifi = !wifi;
                            });
                          },
                          child: PgListTile(
                            trailing: Checkbox(
                                state: wifi
                                    ? CheckboxState.checked
                                    : CheckboxState.unchecked,
                                onChanged: (v) {
                                  setState(() {
                                    wifi = !wifi;
                                  });
                                }).alignAtCenterRight(),
                            title: 'Disconnect Wireless ADB?',
                            subtitle: '${wifiDevices.length} device(s)',
                          ),
                        )
                    ],
                  ),
                ),
                actions: [
                  if (runningInstance.isNotEmpty && wifiDevices.isNotEmpty)
                    SecondaryButton(
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
                  Spacer(),
                  DestructiveButton(
                    onPressed: () {
                      _onClose(wifi, instance);
                    },
                    child: const Text('Quit'),
                  ),
                  SecondaryButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('Cancel'),
                  )
                ],
              ),
      ),
    );
  }

  _onClose(bool wifi, bool instance) async {
    await windowManager.setPreventClose(true);
    setState(() {
      loading = true;
    });
    final connectedDevices = ref.read(adbProvider);
    var runningInstances = ref.read(scrcpyInstanceProvider);
    final workDir = ref.read(execDirProvider);

    for (final i
        in runningInstances.where((ins) => ins.config.windowOptions.noWindow)) {
      await ScrcpyUtils.killServer(i).then((a) {
        ref.read(scrcpyInstanceProvider.notifier).removeInstance(i);
      });
    }

    runningInstances = ref.read(scrcpyInstanceProvider);

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
