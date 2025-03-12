import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../providers/config_provider.dart';
import '../../../../../../widgets/config_tiles.dart';

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
    final showInfo = ref.watch(configScreenShowInfo);

    return PgSectionCard(
      label: el.windowSection.title,
      children: [
        ConfigCustom(
          onPressed: () {
            ref.read(configScreenConfig.notifier).update(
              (state) {
                final noWindow = state!.windowOptions.noWindow;

                return state.copyWith(
                  windowOptions: state.windowOptions.copyWith(
                    noWindow: !noWindow,
                  ),
                );
              },
            );

            if (ref.read(configScreenConfig)!.windowOptions.noWindow) {
              ref.read(configScreenConfig.notifier).update(
                    (state) => state = state!.copyWith(
                      deviceOptions: state.deviceOptions.copyWith(
                        stayAwake: false,
                        showTouches: false,
                        offScreenOnClose: false,
                        turnOffDisplay: false,
                      ),
                    ),
                  );
            }
          },
          childBackgroundColor: Colors.transparent,
          childExpand: false,
          title: el.windowSection.hideWindow.label,
          showinfo: showInfo,
          subtitle: selectedConfig.windowOptions.noWindow
              ? el.windowSection.hideWindow.info.alt
              : el.windowSection.hideWindow.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
                state: selectedConfig.windowOptions.noWindow
                    ? CheckboxState.checked
                    : CheckboxState.unchecked,
                onChanged: (value) {
                  debugPrint(value.toString());
                  if (value == CheckboxState.checked) {
                    ref.read(configScreenConfig.notifier).update(
                          (state) => state = state!.copyWith(
                            deviceOptions: state.deviceOptions.copyWith(
                              stayAwake: false,
                              showTouches: false,
                              offScreenOnClose: false,
                              turnOffDisplay: false,
                            ),
                          ),
                        );
                  }

                  ref.read(configScreenConfig.notifier).update(
                        (state) => state = state!.copyWith(
                            windowOptions: state.windowOptions.copyWith(
                                noWindow: value == CheckboxState.checked)),
                      );
                }),
          ),
        ),
        const Divider(),
        ConfigCustom(
          onPressed: () {
            ref.read(configScreenConfig.notifier).update((state) {
              final noBorder = state!.windowOptions.noBorder;

              return state.copyWith(
                windowOptions: state.windowOptions.copyWith(
                  noBorder: !noBorder,
                ),
              );
            });
          },
          childExpand: false,
          showinfo: showInfo,
          childBackgroundColor: Colors.transparent,
          title: el.windowSection.borderless.label,
          subtitle: selectedConfig.windowOptions.noBorder
              ? el.windowSection.borderless.info.alt
              : el.windowSection.borderless.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
              state: selectedConfig.windowOptions.noBorder
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
              onChanged: (value) =>
                  ref.read(configScreenConfig.notifier).update(
                        (state) => state = state!.copyWith(
                            windowOptions: state.windowOptions.copyWith(
                                noBorder: value == CheckboxState.checked)),
                      ),
            ),
          ),
        ),
        const Divider(),
        ConfigCustom(
          onPressed: () {
            ref.read(configScreenConfig.notifier).update((state) {
              final alwaysOntop = state!.windowOptions.alwaysOntop;

              return state.copyWith(
                windowOptions: state.windowOptions.copyWith(
                  alwaysOntop: !alwaysOntop,
                ),
              );
            });
          },
          childExpand: false,
          showinfo: showInfo,
          childBackgroundColor: Colors.transparent,
          title: el.windowSection.alwaysOnTop.label,
          subtitle: selectedConfig.windowOptions.alwaysOntop
              ? el.windowSection.alwaysOnTop.info.alt
              : el.windowSection.alwaysOnTop.info.default$,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Checkbox(
              state: selectedConfig.windowOptions.alwaysOntop
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
              onChanged: (value) =>
                  ref.read(configScreenConfig.notifier).update(
                        (state) => state = state!.copyWith(
                            windowOptions: state.windowOptions.copyWith(
                                alwaysOntop: value == CheckboxState.checked)),
                      ),
            ),
          ),
        ),
        const Divider(),
        ConfigUserInput(
            showinfo: showInfo,
            label: el.windowSection.timeLimit.label,
            controller: timeLimitController,
            subtitle: timeLimitController.text == '-'
                ? el.windowSection.timeLimit.info.default$
                : el.windowSection.timeLimit.info
                    .alt(time: timeLimitController.text.trim()),
            unit: 's',
            onTap: () => setState(() {
                  timeLimitController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: timeLimitController.text.length);
                }),
            onChanged: (value) {
              if (value.isEmpty) {
                ref.read(configScreenConfig.notifier).update((state) => state =
                    state!.copyWith(
                        windowOptions:
                            state.windowOptions.copyWith(timeLimit: 0)));

                setState(() {
                  timeLimitController.text = '-';
                });
              } else {
                ref.read(configScreenConfig.notifier).update((state) => state =
                    state!.copyWith(
                        windowOptions: state.windowOptions
                            .copyWith(timeLimit: int.parse(value))));
              }
            })
      ],
    );
  }
}
