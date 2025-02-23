// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/additional_flags.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/audio_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/device_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/mode_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/preview_and_test.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/video_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/window_config.dart';

import '../../../../providers/adb_provider.dart';
import '../../../../utils/const.dart';
import '../../../../utils/scrcpy_utils.dart';
import 'widgets/close_dialog.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  TextEditingController namecontroller = TextEditingController();
  late AdbDevices dev;
  FocusNode nameBox = FocusNode();

  String modeLabel = MainMode.mirror.value;

  @override
  void initState() {
    final selectedDevice = ref.read(selectedDeviceProvider)!;
    final config = ref.read(configScreenConfig);
    final workDir = ref.read(execDirProvider);

    dev = ref.read(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == selectedDevice.id,
        orElse: () => selectedDevice);

    namecontroller = TextEditingController(text: config!.configName);

    nameBox.addListener(_onFocusLost);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (dev.info == null) {
        final info = await AdbUtils.getScrcpyDetailsFor(workDir, dev);
        dev = dev.copyWith(info: info);

        ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
        ref.read(selectedDeviceProvider.notifier).state = dev;

        final newsaved = ref.read(savedAdbDevicesProvider);

        await Db.saveAdbDevice(newsaved);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    nameBox.removeListener(_onFocusLost);
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
      context.pop();
    } else {
      showDialog(
        barrierColor: Colors.black.withValues(alpha: 0.9),
        context: context,
        builder: (context) {
          return const ConfigScreenCloseDialog();
        },
      ).then((v) {
        if ((v as bool?) ?? false) {
          context.pop();
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
          title: SizedBox(
            width: 200,
            height: 30,
            child: TextBox(
              focusNode: nameBox,
              controller: namecontroller,
              onSubmitted: (value) async {
                ref.read(configScreenConfig.notifier).update(
                    (state) => state!.copyWith(configName: value.trim()));

                ref.read(configsProvider.notifier).overwriteConfig(
                    ref.read(configScreenConfig)!,
                    ref.read(configScreenConfig)!);

                await Db.saveConfigs(
                    ref,
                    context,
                    ref
                        .read(configsProvider)
                        .where((c) => !defaultConfigs.contains(c))
                        .toList());
              },
            ),
          ),
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

  _onFocusLost() {
    namecontroller.text = ref.read(configScreenConfig)!.configName;
    setState(() {});
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
