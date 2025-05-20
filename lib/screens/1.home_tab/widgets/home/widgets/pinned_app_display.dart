import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/app_config_pair.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/app_config_pair_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/scrcpy_utils.dart';

class PinnedAppDisplay extends ConsumerWidget {
  final AdbDevices device;
  const PinnedAppDisplay({super.key, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfigPairs =
        ref.watch(appConfigPairProvider.select((pair) => pair.where((p) => p.deviceId == device.id)));

    return GridView.builder(
      shrinkWrap: true,
      itemCount: appConfigPairs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 2, mainAxisSpacing: 2, crossAxisCount: 3, childAspectRatio: 16 / 4.2),
      itemBuilder: (context, index) {
        final pair = appConfigPairs.toList()[index];

        return PinnedAppChip(pair: pair);
      },
    );
  }
}

class PinnedAppChip extends ConsumerStatefulWidget {
  final AppConfigPair pair;
  const PinnedAppChip({super.key, required this.pair});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinnedAppChipState();
}

class _PinnedAppChipState extends ConsumerState<PinnedAppChip> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);
    final connected = ref.watch(adbProvider);

    final config = allConfigs.firstWhereOrNull((c) => c.id == widget.pair.config.id);
    final device = connected.firstWhereOrNull((conn) => conn.id == widget.pair.deviceId);

    final noConfig = config == null;

    return Tooltip(
      tooltip: TooltipContainer(
              child: noConfig
                  ? Text('Missing config: ${widget.pair.config.configName}')
                  : Text('On: ${config.configName}'))
          .call,
      child: SizedBox(
        width: 119.1,
        child: Chip(
          style: noConfig ? ButtonStyle.destructive() : ButtonStyle.secondary(),
          onPressed: loading || noConfig ? null : () => _start(config, device!),
          trailing: ChipButton(
            onPressed: () {
              ref.read(appConfigPairProvider.notifier).removePair(widget.pair);
              Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
            },
            child: loading ? CircularProgressIndicator(size: 15) : Icon(Icons.close),
          ),
          child: OverflowMarquee(duration: 3.seconds, delayDuration: 0.5.seconds, child: Text(widget.pair.app.name)),
        ),
      ),
    );
  }

  _start(ScrcpyConfig config, AdbDevices device) async {
    loading = true;
    setState(() {});
    await ScrcpyUtils.newInstance(
      ref,
      selectedConfig: config.copyWith(appOptions: (config.appOptions).copyWith(selectedApp: widget.pair.app)),
      selectedDevice: device,
      customInstanceName: '${widget.pair.app.name} (${config.configName})',
    );

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }
}
