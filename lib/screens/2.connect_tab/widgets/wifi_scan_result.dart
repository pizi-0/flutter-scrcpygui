import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../providers/adb_provider.dart';
import '../../../providers/bonsoir_devices.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/adb_utils.dart';
import '../../../widgets/custom_ui/pg_list_tile.dart';
import '../../1.home_tab/widgets/home/widgets/connection_error_dialog.dart';

class BonsoirResults extends ConsumerStatefulWidget {
  const BonsoirResults({super.key});

  @override
  ConsumerState<BonsoirResults> createState() => _BonsoirResultsState();
}

class _BonsoirResultsState extends ConsumerState<BonsoirResults> {
  @override
  Widget build(BuildContext context) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile || sizingInformation.isTablet) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              ...bonsoirDevices.mapIndexed((index, dev) => Column(
                    spacing: 8,
                    children: [
                      BdTile(bonsoirDevice: dev),
                      if (index != bonsoirDevices.length - 1) const Divider()
                    ],
                  )),
              if (bonsoirDevices.isNotEmpty) const Divider(),
              InfoLabel()
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    if (bonsoirDevices.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text('No devices found').textSmall.muted,
                        ),
                      ),
                    if (bonsoirDevices.isNotEmpty)
                      SliverList.builder(
                        itemCount: bonsoirDevices.length,
                        itemBuilder: (context, index) {
                          final bd = bonsoirDevices[index];

                          return Column(
                            children: [BdTile(bonsoirDevice: bd), Divider()],
                          );
                        },
                      )
                  ],
                ),
              ),
              Divider(),
              InfoLabel(),
            ],
          );
        }
      },
    );
  }
}

class InfoLabel extends StatelessWidget {
  const InfoLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Label(
      leading: const Icon(Icons.info).muted().iconSmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(el.connectLoc.withMdns.info.i1).muted().xSmall(),
            ],
          ),
          Text(el.connectLoc.withMdns.info.i2).muted().xSmall(),
          Text(el.connectLoc.withMdns.info.i3).muted().xSmall(),
        ],
      ),
    );
  }
}

class BdTile extends ConsumerStatefulWidget {
  final BonsoirService bonsoirDevice;
  const BdTile({super.key, required this.bonsoirDevice});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BdTileState();
}

class _BdTileState extends ConsumerState<BdTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bd = widget.bonsoirDevice;
    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((i) => bd.name.contains(i.serialNo));

    final connectedDevices = ref.watch(adbProvider);
    final isSaved = deviceInfo != null;

    bool connected =
        connectedDevices.where((e) => e.id.contains(bd.name)).isNotEmpty;
    return GhostButton(
      onPressed: () async => await _connectMdns(bd),
      child: PgListTile(
        title: '${bd.name} ${isSaved ? '[${deviceInfo.deviceName}]' : ''}',
        titleOverflow: true,
        // showSubtitle: true,
        showSubtitleLeading: false,
        // subtitle: '${bd.toJson()['service.host']}:${bd.port}',
        trailing: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            variance: ButtonVariance.ghost,
            icon: loading
                ? CircularProgressIndicator(
                    size: theme.iconTheme.medium.size,
                  )
                : connected
                    ? const Icon(Icons.check)
                    : const Icon(Icons.link),
            onPressed: loading || connected
                ? null
                : () async => await _connectMdns(bd),
          ),
        ),
      ),
    );
  }

  Future<void> _connectMdns(BonsoirService bd) async {
    loading = true;
    setState(() {});
    final res =
        await AdbUtils.connectWithMdns(ref, id: bd.name, from: 'device tile');

    if (mounted) {
      if (!res.success) {
        if (res.errorMessage.toLowerCase().contains('unauthenticated')) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: el.statusLoc.unauth,
              content: [
                Text(el.connectLoc.unauthenticated.info.i1),
                Text(el.connectLoc.unauthenticated.info.i2),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: el.statusLoc.failed,
              content: [
                Text(res.errorMessage.capitalizeFirst),
                Text(el.connectLoc.failed.info.i1),
                Text(el.connectLoc.failed.info.i2),
                Text('\n${el.connectLoc.failed.info.i3}'),
                Text(el.connectLoc.failed.info.i4),
                Text(el.connectLoc.failed.info.i5),
              ],
            ),
          );
        }
      }
      loading = false;
      setState(() {});
    }
  }
}
