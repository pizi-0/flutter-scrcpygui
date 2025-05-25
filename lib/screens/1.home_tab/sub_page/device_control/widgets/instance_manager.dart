import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_running_instance.dart';
import '../../../../../providers/scrcpy_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_list_tile.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../device_control_page.dart';

class DeviceRunningInstances extends ConsumerWidget {
  final AdbDevices device;
  const DeviceRunningInstances({required this.device, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInstance = ref
        .watch(scrcpyInstanceProvider)
        .where((i) => i.device == device)
        .toList();

    return PgSectionCardNoScroll(
      label: 'Running instances',
      content: PgListTile(
        title: '${deviceInstance.length} instance(s)',
        trailing: PrimaryButton(
          onPressed: () async {
            await openSheet(
              context: context,
              position: OverlayPosition.right,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InstanceList(device: device),
                );
              },
            );
            controlPageKeyboardListenerNode.requestFocus();
          },
          child: Text('Manage'),
        ),
      ),
    );
  }
}

class InstanceList extends ConsumerStatefulWidget {
  const InstanceList({super.key, required this.device});

  final AdbDevices device;

  @override
  ConsumerState<InstanceList> createState() => _InstanceListState();
}

class _InstanceListState extends ConsumerState<InstanceList> {
  @override
  Widget build(BuildContext context) {
    final deviceInstance = ref
        .watch(scrcpyInstanceProvider)
        .where((i) => i.device == widget.device)
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: appWidth * 0.8),
      child: Column(
        children: [
          if (deviceInstance.isNotEmpty) ...[
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8),
                separatorBuilder: (context, index) => Divider(),
                itemCount: deviceInstance.length,
                itemBuilder: (context, index) {
                  final instance = deviceInstance[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InstanceListTile(instance: instance),
                  );
                },
              ),
            )
          ] else ...[
            Expanded(
              child: Center(child: Text('No instances').textSmall.muted),
            )
          ],
          InstanceListBottomBar(deviceInstance: deviceInstance),
        ],
      ),
    );
  }
}

class InstanceListTile extends StatefulWidget {
  const InstanceListTile({
    super.key,
    required this.instance,
  });

  final ScrcpyRunningInstance instance;

  @override
  State<InstanceListTile> createState() => _InstanceListTileState();
}

class _InstanceListTileState extends State<InstanceListTile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return PgListTile(
      title: widget.instance.instanceName,
      trailing: IconButton.destructive(
          enabled: !loading,
          onPressed: loading
              ? null
              : () async {
                  loading = true;
                  setState(() {});
                  try {
                    await ScrcpyUtils.killServer(widget.instance);
                    await Future.delayed(300.milliseconds);
                  } catch (e) {
                    debugPrint(e.toString());
                  } finally {
                    if (mounted) {
                      loading = false;
                      setState(() {});
                    }
                  }
                },
          icon: Icon(Icons.stop_rounded)),
    );
  }
}

class InstanceListBottomBar extends StatefulWidget {
  const InstanceListBottomBar({
    super.key,
    required this.deviceInstance,
  });

  final List<ScrcpyRunningInstance> deviceInstance;

  @override
  State<InstanceListBottomBar> createState() => _InstanceListBottomBarState();
}

class _InstanceListBottomBarState extends State<InstanceListBottomBar> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 8,
        children: [
          Expanded(
            child: DestructiveButton(
              enabled: widget.deviceInstance.isNotEmpty && !loading,
              onPressed: loading
                  ? null
                  : () async {
                      loading = true;
                      setState(() {});
                      try {
                        List<Future> future = [];
                        for (final instance in widget.deviceInstance) {
                          future.add(ScrcpyUtils.killServer(instance));
                        }
                        future.add(Future.delayed(300.milliseconds));
                        await Future.wait(future);
                      } catch (e) {
                        debugPrint(e.toString());
                      } finally {
                        if (mounted) {
                          loading = false;
                          setState(() {});
                        }
                      }
                    },
              child: Text('Stop all'),
            ),
          ),
          Expanded(
            child: SecondaryButton(
              onPressed: () => closeDrawer(context),
              child: Text('Close'),
            ),
          )
        ],
      ),
    );
  }
}
