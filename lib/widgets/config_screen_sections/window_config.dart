import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/config_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/const.dart';
import '../config_dropdown.dart';

class WindowConfig extends ConsumerStatefulWidget {
  const WindowConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WindowConfigState();
}

class _WindowConfigState extends ConsumerState<WindowConfig> {
  late TextEditingController timeLimitController;

  @override
  void initState() {
    final timeLimit =
        ref.read(newOrEditConfigProvider)!.windowOptions.timeLimit;
    timeLimitController = TextEditingController(
        text: timeLimit == 0 ? '-' : timeLimit.toString());
    super.initState();
  }

  @override
  void dispose() {
    timeLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(newOrEditConfigProvider)!;
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Window',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(appTheme.widgetRadius)),
          width: appWidth,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Hide window',
                  child: Checkbox(
                      value: selectedConfig.windowOptions.noWindow,
                      onChanged: (value) {
                        if (value!) {
                          ref.read(newOrEditConfigProvider.notifier).update(
                              (state) => state = state!.copyWith(
                                      deviceOptions:
                                          state.deviceOptions.copyWith(
                                    stayAwake: false,
                                    showTouches: false,
                                    offScreenOnClose: false,
                                    turnOffDisplay: false,
                                  )));
                        }

                        ref.read(newOrEditConfigProvider.notifier).update(
                              (state) => state = state!.copyWith(
                                  windowOptions: state.windowOptions
                                      .copyWith(noWindow: value)),
                            );
                      }),
                ),
                const SizedBox(height: 4),
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Borderless',
                  child: Checkbox(
                    value: selectedConfig.windowOptions.noBorder,
                    onChanged: (value) =>
                        ref.read(newOrEditConfigProvider.notifier).update(
                              (state) => state = state!.copyWith(
                                  windowOptions: state.windowOptions
                                      .copyWith(noBorder: value)),
                            ),
                  ),
                ),
                const SizedBox(height: 4),
                ConfigCustom(
                  childBackgroundColor: Colors.transparent,
                  label: 'Always on top',
                  child: Checkbox(
                    value: selectedConfig.windowOptions.alwaysOntop,
                    onChanged: (value) =>
                        ref.read(newOrEditConfigProvider.notifier).update(
                              (state) => state = state!.copyWith(
                                  windowOptions: state.windowOptions
                                      .copyWith(alwaysOntop: value)),
                            ),
                  ),
                ),
                const SizedBox(height: 4),
                ConfigUserInput(
                    label: 'Time limit',
                    controller: timeLimitController,
                    unit: 's',
                    onTap: () => setState(() {
                          timeLimitController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: timeLimitController.text.length);
                        }),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        ref.read(newOrEditConfigProvider.notifier).update(
                            (state) => state = state!.copyWith(
                                windowOptions: state.windowOptions
                                    .copyWith(timeLimit: 0)));

                        setState(() {
                          timeLimitController.text = '-';
                        });
                      } else {
                        ref.read(newOrEditConfigProvider.notifier).update(
                            (state) => state = state!.copyWith(
                                windowOptions: state.windowOptions
                                    .copyWith(timeLimit: int.parse(value))));
                      }
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }
}
