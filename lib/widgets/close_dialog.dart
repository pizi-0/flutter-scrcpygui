import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

import '../providers/info_provider.dart';
import '../providers/theme_provider.dart';

class CloseDialog extends ConsumerStatefulWidget {
  const CloseDialog({super.key});

  @override
  ConsumerState<CloseDialog> createState() => _CloseDialogState();
}

class _CloseDialogState extends ConsumerState<CloseDialog> {
  bool nameExist = false;
  List<String> name = ['New config', 'Default (Mirror)', 'Default (Record)'];
  bool notAllowed = false;

  late TextEditingController nameController;

  @override
  void initState() {
    final selectedConfig = ref.read(selectedConfigProvider);
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
    final selectedConfig = ref.watch(selectedConfigProvider);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final settings = ref.watch(appThemeProvider);

    final info = ref
        .watch(infoProvider)
        .firstWhere((i) => i.device.serialNo == selectedDevice!.serialNo);

    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(settings.widgetRadius),
        side: BorderSide(
          color: notAllowed
              ? Colors.red
              : nameExist
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.surface,
          width: 5,
        ),
      ),
      title: notAllowed
          ? const Text(
              'Not allowed!',
              style: TextStyle(color: Colors.red),
            )
          : nameExist
              ? Text(
                  ref.watch(configToEditProvider) == null
                      ? 'Overwrite?'
                      : 'Save changes?',
                  style: ref.watch(configToEditProvider) == null
                      ? const TextStyle(color: Colors.red)
                      : const TextStyle(color: Colors.green),
                )
              : const Text('Save?'),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Command preview:'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(settings.widgetRadius * 0.8),
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SelectableText(
                      'scrcpy ${ScrcpyCommand.buildCommand(ref, selectedConfig, info, selectedDevice!, customName: nameController.text).toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '')}'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                label: Text('Config name'),
              ),
              onSubmitted: notAllowed
                  ? null
                  : (value) {
                      final selectedConfig = ref.read(selectedConfigProvider);
                      final toEdit = ref.read(configToEditProvider);

                      var currentConfig = selectedConfig;

                      currentConfig = currentConfig.copyWith(
                          configName: nameController.text);

                      if (nameExist) {
                        if (toEdit != null) {
                          ref
                              .read(configsProvider.notifier)
                              .overwriteConfig(toEdit, currentConfig);
                        } else {
                          final allConfigs = ref.read(configsProvider);
                          final toRemove = allConfigs.firstWhere(
                              (e) => e.configName == nameController.text);
                          ref
                              .read(configsProvider.notifier)
                              .overwriteConfig(toRemove, currentConfig);
                        }
                      } else {
                        ref
                            .read(configsProvider.notifier)
                            .addConfig(currentConfig);
                      }
                      ref.read(selectedConfigProvider.notifier).state =
                          currentConfig;

                      final toSave = ref
                          .read(configsProvider)
                          .where((e) => !defaultConfigs.contains(e))
                          .toList();

                      ScrcpyUtils.saveConfigs(ref, toSave);

                      Navigator.pop(context, true);
                    },
              onChanged: (value) {
                final allConfigs = ref.read(configsProvider);
                nameExist =
                    allConfigs.where((e) => e.configName == value).isNotEmpty;

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
        Row(
          children: [
            TextButton(
              onPressed: () {
                final toEdit = ref.read(configToEditProvider);
                if (toEdit != null) {
                  ref.read(selectedConfigProvider.notifier).state = toEdit;
                } else {
                  ref.read(selectedConfigProvider.notifier).state =
                      defaultMirror;
                }

                Navigator.pop(context, true);
              },
              child: const Text('Discard'),
            ),
            const Spacer(),
            TextButton(
              onPressed: notAllowed || nameController.text.isEmpty
                  ? null
                  : () {
                      final selectedConfig = ref.read(selectedConfigProvider);
                      final toEdit = ref.read(configToEditProvider);

                      var currentConfig = selectedConfig;

                      currentConfig = currentConfig.copyWith(
                          configName: nameController.text);

                      if (nameExist) {
                        if (toEdit != null) {
                          ref
                              .read(configsProvider.notifier)
                              .overwriteConfig(toEdit, currentConfig);
                        } else {
                          final allConfigs = ref.read(configsProvider);
                          final toRemove = allConfigs.firstWhere(
                              (e) => e.configName == nameController.text);
                          ref
                              .read(configsProvider.notifier)
                              .overwriteConfig(toRemove, currentConfig);
                        }
                      } else {
                        ref
                            .read(configsProvider.notifier)
                            .addConfig(currentConfig);
                      }
                      ref.read(selectedConfigProvider.notifier).state =
                          currentConfig;

                      final toSave = ref
                          .read(configsProvider)
                          .where((e) => !defaultConfigs.contains(e))
                          .toList();

                      ScrcpyUtils.saveConfigs(ref, toSave);

                      Navigator.pop(context, true);
                    },
              child: Text(nameExist ? 'Overwrite' : 'Save'),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
          ],
        )
      ],
    );
  }
}
