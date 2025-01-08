import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/bonsoir_utils.dart';
import 'package:scrcpygui/utils/decorations.dart';

import '../../../../utils/const.dart';
import '../bonsoir_device_listtile.dart';

class WifiAdbSmall extends ConsumerStatefulWidget {
  const WifiAdbSmall({super.key});

  @override
  ConsumerState<WifiAdbSmall> createState() => _WifiAdbSmallState();
}

class _WifiAdbSmallState extends ConsumerState<WifiAdbSmall> {
  late BonsoirDiscovery discovery;

  @override
  void initState() {
    discovery = BonsoirDiscovery(type: adbMdns);
    BonsoirUtils.startDiscovery(discovery, ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final looks = ref.watch(settingsProvider).looks;
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: appWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Wireless ADB found (${bonsoirDevices.length})')
                        .textStyle(theme.textTheme.bodyLarge),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(),
                  )
                ],
              ),
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(looks.widgetRadius),
                  child: Material(
                    child: Container(
                      width: appWidth,
                      clipBehavior: Clip.hardEdge,
                      decoration: Decorations.secondaryContainer(
                          theme.colorScheme, looks),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 8),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(looks.widgetRadius * 0.4),
                          child: Center(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final bonsoirDevice = bonsoirDevices[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer
                                        .withValues(alpha: 0.5),
                                  ),
                                  child: BonsoirDeviceTile(
                                      bonsoirDevice: bonsoirDevice),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                  color: theme.colorScheme.primaryContainer),
                              itemCount: bonsoirDevices.length,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
