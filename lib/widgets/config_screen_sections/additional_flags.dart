import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/available_flags.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';

import '../../providers/settings_provider.dart';
import '../../utils/const.dart';

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
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Additional flags',
            style: Theme.of(context).textTheme.titleLarge,
          ).textColor(colorScheme.inverseSurface),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(appTheme.widgetRadius),
          ),
          width: appWidth,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text('Add additional flags')
                      .textColor(colorScheme.inverseSurface),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius:
                        BorderRadius.circular(appTheme.widgetRadius * 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      cursorColor: colorScheme.inverseSurface,
                      style: TextStyle(
                          fontSize: 14, color: colorScheme.inverseSurface),
                      controller: add,
                      decoration: const InputDecoration.collapsed(
                        hintText: '--flag1 --flag-2 --flag-3=\'3 oh 3\'',
                      ),
                      maxLines: 5,
                      inputFormatters: [
                        ...availableFlags
                            .map((e) => FilteringTextInputFormatter.deny(e))
                      ],
                      onChanged: (val) {
                        ref.read(configScreenConfig.notifier).update((state) =>
                            state = state!.copyWith(additionalFlags: val));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
