// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../db/db.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';

class ConfigDeleteDialog extends ConsumerStatefulWidget {
  final ScrcpyConfig config;
  const ConfigDeleteDialog({super.key, required this.config});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigDeleteDialogState();
}

class _ConfigDeleteDialogState extends ConsumerState<ConfigDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(el.deleteConfigDialogLoc.title),
      content: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: sectionWidth, maxWidth: sectionWidth),
          child: Text(el.deleteConfigDialogLoc
              .contents(configname: widget.config.configName))),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            PgDestructiveButton(
              child: Text(el.buttonLabelLoc.delete),
              onPressed: () async {
                if (ref.read(selectedConfigProvider) == widget.config) {
                  ref.read(selectedConfigProvider.notifier).state = ref
                      .read(filteredConfigsProvider)
                      .where((e) => e.id != widget.config.id)
                      .firstOrNull;
                }
                if (ref.read(controlPageConfigProvider) == widget.config) {
                  ref.read(controlPageConfigProvider.notifier).state = null;
                }
                ref.read(configsProvider.notifier).removeConfig(widget.config);
                await Db.saveConfigs(ref.read(configsProvider).toList());
                context.pop(true);
              },
            ),
            SecondaryButton(
                child: Text(el.buttonLabelLoc.cancel),
                onPressed: () => context.pop()),
          ],
        ),
      ],
    );
  }
}
