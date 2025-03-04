// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ConfigScreenCloseDialog extends ConsumerStatefulWidget {
  const ConfigScreenCloseDialog({super.key});

  @override
  ConsumerState<ConfigScreenCloseDialog> createState() =>
      _ConfigScreenCloseDialogState();
}

class _ConfigScreenCloseDialogState
    extends ConsumerState<ConfigScreenCloseDialog> {
  bool nameExist = false;
  List<String> name = ['New config', 'Default (Mirror)', 'Default (Record)'];
  bool notAllowed = false;

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
            e.configName.toLowerCase() == nameController.text.toLowerCase())
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
    final selectedConfig = ref.watch(configScreenConfig);
    final selectedDevice = ref.watch(selectedDeviceProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: appWidth),
      child: IntrinsicHeight(
        child: AlertDialog(
          title: notAllowed
              ? Text(
                  el.closeDialogLoc.notAllowed,
                  style: const TextStyle(color: Colors.red),
                )
              : nameExist
                  ? Text(
                      el.closeDialogLoc.overwrite,
                      style: const TextStyle(color: Colors.red),
                    )
                  : Text(el.closeDialogLoc.save),
          content: ConstrainedBox(
            constraints:
                const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
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
                  onSubmitted: notAllowed ? null : (v) => _submitEdit(),
                  onChanged: (value) {
                    final allConfigs = ref.read(configsProvider);
                    nameExist = allConfigs
                        .where((e) => e.configName == value)
                        .isNotEmpty;

                    notAllowed = name
                        .where((e) => e.toLowerCase() == value.toLowerCase())
                        .isNotEmpty;

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            DestructiveButton(
              onPressed: () {
                context.pop(true);
              },
              child: Text(el.buttonLabelLoc.discard),
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: notAllowed || nameController.text.isEmpty
                  ? null
                  : _submitEdit,
              child: Text(nameExist
                  ? el.buttonLabelLoc.overwrite
                  : el.buttonLabelLoc.save),
            ),
            SecondaryButton(
              onPressed: () {
                context.pop(false);
              },
              child: Text(el.buttonLabelLoc.cancel),
            )
          ],
        ),
      ),
    );
  }

  _submitEdit() async {
    final selectedConfig = ref.read(configScreenConfig)!;

    var currentConfig = selectedConfig;

    currentConfig = currentConfig.copyWith(configName: nameController.text);
    final allConfigs = ref.read(configsProvider);

    if (nameExist) {
      final toRemove = allConfigs.firstWhere((e) =>
          e.id == currentConfig.id || e.configName == currentConfig.configName);
      ref
          .read(configsProvider.notifier)
          .overwriteConfig(toRemove, currentConfig);
    } else {
      if (allConfigs.where((c) => c.id == currentConfig.id).isNotEmpty) {
        final toRemove = allConfigs.firstWhere((e) => e.id == currentConfig.id);
        ref
            .read(configsProvider.notifier)
            .overwriteConfig(toRemove, currentConfig);
      } else {
        ref.read(configsProvider.notifier).addConfig(currentConfig);
      }
    }

    final toSave = ref
        .read(configsProvider)
        .where((e) => !defaultConfigs.contains(e))
        .toList();

    ref.read(selectedConfigProvider.notifier).state = ref
        .read(configsProvider)
        .firstWhere((c) => c.id == currentConfig.id,
            orElse: () => defaultMirror);

    await Db.saveConfigs(ref, context, toSave);

    context.pop(true);
  }
}
