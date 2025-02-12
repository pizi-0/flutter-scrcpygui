// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/widgets/config_screen_sections/additional_flags.dart';
import 'package:scrcpygui/widgets/config_screen_sections/audio_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/device_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/mode_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/preview_and_test.dart';
import 'package:scrcpygui/widgets/config_screen_sections/video_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/window_config.dart';
import 'package:window_manager/window_manager.dart';

import '../../providers/adb_provider.dart';
import '../../utils/const.dart';
import '../../utils/scrcpy_utils.dart';
import '../../widgets/close_dialog.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  late AdbDevices dev;

  String modeLabel = MainMode.mirror.value;

  bool editname = false;

  @override
  void initState() {
    final selectedDevice = ref.read(selectedDeviceProvider)!;
    final workDir = ref.read(execDirProvider);

    dev = ref.read(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == selectedDevice.id,
        orElse: () => selectedDevice);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (dev.info == null) {
        final info = await AdbUtils.getScrcpyDetailsFor(workDir, dev);
        dev = dev.copyWith(info: info);

        ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
        ref.read(selectedDeviceProvider.notifier).state = dev;

        final newsaved = ref.read(savedAdbDevicesProvider);

        await AdbUtils.saveAdbDevice(newsaved);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleOnClose() async {
    final allConfigs = ref.read(configsProvider);
    final selectedConfig = ref.read(configScreenConfig);
    final testInstance = ref.read(testInstanceProvider);
    final selectedDevice = ref.read(selectedDeviceProvider);

    if (testInstance != null) {
      await ScrcpyUtils.killServer(testInstance);
      ref.read(scrcpyInstanceProvider.notifier).removeInstance(testInstance);
      ref.read(testInstanceProvider.notifier).state = null;
    }

    if (allConfigs.contains(selectedConfig) ||
        selectedConfig == newConfig ||
        selectedDevice == null) {
      Navigator.pop(context);
    } else {
      showDialog(
        barrierColor: Colors.black.withValues(alpha: 0.9),
        context: context,
        builder: (context) {
          return const CloseDialog();
        },
      ).then((v) {
        if ((v as bool?) ?? false) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final showInfo = ref.watch(configScreenShowInfo);

    return PopScope(
      canPop: false,
      child: NavigationView(
        appBar: NavigationAppBar(
          leading: IconButton(
            onPressed: () => _handleOnClose(),
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(FluentIcons.back),
            ),
          ),
          actions: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Info'),
                  Checkbox(
                    checked: showInfo,
                    onChanged: (v) {
                      ref
                          .read(configScreenShowInfo.notifier)
                          .update((state) => !state);
                    },
                  ),
                ],
              ),
            ),
          ),
          title: DragToMoveArea(child: Text(selectedConfig.configName)),
        ),
        pane: NavigationPane(
          menuButton: const SizedBox(),
          size: const NavigationPaneSize(compactWidth: 0),
          toggleable: false,
          displayMode: PaneDisplayMode.compact,
          selected: 0,
          items: [
            PaneItem(
              icon: const SizedBox(),
              body: dev.info == null
                  ? const Center(child: CupertinoActivityIndicator())
                  : selectedDevice == null
                      ? const Text('Device connection lost')
                      : ScaffoldPage.scrollable(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          children: [
                            Center(
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 8,
                                runSpacing: 8,
                                children: mobileList(selectedConfig),
                              ),
                            )
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> mobileList(ScrcpyConfig selectedConfig) {
    return [
      const SizedBox(width: appWidth, child: ModeConfig()),
      if (selectedConfig.scrcpyMode != ScrcpyMode.audioOnly)
        const SizedBox(width: appWidth, child: VideoConfig()),
      if (selectedConfig.scrcpyMode != ScrcpyMode.videoOnly)
        const SizedBox(width: appWidth, child: AudioConfig()),
      const SizedBox(width: appWidth, child: DeviceConfig()),
      const SizedBox(width: appWidth, child: WindowConfig()),
      const SizedBox(width: appWidth, child: AdditionalFlagsConfig()),
      const SizedBox(
          width: appWidth,
          child: Column(
            children: [
              SizedBox(height: 30),
              Divider(),
              PreviewAndTest(),
              SizedBox(height: 30),
            ],
          )),
    ];
  }
}
