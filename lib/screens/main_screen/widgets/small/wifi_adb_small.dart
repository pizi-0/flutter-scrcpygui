import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/bonsoir_devices.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/bonsoir_utils.dart';

import '../../../../utils/const.dart';

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
                      decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          border: Border.all(
                              width: 4,
                              color: theme.colorScheme.primaryContainer),
                          borderRadius:
                              BorderRadius.circular(looks.widgetRadius)),
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

class BonsoirDeviceTile extends ConsumerStatefulWidget {
  final BonsoirService bonsoirDevice;

  const BonsoirDeviceTile({super.key, required this.bonsoirDevice});

  @override
  ConsumerState<BonsoirDeviceTile> createState() => _BonsoirDeviceTileState();
}

class _BonsoirDeviceTileState extends ConsumerState<BonsoirDeviceTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final connectedDevices = ref.watch(adbProvider);
    final connected = connectedDevices
        .where((e) => e.id.contains(widget.bonsoirDevice.name))
        .isNotEmpty;

    return ListTile(
      dense: true,
      enabled: !loading,
      trailing: connected
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_circle,
                color: Colors.lightGreen,
              ),
            )
          : loading
              ? const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CupertinoActivityIndicator(),
                )
              : IconButton(
                  tooltip: 'Connect',
                  onPressed: () async {
                    loading = true;
                    setState(() {});

                    final start = DateTime.now().millisecondsSinceEpoch;
                    final result = await AdbUtils.connectWithMdns(ref,
                        id: widget.bonsoirDevice.name);
                    final end = DateTime.now().millisecondsSinceEpoch;

                    //purely visual
                    if ((end - start) < 1500) {
                      await Future.delayed((1500 - (end - start)).milliseconds);
                    }

                    loading = false;
                    setState(() {});

                    if (!result.success) {
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Connection failed'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Error:\n${result.errorMessage.capitalize}'),
                              const Text(
                                  'Try:\nTurn Wireless ADB off and on, and retry'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.link_rounded),
                ),
      title: Text(widget.bonsoirDevice.name),
      subtitle: Text(
          '${widget.bonsoirDevice.toJson()['service.host']}:${widget.bonsoirDevice.port}'),
    );
  }
}
