import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/home_small.dart';

import '../../../providers/adb_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/const.dart';
import 'device_listtile.dart';

class ConnectedDevicesView extends ConsumerWidget {
  const ConnectedDevicesView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final looks = ref.watch(settingsProvider).looks;
    final theme = Theme.of(context);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final devices = ref.watch(adbProvider);
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);
    final attention = ref.watch(homeDeviceAttention);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attention && selectedDevice == null
                  ? 'Pick a device!'
                  : 'Connected devices (${devices.length})')
              .textStyle(theme.textTheme.bodyLarge),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(looks.widgetRadius),
            child: Material(
              child: AnimatedContainer(
                duration: 200.milliseconds,
                width: appWidth,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    border: Border.all(
                        width: 4,
                        color: attention && selectedDevice == null
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.primaryContainer),
                    borderRadius: BorderRadius.circular(looks.widgetRadius)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(looks.widgetRadius * 0.4),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        AdbDevices dev = devices[index];

                        if (bonsoirDevices
                            .where((b) => dev.id.contains(b.name))
                            .isNotEmpty) {
                          final bd = bonsoirDevices
                              .firstWhere((f) => dev.id.contains(f.name));

                          dev = dev.copyWith(
                              ip: '${bd.toJson()['service.host']}:${bd.port}');
                        }

                        return DeviceListtile(
                            key: ValueKey(dev.id), device: dev);
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                          color: theme.colorScheme.primaryContainer,
                        );
                      },
                      itemCount: devices.length,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
