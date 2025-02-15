import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

import 'home/device_tile.dart';
import 'bottom_bar/bottom_bar.dart';

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
          ConfigCustom(title: 'Connected devices (${connected.length})'),
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
      bottomBar: const HomeBottomBar(),
    );
  }
}
