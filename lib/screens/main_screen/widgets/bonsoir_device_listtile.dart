import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/adb_provider.dart';
import '../../../utils/adb/adb_utils.dart';

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
