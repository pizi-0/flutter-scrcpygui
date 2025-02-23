// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return ContentDialog(
      title: const Text('Confirm'),
      content: Text('Delete ${widget.config.configName}?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            Button(
              child: const Text('Delete'),
              onPressed: () async {
                if (ref.read(selectedConfigProvider) == widget.config) {
                  ref.read(selectedConfigProvider.notifier).state = ref
                      .read(configsProvider)
                      .where((e) => e.id != widget.config.id)
                      .first;
                }
                ref.read(configsProvider.notifier).removeConfig(widget.config);
                await Db.saveConfigs(
                    ref,
                    context,
                    ref
                        .read(configsProvider)
                        .where((e) => !defaultConfigs.contains(e))
                        .toList());
                context.pop(true);
              },
            ),
            Button(child: const Text('Cancel'), onPressed: () => context.pop()),
          ],
        ),
      ],
    );
  }
}
