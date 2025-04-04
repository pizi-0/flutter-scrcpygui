// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/app_config.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/additional_flags.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/audio_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/device_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/mode_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/preview_and_test.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/video_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/widgets/config_screen_sections/window_config.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../providers/adb_provider.dart';
import '../../../../utils/const.dart';
import 'widgets/close_dialog.dart';
import 'widgets/config_screen_sections/config_rename.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  static const route = 'config-settings';
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  TextEditingController namecontroller = TextEditingController();
  late ScrcpyConfig oldConfig;
  late AdbDevices dev;
  FocusNode nameBox = FocusNode();

  String modeLabel = MainMode.mirror.value;

  @override
  void initState() {
    oldConfig = ref.read(configScreenConfig)!;
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

  // _handleOnClose() async {
  //   final allConfigs = ref.read(configsProvider);
  //   final selectedConfig = ref.read(configScreenConfig);
  //   final testInstance = ref.read(testInstanceProvider);
  //   final selectedDevice = ref.read(selectedDeviceProvider);

  //   if (testInstance != null) {
  //     await ScrcpyUtils.killServer(testInstance);
  //     ref.read(scrcpyInstanceProvider.notifier).removeInstance(testInstance);
  //     ref.read(testInstanceProvider.notifier).state = null;
  //   }

  //   if (allConfigs.contains(selectedConfig) ||
  //       selectedConfig == newConfig ||
  //       selectedDevice == null) {
  //     context.pop();
  //   } else {
  //     showDialog(
  //       barrierColor: Colors.black.withValues(alpha: 0.9),
  //       context: context,
  //       builder: (context) {
  //         return Center(child: ConfigScreenCloseDialog(oldConfig: oldConfig));
  //       },
  //     ).then((v) {
  //       if ((v as bool?) ?? false) {
  //         context.pop();
  //       }
  //     });
  //   }
  // }

  _saveConfig() async {
    showDialog(
      barrierColor: Colors.black.withValues(alpha: 0.9),
      context: context,
      builder: (context) {
        return Center(child: ConfigScreenCloseDialog(oldConfig: oldConfig));
      },
    ).then((v) {
      final res = (v as CloseDialogResult?) ?? CloseDialogResult.cancel;

      switch (res) {
        case CloseDialogResult.save:
          setState(() => oldConfig = ref.read(configScreenConfig)!);
          context.pop();
        case CloseDialogResult.discard:
          context.pop();
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final allConfigs = ref.watch(configsProvider);
    final selectedConfig = ref.watch(configScreenConfig)!;
    final showInfo = ref.watch(configScreenShowInfo);
    final selectedDevice = ref.watch(selectedDeviceProvider);

    final isEditing =
        allConfigs.where((c) => c.id == selectedConfig.id).isNotEmpty;

    final hasChanges = oldConfig != selectedConfig &&
        defaultConfigs
            .where((conf) => selectedConfig.isSimilarTo(conf))
            .isEmpty;

    final similar = allConfigs.where((conf) =>
        !defaultConfigs.contains(conf) &&
        selectedConfig.isSimilarTo(conf) &&
        conf.id != selectedConfig.id);

    return PopScope(
      canPop: false,
      child: PgScaffold(
        footers: [
          if (similar.isNotEmpty)
            FadeInUp(
              duration: 200.milliseconds,
              child: Container(
                color: theme.colorScheme.destructive,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Basic(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Text(el.configScreenLoc
                            .similarExist(count: similar.length.toString())),
                        HoverCard(
                            hoverBuilder: (context) => SurfaceCard(
                                    child: Basic(
                                  content: Column(
                                    spacing: 4,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: similar
                                        .map((conf) => Text(conf.configName))
                                        .toList(),
                                  ),
                                )),
                            child: Icon(Icons.info_outline_rounded).iconSmall())
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
        showLoading: dev.info == null,
        appBarTrailing: [
          Checkbox(
            leading: Text(el.buttonLabelLoc.info),
            state: showInfo ? CheckboxState.checked : CheckboxState.unchecked,
            onChanged: (value) => ref
                .read(configScreenShowInfo.notifier)
                .update((state) => !state),
          ),
        ],
        leading: [
          IconButton.ghost(
            onPressed:
                hasChanges && similar.isEmpty ? _saveConfig : context.pop,
            icon: hasChanges && similar.isEmpty
                ? Icon(Icons.save_rounded)
                : Icon(Icons.arrow_back_rounded),
          ),
        ],
        title: hasChanges
            ? '${el.configScreenLoc.title}*'
            : el.configScreenLoc.title,
        children: selectedDevice == null
            ? [
                Center(
                  child: Text(el.configScreenLoc.connectionLost),
                )
              ]
            : [
                if (isEditing) RenameConfig(oldConfig: oldConfig),
                const SizedBox(width: appWidth, child: ModeConfig()),
                if (selectedConfig.scrcpyMode != ScrcpyMode.audioOnly)
                  const SizedBox(width: appWidth, child: VideoConfig()),
                if (selectedConfig.scrcpyMode != ScrcpyMode.videoOnly)
                  const SizedBox(width: appWidth, child: AudioConfig()),
                const SizedBox(width: appWidth, child: AppConfig()),
                const SizedBox(width: appWidth, child: DeviceConfig()),
                const SizedBox(width: appWidth, child: WindowConfig()),
                const SizedBox(width: appWidth, child: AdditionalFlagsConfig()),
                const PreviewAndTest(),
                const SizedBox(height: 20),
              ],
      ),
    );
  }

  _onFocusLost() {
    namecontroller.text = ref.read(configScreenConfig)!.configName;
    setState(() {});
  }
}
