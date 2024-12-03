// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/config_screen_sections/additional_flags.dart';
import 'package:scrcpygui/widgets/config_screen_sections/audio_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/device_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/mode_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/preview_and_test.dart';
import 'package:scrcpygui/widgets/config_screen_sections/video_config.dart';
import 'package:scrcpygui/widgets/config_screen_sections/window_config.dart';

import '../../utils/const.dart';
import '../../utils/scrcpy_utils.dart';
import '../../widgets/close_dialog.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({
    super.key,
  });

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  String modeLabel = MainMode.mirror.value;

  bool editname = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleOnClose() async {
    final allConfigs = ref.read(configsProvider);
    final selectedConfig = ref.read(newOrEditConfigProvider);
    final testInstance = ref.read(testInstanceProvider);
    final appPID = ref.read(appPidProvider);

    if (testInstance != null) {
      await ScrcpyUtils.killServer(testInstance, appPID);
      ref.read(scrcpyInstanceProvider.notifier).removeInstance(testInstance);
      ref.read(testInstanceProvider.notifier).state = null;
    }

    if (allConfigs.contains(selectedConfig)) {
      final lastused = await ScrcpyUtils.getLastUsedConfig(ref);

      if (allConfigs.contains(lastused)) {
        ref.read(selectedConfigProvider.notifier).state = lastused;
      } else {
        ref.read(selectedConfigProvider.notifier).state = defaultMirror;
      }

      Navigator.pop(context);
    } else {
      showDialog(
        barrierColor: Colors.black.withOpacity(0.9),
        context: context,
        builder: (context) {
          return const CloseDialog();
        },
      ).then((v) {
        if (v ?? false) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(newOrEditConfigProvider)!;
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    final buttonStyle = ButtonStyle(
        iconColor: WidgetStatePropertyAll(colorScheme.inverseSurface),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            style: buttonStyle,
            onPressed: () => _handleOnClose(),
            icon: const Icon(Icons.close_rounded),
          ),
          title: Text(selectedConfig.configName),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: appWidth + 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(appTheme.widgetRadius * 0.8),
                      ),
                      // width: appWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('* Device-specific')
                            .fontSize(10)
                            .italic(),
                      ),
                    ),
                    const ModeConfig(),
                    const VideoConfig(),
                    const AudioConfig(),
                    const DeviceConfig(),
                    const WindowConfig(),
                    const AdditionalFlagsConfig(),
                    const SizedBox(height: 30),
                    const Divider(indent: 30, endIndent: 30),
                    const PreviewAndTest(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
