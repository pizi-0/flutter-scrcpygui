import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../providers/adb_provider.dart';
import '../../../../providers/config_provider.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/const.dart';
import '../../../../utils/scrcpy_utils.dart';
import '../../../config_screen/config_screen.dart';

class HomeBottomBar extends ConsumerStatefulWidget {
  const HomeBottomBar({super.key});

  @override
  ConsumerState<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends ConsumerState<HomeBottomBar> {
  ScrcpyConfig? selectedConfig;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final allconfigs = ref.watch(configsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          children: [
            const Text('Start scrcpy')
                .textStyle(theme.typography.body)
                .fontWeight(FontWeight.w600),
            const Spacer(),
            HyperlinkButton(
              child: const Text('New config'),
              onPressed: () {
                final selectedDevice = ref.read(selectedDeviceProvider);
                if (selectedDevice != null) {
                  final newconfig = newConfig.copyWith(id: const Uuid().v4());
                  ref.read(configScreenConfig.notifier).state = newconfig;
                  Navigator.pushNamed(context, '/create_config');
                } else {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => ContentDialog(
                      title: const Text('Device'),
                      content: const Text(
                          'No device selected.\nSelect a device to create scrcpy config.'),
                      actions: [
                        Button(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
        Card(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: ComboBox(
                  isExpanded: true,
                  placeholder: const Text('Select a config'),
                  value: selectedConfig,
                  onChanged: (value) {
                    selectedConfig = value;
                    setState(() {});
                  },
                  items: allconfigs
                      .map((c) => ComboBoxItem(
                            value: c,
                            child: Row(
                              children: [
                                Text(c.configName),
                                const Spacer(),
                                if (c.isRecording)
                                  IconButton(
                                    icon: const Icon(
                                        FluentIcons.open_folder_horizontal),
                                    onPressed: () =>
                                        AppUtils.openFolder(c.savePath!),
                                  )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              Button(
                onPressed: loading ? null : _start,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: loading
                      ? const SizedBox.square(
                          dimension: 18, child: ProgressRing())
                      : const Text('Start'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _start() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ContentDialog(
          title: const Text('Config'),
          content: const Text(
              'No config selected.\nSelect a scrcpy config to start.'),
          actions: [
            Button(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } else {
      if (selectedDevice == null) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => ContentDialog(
            title: const Text('Device'),
            content: const Text(
                'No device selected.\nSelect a device to start scrcpy.'),
            actions: [
              Button(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      } else {
        loading = true;
        setState(() {});
        await ScrcpyUtils.newInstance(ref, selectedConfig: selectedConfig!);

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    }
  }
}
