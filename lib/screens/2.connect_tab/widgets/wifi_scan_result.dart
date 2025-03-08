// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../models/adb_devices.dart';
import '../../../providers/adb_provider.dart';
import '../../../providers/bonsoir_devices.dart';
import '../../../utils/adb_utils.dart';
import '../../../widgets/custom_ui/pg_list_tile.dart';
import '../../1.home_tab/widgets/home/widgets/connection_error_dialog.dart';

class BonsoirResults extends ConsumerStatefulWidget {
  const BonsoirResults({super.key});

  @override
  ConsumerState<BonsoirResults> createState() => _BonsoirResultsState();
}

class _BonsoirResultsState extends ConsumerState<BonsoirResults> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final bonsoirDevices = ref.watch(bonsoirDeviceProvider);

    return Column(
      spacing: 8,
      children: bonsoirDevices
          .mapIndexed((index, dev) => Column(
                spacing: 8,
                children: [
                  BdTile(bonsoirDevice: dev),
                  if (index != bonsoirDevices.length - 1) const Divider()
                ],
              ))
          .toList(),
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
    final savedDevices = ref.watch(savedAdbDevicesProvider);
    final connectedDevices = ref.watch(adbProvider);
    AdbDevices? device;
    final bd = widget.bonsoirDevice;
    final isSaved =
        savedDevices.where((e) => e.id.contains(bd.name)).isNotEmpty;

    if (isSaved) {
      device = savedDevices.firstWhere((e) => e.id.contains(bd.name));
    }

    bool connected =
        connectedDevices.where((e) => e.id.contains(bd.name)).isNotEmpty;
    return GhostButton(
      onPressed: () async => await _connectMdns(bd),
      child: PgListTile(
        title: '${bd.name} ${isSaved ? '[${device!.name!}]' : ''}',
        titleOverflow: true,
        showSubtitle: true,
        showSubtitleLeading: false,
        subtitle: '${bd.toJson()['service.host']}:${bd.port}',
        trailing: Align(
          alignment: Alignment.centerRight,
          child: Center(
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
      ),
    );
  }

  _connectMdns(BonsoirService bd) async {
    loading = true;
    setState(() {});
    final res =
        await AdbUtils.connectWithMdns(ref, id: bd.name, from: 'device tile');

    if (mounted) {
      if (!res.success) {
        if (res.errorMessage.toLowerCase().contains('unauthenticated')) {
          showDialog(
            context: context,
            builder: (context) => const ErrorDialog(
              title: 'Unauthenticated',
              content: [
                Text('Check your phone.'),
                Text('Click allow debugging.')
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: 'Failed',
              content: [
                Text(res.errorMessage.capitalizeFirst),
                const Text(
                    'Make sure your device is paired to your PC\'s adb.'),
                const Text('Otherwise, try turning wireless Adb off and on.'),
                const Text('\nIf not paired:'),
                const Text('1. Use the pair windows (top-right button) '),
                const Text(
                    '2. Plug you device into your PC, allow debugging, and retry.'),
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
