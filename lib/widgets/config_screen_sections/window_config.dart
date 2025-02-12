import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';

import '../config_tiles.dart';

class WindowConfig extends ConsumerStatefulWidget {
  const WindowConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WindowConfigState();
}

class _WindowConfigState extends ConsumerState<WindowConfig> {
  late TextEditingController timeLimitController;

  @override
  void initState() {
    final timeLimit = ref.read(configScreenConfig)!.windowOptions.timeLimit;
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
    final selectedConfig = ref.watch(configScreenConfig)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Window'),
        ),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ConfigCustom(
              //   childBackgroundColor: Colors.transparent,
              //   title: 'Hide window',
              //   subtitle: selectedConfig.windowOptions.noWindow
              //       ? "uses '--no-window' flag"
              //       : "start scrcpy with no window",
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 4.0),
              //     child: Checkbox(
              //         checked: selectedConfig.windowOptions.noWindow,
              //         onChanged: (value) {
              //           if (value!) {
              //             ref.read(configScreenConfig.notifier).update(
              //                 (state) => state = state!.copyWith(
              //                         deviceOptions:
              //                             state.deviceOptions.copyWith(
              //                       stayAwake: false,
              //                       showTouches: false,
              //                       offScreenOnClose: false,
              //                       turnOffDisplay: false,
              //                     )));
              //           }

              //           ref.read(configScreenConfig.notifier).update(
              //                 (state) => state = state!.copyWith(
              //                     windowOptions: state.windowOptions
              //                         .copyWith(noWindow: value)),
              //               );
              //         }),
              //   ),
              // ),
              const Divider(),
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Borderless',
                subtitle: selectedConfig.windowOptions.noBorder
                    ? "uses '--window-borderless' flag"
                    : 'disable window decorations',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Checkbox(
                    checked: selectedConfig.windowOptions.noBorder,
                    onChanged: (value) =>
                        ref.read(configScreenConfig.notifier).update(
                              (state) => state = state!.copyWith(
                                  windowOptions: state.windowOptions
                                      .copyWith(noBorder: value)),
                            ),
                  ),
                ),
              ),
              const Divider(),
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Always on top',
                subtitle: selectedConfig.windowOptions.alwaysOntop
                    ? "uses '--always-on-top' flag"
                    : 'scrcpy window always on top',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Checkbox(
                    checked: selectedConfig.windowOptions.alwaysOntop,
                    onChanged: (value) =>
                        ref.read(configScreenConfig.notifier).update(
                              (state) => state = state!.copyWith(
                                  windowOptions: state.windowOptions
                                      .copyWith(alwaysOntop: value)),
                            ),
                  ),
                ),
              ),
              const Divider(),
              ConfigUserInput(
                  label: 'Time limit',
                  controller: timeLimitController,
                  subtitle: timeLimitController.text == '-'
                      ? 'limits scrcpy session, in seconds'
                      : "uses '--time-limit=${timeLimitController.text.trim()}' flag",
                  unit: 's',
                  onTap: () => setState(() {
                        timeLimitController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: timeLimitController.text.length);
                      }),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.read(configScreenConfig.notifier).update((state) =>
                          state = state!.copyWith(
                              windowOptions:
                                  state.windowOptions.copyWith(timeLimit: 0)));

                      setState(() {
                        timeLimitController.text = '-';
                      });
                    } else {
                      ref.read(configScreenConfig.notifier).update((state) =>
                          state = state!.copyWith(
                              windowOptions: state.windowOptions
                                  .copyWith(timeLimit: int.parse(value))));
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }
}
