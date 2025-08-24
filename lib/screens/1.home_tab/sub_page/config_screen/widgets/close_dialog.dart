// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ConfigScreenCloseDialog extends ConsumerStatefulWidget {
  final ScrcpyConfig oldConfig;
  const ConfigScreenCloseDialog({super.key, required this.oldConfig});

  @override
  ConsumerState<ConfigScreenCloseDialog> createState() =>
      _ConfigScreenCloseDialogState();
}

class _ConfigScreenCloseDialogState
    extends ConsumerState<ConfigScreenCloseDialog> {
  bool nameExist = false;
  List<String> name = ['New config', 'Default (Mirror)', 'Default (Record)'];

  late TextEditingController nameController;

  @override
  void initState() {
    final selectedConfig = ref.read(configScreenConfig)!;
    final allConfigs = ref.read(configsProvider);

    nameController = TextEditingController(
        text: name.contains(selectedConfig.configName)
            ? 'My config'
            : selectedConfig.configName);
    nameExist = allConfigs
        .where((e) =>
            e.configName.toLowerCase() == nameController.text.toLowerCase() &&
            e.id != selectedConfig.id)
        .isNotEmpty;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);
    final selectedConfig = ref.watch(configScreenConfig);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final theme = Theme.of(context);

    final hasChanges = widget.oldConfig != selectedConfig &&
        allConfigs.where((conf) => conf.id == selectedConfig!.id).isNotEmpty;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: sectionWidth),
      child: IntrinsicHeight(
        child: AlertDialog(
          title: nameExist
              ? Text(
                  el.closeDialogLoc.nameExist,
                  style: const TextStyle(color: Colors.red),
                )
              : hasChanges
                  ? Text(el.closeDialogLoc.overwrite)
                  : Text(el.closeDialogLoc.save),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: sectionWidth, maxWidth: sectionWidth),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(el.closeDialogLoc.commandPreview),
                Card(
                  child: Center(
                    child: Text(
                      'scrcpy ${ScrcpyCommand.buildCommand(ref, selectedConfig!, selectedDevice!, customName: nameController.text).toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '')}',
                    ),
                  ),
                ),
                Text(el.closeDialogLoc.name),
                TextField(
                  controller: nameController,
                  placeholder: const Text('Config name'),
                  onSubmitted: nameExist ? null : (v) => _submitEdit(),
                  decoration: nameExist
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(theme.radiusMd),
                          color: theme.colorScheme.destructive,
                          border: Border.all(
                            color: theme.colorScheme.destructive,
                          ),
                        )
                      : null,
                  onChanged: (value) {
                    final allConfigs = ref.read(configsProvider);
                    nameExist = allConfigs
                        .where((e) =>
                            e.configName.trim().toLowerCase() ==
                                value.trim().toLowerCase() &&
                            e.id != selectedConfig.id)
                        .isNotEmpty;

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            PgDestructiveButton(
              onPressed: () {
                context.pop(CloseDialogResult.discard);
              },
              child: Text(el.buttonLabelLoc.discard),
            ),
            const Spacer(),
            PrimaryButton(
              onPressed:
                  nameExist || nameController.text.isEmpty ? null : _submitEdit,
              child: Text(hasChanges
                  ? el.buttonLabelLoc.overwrite
                  : el.buttonLabelLoc.save),
            ),
            SecondaryButton(
              onPressed: () {
                context.pop(CloseDialogResult.cancel);
              },
              child: Text(el.buttonLabelLoc.cancel),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitEdit() async {
    final selectedConfig = ref.read(configScreenConfig)!;

    var currentConfig = selectedConfig;

    currentConfig = currentConfig.copyWith(configName: nameController.text);
    final allConfigs = ref.read(configsProvider);

    if (allConfigs.where((c) => c.id == currentConfig.id).isNotEmpty) {
      final toRemove = allConfigs.firstWhere((e) => e.id == currentConfig.id);
      ref
          .read(configsProvider.notifier)
          .overwriteConfig(toRemove, currentConfig);
    } else {
      ref.read(configsProvider.notifier).addConfig(currentConfig);
    }

    final toSave = ref.read(configsProvider).toList();

    if (ref.read(filteredConfigsProvider).contains(currentConfig)) {
      ref.read(selectedConfigProvider.notifier).state = ref
          .read(configsProvider)
          .firstWhere((c) => c.id == currentConfig.id,
              orElse: () => defaultMirror);
    }

    await Db.saveConfigs(toSave);

    context.pop(CloseDialogResult.save);
  }
}

enum CloseDialogResult {
  save,
  discard,
  cancel,
}
