import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';

import '../providers/settings_provider.dart';
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
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    TextStyle? style = Theme.of(context).textTheme.titleSmall;
    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.8))));
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
                  child: CircularProgressIndicator.adaptive(),
                ),
                SizedBox(height: 20),
                Material(child: Text('Closing')),
              ],
            ),
          )
        : AlertDialog(
            backgroundColor: colorScheme.surface,
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(appTheme.widgetRadius),
            ),
            title: Text(
                'Disconnect ${device.name?.toUpperCase() ?? device.modelName.toUpperCase()}?'),
            content: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (runningInstance.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius:
                            BorderRadius.circular(appTheme.widgetRadius * 0.8),
                      ),
                      margin: const EdgeInsets.all(4),
                      child: ListTile(
                        title: Text(
                          '${device.name?.toUpperCase() ?? device.modelName.toUpperCase()} has ${runningInstance.length} running server(s)',
                          style: style,
                        ),
                        subtitle: const Text(
                          'Disconnecting will kill the server(s)',
                        ),
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
                  TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    autofocus: true,
                    style: buttonStyle,
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('No'),
                  ),
                ],
              )
            ],
          );
  }
}
