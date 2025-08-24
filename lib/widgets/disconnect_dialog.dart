import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_button.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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

    final info = ref
        .read(infoProvider)
        .firstWhereOrNull((i) => i.serialNo == widget.device.serialNo);

    final device = widget.device;

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
                  name: info?.deviceName.toUpperCase() ??
                      device.modelName.toUpperCase()),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: sectionWidth, maxWidth: sectionWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('ID: ${widget.device.id}'),
                  if (runningInstance.isNotEmpty)
                    OutlinedContainer(
                      padding: EdgeInsets.all(16),
                      child: PgListTile(
                        title: el.disconnectDialogLoc.hasRunning.label(
                            name: info?.deviceName.toUpperCase() ??
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
                  PgDestructiveButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: Text(el.commonLoc.yes),
                  ),
                  const SizedBox(width: 10),
                  Button.secondary(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: Text(el.commonLoc.no),
                  ),
                ],
              )
            ],
          );
  }
}
