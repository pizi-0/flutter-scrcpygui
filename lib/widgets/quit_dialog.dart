import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart'
    show AlignExtensions;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_button.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:window_manager/window_manager.dart';

import '../db/db.dart';
import '../providers/poll_provider.dart';
import '../providers/settings_provider.dart';
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
      constraints: const BoxConstraints(maxWidth: sectionWidth),
      child: IntrinsicHeight(
        child: loading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 20),
                    Text(el.statusLoc.closing),
                  ],
                ),
              )
            : AlertDialog(
                title: Text(el.quitDialogLoc.title),
                content: ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: sectionWidth, maxWidth: sectionWidth),
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
                            title: el.quitDialogLoc.killRunning.label,
                            showSubtitle: true,
                            subtitle: el.quitDialogLoc.killRunning
                                .info(count: '${runningInstance.length}'),
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
                            title: el.quitDialogLoc.disconnect.label,
                            subtitle: el.quitDialogLoc.disconnect
                                .info(count: '${wifiDevices.length}'),
                            showSubtitle: true,
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
                      child: Text(el.buttonLabelLoc.selectAll),
                    ),
                  const Spacer(),
                  PgDestructiveButton(
                    onPressed: () {
                      _onClose(wifi, instance);
                    },
                    child: Text(el.buttonLabelLoc.quit),
                  ),
                  SecondaryButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: Text(el.buttonLabelLoc.cancel),
                  )
                ],
              ),
      ),
    );
  }

  Future<void> _onClose(bool wifi, bool instance) async {
    await windowManager.setPreventClose(true);
    setState(() {
      loading = true;
    });
    final connectedDevices = ref.read(adbProvider);
    var runningInstances = ref.read(scrcpyInstanceProvider);
    final workDir = ref.read(execDirProvider);
    final settings = ref.read(settingsProvider);

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
        ScrcpyUtils.killStrays(strays, ProcessSignal.sigterm);
      }
    }

    if (wifi) {
      for (final d in connectedDevices
          .where((e) => e.id.contains(adbMdns) || e.id.isIpv4)) {
        await AdbUtils.disconnectWirelessDevice(workDir, d);
      }
    }

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
