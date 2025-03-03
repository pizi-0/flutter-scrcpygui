import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/available_flags.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../providers/config_provider.dart';
import '../../../../../../widgets/config_tiles.dart';

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
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConfigCustom(
          title: el.addFlags.title,
          child: const Icon(Icons.flag),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(el.addFlags.add),
              TextField(
                controller: add,
                placeholder: const Text('--flag1 --flag-2 --flag-3=\'3 oh 3\''),
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
                          Icons.info,
                          size: theme.typography.textMuted.fontSize! - 2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          el.addFlags.info,
                          style: theme.typography.textMuted.copyWith(
                              color: theme.typography.textMuted.color!
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
