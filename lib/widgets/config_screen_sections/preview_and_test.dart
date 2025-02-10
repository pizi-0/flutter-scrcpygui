import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/screens/log_screen/log_screen.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';

import '../../utils/scrcpy_utils.dart';

final testInstanceProvider =
    StateProvider<ScrcpyRunningInstance?>((ref) => null);

class PreviewAndTest extends ConsumerStatefulWidget {
  const PreviewAndTest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewAndTestState();
}

class _PreviewAndTestState extends ConsumerState<PreviewAndTest> {
  Timer? timer;
  FlyoutController flyoutController = FlyoutController();

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _isStillRunning() async {
    if (mounted) {
      final res = await ScrcpyUtils.getRunningScrcpy(ref.read(appPidProvider));
      if (ref.read(testInstanceProvider) != null) {
        if (!res.contains(ref.read(testInstanceProvider)!.scrcpyPID)) {
          ref
              .read(scrcpyInstanceProvider.notifier)
              .removeInstance(ref.read(testInstanceProvider)!);
          ref
              .read(testInstanceProvider.notifier)
              .update((state) => state = null);
          timer?.cancel();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(configScreenConfig)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final testInstance = ref.watch(testInstanceProvider);
    final theme = FluentTheme.of(context);

    final bool isTestRunning = runningInstance.contains(testInstance);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Test config'),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Command preview:'),
                  CopyButton(
                    ref: ref,
                    selectedConfig: selectedConfig,
                    selectedDevice: selectedDevice,
                  )
                ],
              ),
              Card(
                  backgroundColor: theme.cardColor.lighten(80),
                  child: Text(
                    'scrcpy ${ScrcpyCommand.buildCommand(ref, selectedConfig, selectedDevice!, customName: '[TEST] ${selectedConfig.configName}').join(' ')}',
                  )),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          !isTestRunning
                              ? theme.accentColor
                              : Colors.errorPrimaryColor,
                        ),
                      ),
                      onPressed: () async {
                        if (!isTestRunning) {
                          await ScrcpyUtils.newInstance(ref,
                              selectedConfig: selectedConfig, isTest: true);

                          timer = Timer.periodic(1.seconds, (a) async {
                            await _isStillRunning();
                          });

                          final inst = ref
                              .read(scrcpyInstanceProvider)
                              .where((inst) =>
                                  inst.device == selectedDevice &&
                                  inst.config == selectedConfig)
                              .first;

                          ref.read(testInstanceProvider.notifier).state = inst;

                          Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LogScreen(instance: inst),
                              ));
                        } else {
                          await ScrcpyUtils.killServer(testInstance!);
                          ref
                              .read(scrcpyInstanceProvider.notifier)
                              .removeInstance(testInstance);
                          ref
                              .read(testInstanceProvider.notifier)
                              .update((state) => state = null);
                        }
                        setState(() {});
                      },
                      child: !isTestRunning
                          ? const Text('Test config').textColor(Colors.white)
                          : const Text('Stop').textColor(Colors.white).bold(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CopyButton extends StatefulWidget {
  const CopyButton({
    super.key,
    required this.ref,
    required this.selectedConfig,
    required this.selectedDevice,
  });

  final WidgetRef ref;
  final ScrcpyConfig selectedConfig;
  final AdbDevices? selectedDevice;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  Timer? timer;
  bool copied = false;

  _startTimer() {
    copied = true;
    setState(() {});
    timer = Timer(500.milliseconds, () {
      if (mounted) {
        copied = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: copied
          ? const Icon(FluentIcons.check_mark)
          : const Icon(FluentIcons.copy),
      onPressed: () async {
        ClipboardData data = ClipboardData(
            text:
                'scrcpy ${ScrcpyCommand.buildCommand(widget.ref, widget.selectedConfig, widget.selectedDevice!, customName: '[TEST] ${widget.selectedConfig.configName}').join(' ')}');

        await Clipboard.setData(data);
        _startTimer();
        displayInfoBar(
          // ignore: use_build_context_synchronously
          context,
          builder: (context, close) => const Card(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: InfoLabel.rich(
              label: TextSpan(text: 'Copied'),
            ),
          ),
        );
      },
    );
  }
}
