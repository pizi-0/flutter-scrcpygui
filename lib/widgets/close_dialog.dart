// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

import '../providers/info_provider.dart';
import '../providers/settings_provider.dart';

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
    final selectedConfig = ref.read(newOrEditConfigProvider)!;
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
    final selectedConfig = ref.watch(newOrEditConfigProvider);
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    final info = ref
        .watch(infoProvider)
        .firstWhere((i) => i.device.serialNo == selectedDevice!.serialNo);

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(appTheme.widgetRadius),
        side: BorderSide(
          color: notAllowed
              ? Colors.red
              : nameExist
                  ? Theme.of(context).colorScheme.primaryContainer
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
              ? const Text(
                  'Overwrite?',
                  style: TextStyle(color: Colors.red),
                )
              : const Text('Save?').textColor(colorScheme.inverseSurface),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Command preview:')
                .textColor(colorScheme.inverseSurface),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(appTheme.widgetRadius * 0.8),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SelectableText(
                    'scrcpy ${ScrcpyCommand.buildCommand(ref, selectedConfig!, info, selectedDevice!, customName: nameController.text).toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '')}',
                    style: TextStyle(
                        fontSize: 14, color: colorScheme.inverseSurface),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                label: const Text('Config name')
                    .textColor(colorScheme.inverseSurface.withOpacity(0.8)),
              ),
              onSubmitted: notAllowed
                  ? null
                  : (value) async {
                      final selectedConfig = ref.read(newOrEditConfigProvider)!;

                      var currentConfig = selectedConfig;

                      currentConfig = currentConfig.copyWith(
                          configName: nameController.text);

                      if (nameExist) {
                        final allConfigs = ref.read(configsProvider);
                        final toRemove = allConfigs
                            .firstWhere((e) => e.id == currentConfig.id);
                        ref
                            .read(configsProvider.notifier)
                            .overwriteConfig(toRemove, currentConfig);
                      } else {
                        final allConfigs = ref.read(configsProvider);

                        if (allConfigs
                            .where((c) => c.id == currentConfig.id)
                            .isNotEmpty) {
                          final toRemove = allConfigs
                              .firstWhere((e) => e.id == currentConfig.id);
                          ref
                              .read(configsProvider.notifier)
                              .overwriteConfig(toRemove, currentConfig);
                        } else {
                          ref
                              .read(configsProvider.notifier)
                              .addConfig(currentConfig);
                        }
                      }

                      ref.read(selectedConfigProvider.notifier).state =
                          currentConfig;

                      final toSave = ref
                          .read(configsProvider)
                          .where((e) => !defaultConfigs.contains(e))
                          .toList();

                      await ScrcpyUtils.saveConfigs(ref, context, toSave);

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
              style: buttonStyle,
              onPressed: () {
                final allConfigs = ref.read(configsProvider);

                ref.read(selectedConfigProvider.notifier).state =
                    allConfigs.firstWhere((c) => c.id == selectedConfig.id,
                        orElse: () => defaultMirror);

                Navigator.pop(context, true);
              },
              child:
                  const Text('Discard').textColor(colorScheme.inverseSurface),
            ),
            const Spacer(),
            TextButton(
              style: buttonStyle,
              onPressed: notAllowed || nameController.text.isEmpty
                  ? null
                  : () async {
                      final selectedConfig = ref.read(newOrEditConfigProvider)!;

                      var currentConfig = selectedConfig;

                      currentConfig = currentConfig.copyWith(
                          configName: nameController.text);

                      if (nameExist) {
                        final allConfigs = ref.read(configsProvider);
                        final toRemove = allConfigs
                            .firstWhere((e) => e.id == currentConfig.id);
                        ref
                            .read(configsProvider.notifier)
                            .overwriteConfig(toRemove, currentConfig);
                      } else {
                        final allConfigs = ref.read(configsProvider);

                        if (allConfigs
                            .where((c) => c.id == currentConfig.id)
                            .isNotEmpty) {
                          final allConfigs = ref.read(configsProvider);
                          final toRemove = allConfigs
                              .firstWhere((e) => e.id == currentConfig.id);
                          ref
                              .read(configsProvider.notifier)
                              .overwriteConfig(toRemove, currentConfig);
                        } else {
                          ref
                              .read(configsProvider.notifier)
                              .addConfig(currentConfig);
                        }
                      }

                      ref.read(selectedConfigProvider.notifier).state =
                          currentConfig;

                      final toSave = ref
                          .read(configsProvider)
                          .where((e) => !defaultConfigs.contains(e))
                          .toList();

                      await ScrcpyUtils.saveConfigs(ref, context, toSave);

                      Navigator.pop(context, true);
                    },
              child: Text(nameExist ? 'Overwrite' : 'Save')
                  .textColor(colorScheme.inverseSurface),
            ),
            const SizedBox(width: 10),
            TextButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No').textColor(colorScheme.inverseSurface),
            ),
          ],
        )
      ],
    );
  }
}
