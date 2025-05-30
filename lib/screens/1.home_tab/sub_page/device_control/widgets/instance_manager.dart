import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_running_instance.dart';
import '../../../../../providers/scrcpy_provider.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_list_tile.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';

class DeviceRunningInstances extends ConsumerStatefulWidget {
  final AdbDevices device;
  const DeviceRunningInstances({required this.device, super.key});

  @override
  ConsumerState<DeviceRunningInstances> createState() =>
      _DeviceRunningInstancesState();
}

class _DeviceRunningInstancesState
    extends ConsumerState<DeviceRunningInstances> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceInstance = ref
        .watch(scrcpyInstanceProvider)
        .where((i) => i.device == widget.device)
        .toList();

    return PgSectionCardNoScroll(
        label:
            el.loungeLoc.running.label(count: deviceInstance.length.toString()),
        labelTrail: deviceInstance.isNotEmpty
            ? Button(
                style: ButtonStyle.ghost(density: ButtonDensity.dense),
                leading: Icon(
                  Icons.stop_rounded,
                  color: theme.colorScheme.destructive,
                ),
                onPressed: loading
                    ? null
                    : () async {
                        loading = true;
                        setState(() {});
                        try {
                          List<Future> future = [];
                          for (final instance in deviceInstance) {
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
                child: Text(el.buttonLabelLoc.stopAll).textSmall,
              )
            : null,
        expandContent: true,
        content: Stack(
          children: [
            CustomScrollView(
              slivers: [
                if (deviceInstance.isEmpty) ...[
                  SliverFillRemaining(
                    child: Center(
                      child:
                          Text(el.loungeLoc.info.emptyInstance).textSmall.muted,
                    ),
                  )
                ] else ...[
                  SliverList.separated(
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(),
                    ),
                    itemCount: deviceInstance.length,
                    itemBuilder: (context, index) {
                      final instance = deviceInstance[index];

                      return InstanceListTile(instance: instance);
                    },
                  )
                ],
              ],
            ),
            if (loading)
              Container(
                color: theme.colorScheme.background.withAlpha(200),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ));
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
    final name = widget.instance.instanceName.split(']').last;

    return PgListTile(
      title: name,
      trailing: IconButton.ghost(
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
          icon: Icon(
            Icons.stop_rounded,
            color: Theme.of(context).colorScheme.destructive,
          )),
    );
  }
}
