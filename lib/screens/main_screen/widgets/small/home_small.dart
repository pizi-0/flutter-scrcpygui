import 'package:awesome_extensions/awesome_extensions.dart' show StyledText;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';

import '../shared/device_tile.dart';
import 'bottom_bar.dart';

final homeDeviceAttention = StateProvider((ref) => false);

class HomeSmall extends ConsumerWidget {
  const HomeSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FluentTheme.of(context);
    final connected = ref.watch(adbProvider);

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.all(0),
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connected devices (${connected.length})')
              .textStyle(theme.typography.body)
              .fontWeight(FontWeight.w600),
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
