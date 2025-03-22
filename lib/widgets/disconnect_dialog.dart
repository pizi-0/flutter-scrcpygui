import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';

import '../utils/const.dart';

class DisconnectDialog extends ConsumerStatefulWidget {
  final AdbDevices device;
  const DisconnectDialog({super.key, required this.device});

  @override
  ConsumerState<DisconnectDialog> createState() => _DisconnectDialogState();
}

class _DisconnectDialogState extends ConsumerState<DisconnectDialog> {
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
    final runningInstance = ref
        .watch(scrcpyInstanceProvider)
        .where((inst) => inst.device == widget.device);

    final device = ref.watch(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == widget.device.id,
        orElse: () => widget.device);

    return loading
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
                Text('Closing')
              ],
            ),
          )
        : AlertDialog(
            title: Text(
              el.disconnectDialogLoc.title(
                  name: device.name?.toUpperCase() ??
                      device.modelName.toUpperCase()),
            ),
            content: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (runningInstance.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16),
                      child: PgListTile(
                        title: el.disconnectDialogLoc.hasRunning.label(
                            name: device.name?.toUpperCase() ??
                                device.modelName.toUpperCase(),
                            count: '${runningInstance.length}'),
                        subtitle: el.disconnectDialogLoc.hasRunning.info,
                        showSubtitle: true,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FButton(
                    style: FButtonStyle.destructive,
                    onPress: () {
                      context.pop(true);
                    },
                    label: Text(el.commonLoc.yes),
                  ),
                  const SizedBox(width: 10),
                  FButton(
                    style: FButtonStyle.secondary,
                    onPress: () {
                      context.pop(false);
                    },
                    label: Text(el.commonLoc.no),
                  ),
                ],
              )
            ],
          );
  }
}
