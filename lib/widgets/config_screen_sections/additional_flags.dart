import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/scrcpy_related/available_flags.dart';
import 'package:pg_scrcpy/providers/config_provider.dart';

import '../../providers/theme_provider.dart';
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
    final config = ref.read(selectedConfigProvider);
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
    final settings = ref.watch(appThemeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Additional flags',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(settings.widgetRadius),
          ),
          width: appWidth,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Add additional flags'),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius:
                        BorderRadius.circular(settings.widgetRadius * 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: add,
                      decoration: const InputDecoration.collapsed(
                        hintText: '--flag1 --flag-2 --flag-3=\'3 oh 3\'',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      maxLines: 5,
                      inputFormatters: [
                        ...availableFlags
                            .map((e) => FilteringTextInputFormatter.deny(e))
                      ],
                      onChanged: (val) {
                        ref.read(selectedConfigProvider.notifier).update(
                            (state) =>
                                state = state.copyWith(additionalFlags: val));
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
