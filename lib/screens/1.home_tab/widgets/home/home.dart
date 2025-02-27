import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

import 'widgets/device_tile.dart';

final homeDeviceAttention = StateProvider((ref) => false);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(adbProvider);

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.all(0),
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConfigCustom(
              title: el.homeTab.devices.label(count: '${connected.length}')),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: connected.length,
              itemBuilder: (context, index) {
                final dev = connected[index];
                return DeviceTile(device: dev, key: ValueKey(dev.id));
              },
            ),
          )
        ],
      ),
    );
  }
}
