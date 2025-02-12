import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/available_flags.dart';

import '../../providers/config_provider.dart';

class AdditionalFlagsConfig extends ConsumerStatefulWidget {
  const AdditionalFlagsConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdditionalFlagsConfigState();
}

class _AdditionalFlagsConfigState extends ConsumerState<AdditionalFlagsConfig> {
  TextEditingController add = TextEditingController();

  @override
  void initState() {
    final config = ref.read(configScreenConfig)!;
    add.text = config.additionalFlags;
    super.initState();
  }

  @override
  void dispose() {
    add.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Additional flags'),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add additional flags'),
              TextBox(
                controller: add,
                placeholder: '--flag1 --flag-2 --flag-3=\'3 oh 3\'',
                maxLines: 5,
                inputFormatters: [
                  ...availableFlags
                      .map((e) => FilteringTextInputFormatter.deny(e))
                ],
                onChanged: (val) {
                  ref.read(configScreenConfig.notifier).update(
                      (state) => state = state!.copyWith(additionalFlags: val));
                },
              ),
              Card(
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  child: Row(
                    spacing: 8,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          FluentIcons.info,
                          size: theme.typography.caption!.fontSize! - 2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'avoid using flags that are already an option',
                          style: theme.typography.caption!.copyWith(
                              color: theme.typography.caption!.color!
                                  .withAlpha(150)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
