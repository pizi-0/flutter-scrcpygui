// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart'
    show NumExtension, StyledText;
import 'package:collection/collection.dart';
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
import '../../../../providers/device_info_provider.dart';
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
    dev = ref.read(selectedDeviceProvider)!;
    oldConfig = ref.read(configScreenConfig)!;
    final selectedDevice = ref.read(selectedDeviceProvider)!;
    final config = ref.read(configScreenConfig);
    final workDir = ref.read(execDirProvider);

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == selectedDevice.serialNo);

    namecontroller = TextEditingController(text: config!.configName);

    nameBox.addListener(_onFocusLost);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (deviceInfo == null) {
        final info = await AdbUtils.getDeviceInfoFor(workDir, dev);

        ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);

        await Db.saveDeviceInfos(ref.read(infoProvider));
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

  Future<void> _saveConfig() async {
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

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == selectedDevice?.serialNo);

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
                        Text(el.configScreenLoc.similarExist(
                                configName: similar.first.configName))
                            .textColor(Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
          Row(
            children: [
              IconButton.ghost(
                onPressed: context.pop,
                icon: Icon(Icons.arrow_back_rounded),
              ),
              FadeIn(
                duration: 200.milliseconds,
                animate: hasChanges && similar.isEmpty,
                child: IconButton.ghost(
                  onPressed: _saveConfig,
                  icon: Icon(Icons.save_rounded),
                ),
              ),
            ],
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
            : deviceInfo == null
                ? [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height - 110,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            CircularProgressIndicator(),
                            Text(el.statusLoc.gettingInfo).textSmall.muted,
                          ],
                        ),
                      ),
                    )
                  ]
                : [
                    if (isEditing) RenameConfig(oldConfig: oldConfig),
                    const SizedBox(width: sectionWidth, child: ModeConfig()),
                    if (selectedConfig.scrcpyMode != ScrcpyMode.audioOnly)
                      SizedBox(
                          width: sectionWidth,
                          child: VideoConfig(info: deviceInfo)),
                    if (selectedConfig.scrcpyMode != ScrcpyMode.videoOnly)
                      SizedBox(
                          width: sectionWidth,
                          child: AudioConfig(info: deviceInfo)),
                    const SizedBox(width: sectionWidth, child: AppConfig()),
                    const SizedBox(width: sectionWidth, child: DeviceConfig()),
                    const SizedBox(width: sectionWidth, child: WindowConfig()),
                    const SizedBox(
                        width: sectionWidth, child: AdditionalFlagsConfig()),
                    const PreviewAndTest(),
                    const SizedBox(height: 20),
                  ],
      ),
    );
  }

  void _onFocusLost() {
    namecontroller.text = ref.read(configScreenConfig)!.configName;
    setState(() {});
  }
}
