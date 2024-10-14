import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/log_screen/log_screen.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';

import '../../models/scrcpy_related/scrcpy_info.dart';
import '../../providers/info_provider.dart';
import '../../utils/const.dart';
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _isStillRunning() async {
    final res = await ScrcpyUtils.getRunningScrcpy(ref.read(appPidProvider));

    if (ref.read(testInstanceProvider) != null) {
      if (!res.contains(ref.read(testInstanceProvider)!.scrcpyPID)) {
        ref
            .read(scrcpyInstanceProvider.notifier)
            .removeInstance(ref.read(testInstanceProvider)!);
        ref.read(testInstanceProvider.notifier).update((state) => state = null);
        timer?.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(newConfigProvider)!;
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final testInstance = ref.watch(testInstanceProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    final bool isTestRunning = runningInstance.contains(testInstance);

    final ScrcpyInfo info = ref
        .watch(infoProvider)
        .firstWhere((i) => i.device.serialNo == selectedDevice!.serialNo);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Test config',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(appTheme.widgetRadius)),
          width: appWidth,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Command preview:'),
                ),
                Container(
                  width: appWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius:
                        BorderRadius.circular(appTheme.widgetRadius * 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      'scrcpy ${ScrcpyCommand.buildCommand(ref, selectedConfig, info, selectedDevice!).join(' ')}',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              !isTestRunning ? Colors.green : Colors.red),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  appTheme.widgetRadius * 0.8))),
                        ),
                        onPressed: () async {
                          if (!isTestRunning) {
                            final inst = await ScrcpyUtils.newInstance(ref);

                            timer = Timer.periodic(1.seconds, (a) async {
                              await _isStillRunning();
                            });

                            ref
                                .read(testInstanceProvider.notifier)
                                .update((state) => state = inst);

                            Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LogScreen(instance: inst),
                                ));
                          } else {
                            final appPID = ref.read(appPidProvider);
                            await ScrcpyUtils.killServer(testInstance!, appPID);
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
                            ? const Text('Test config')
                                .textColor(Colors.black)
                                .bold()
                            : const Text('Stop').textColor(Colors.black).bold(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
