// ignore_for_file: avoid_unnecessary_containers

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../providers/config_provider.dart';

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
    return PgSectionCard(
      label: el.addFlags.title,
      children: [
        Basic(
          title: Text(el.addFlags.add),
          content: TextField(
            controller: add,
            placeholder: const Text('--flag1 --flag-2 --flag-3=\'3 oh 3\''),
            maxLines: 5,
            onChanged: (val) {
              ref
                  .read(configScreenConfig.notifier)
                  .setAdditionalFlags(additionalFlags: val);
            },
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
            child: Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.info_outline_rounded)
                    .iconXSmall()
                    .iconMutedForeground(),
                Expanded(child: Text(el.addFlags.info).xSmall().muted()),
              ],
            ),
          ),
        ).withRoundCorners(
            backgroundColor: theme.colorScheme.muted, radius: theme.radiusXs)
      ],
    );
  }
}
