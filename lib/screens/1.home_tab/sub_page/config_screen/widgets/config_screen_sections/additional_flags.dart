// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/available_flags.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';

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
    return PgSectionCard(
      label: el.addFlags.title,
      children: [
        FLabel(
          axis: Axis.vertical,
          label: const Text('--flag1 --flag-2 --flag-3=\'3 oh 3\''),
          child: TextField(
            controller: add,
            maxLines: 5,
            inputFormatters: [
              ...availableFlags.map((e) => FilteringTextInputFormatter.deny(e))
            ],
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
                const Icon(Icons.info_outline_rounded),
                Expanded(child: Text(el.addFlags.info)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
