import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/app_grid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../providers/app_config_pair_provider.dart';

class PinnedAppDisplay extends ConsumerWidget {
  final AdbDevices device;
  const PinnedAppDisplay({super.key, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfigPairs =
        ref.watch(appConfigPairProvider.select((pair) => pair.where((p) => p.deviceId == device.id))).toList();

    appConfigPairs.sort((a, b) => a.app.name.toLowerCase().compareTo(b.app.name.toLowerCase()));

    return GridView.builder(
      shrinkWrap: true,
      itemCount: appConfigPairs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 8, mainAxisSpacing: 8, crossAxisCount: 3, childAspectRatio: 150 / 40),
      itemBuilder: (context, index) {
        final pair = appConfigPairs.toList()[index];

        return AppGridTile(ref: ref, device: device, app: pair.app);
      },
    );
  }
}
