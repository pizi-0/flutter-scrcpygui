// ignore_for_file: use_build_context_synchronously

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/section_button.dart';
import 'package:uuid/uuid.dart';

import '../models/scrcpy_related/scrcpy_config.dart';
import '../providers/settings_provider.dart';
import '../utils/const.dart';
import 'config_visualizer.dart';
import 'custom_filename_input.dart';
import 'start_stop_button.dart';

class ConfigSelector extends ConsumerStatefulWidget {
  const ConfigSelector({super.key});

  @override
  ConsumerState<ConfigSelector> createState() => _ConfigSelectorState();
}

class _ConfigSelectorState extends ConsumerState<ConfigSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final allConfigs = ref.watch(configsProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: appWidth,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: selectedDevice == null ? 0 : 206,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, allConfigs, selectedDevice),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(appTheme.widgetRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(ref, context, allConfigs),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const CustomFileName(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomDropdown<ScrcpyConfig> _buildDropdown(
      WidgetRef ref, BuildContext context, List<ScrcpyConfig> allConfigs) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;
    final allconfigs = ref.watch(configsProvider);

    return CustomDropdown.search(
      //decoration
      decoration: CustomDropdownDecoration(
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: colorScheme.inversePrimary,
        ),
        expandedBorderRadius:
            BorderRadius.circular(appTheme.widgetRadius * 0.8),
        closedBorderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.8),
        // expandedBorder: Border.all(
        //     color: colorScheme.inversePrimary, width: 5),
        // listItemDecoration: ListItemDecoration(
        //   selectedColor: colorScheme.onPrimary,
        // ),
        closedFillColor: colorScheme.secondaryContainer,
        expandedFillColor: colorScheme.secondaryContainer,
      ),
      listItemPadding: const EdgeInsets.all(0),
      itemsListPadding: const EdgeInsets.only(right: 4),
      //items
      headerBuilder: (context, selectedItem, enabled) => Row(
        children: [
          Text(ref.watch(selectedConfigProvider).configName)
              .textColor(colorScheme.inverseSurface),
          const Spacer(),
          ConfigVisualizer(conf: selectedItem),
        ],
      ),
      listItemBuilder: (context, item, isSelected, onItemSelect) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (item == newConfig)
                const Row(
                  children: [
                    Icon(Icons.add_circle_outline_rounded),
                    SizedBox(width: 10),
                  ],
                ),
              Text(item == newConfig ? 'Create new config' : item.configName)
                  .textColor(colorScheme.inverseSurface),
              const Spacer(),
              if (item != newConfig) ConfigVisualizer(conf: item),
            ],
          ),
        ),
      ),
      initialItem: ref.watch(selectedConfigProvider),
      items: allconfigs,
      onChanged: (config) {
        ref.read(selectedConfigProvider.notifier).state = config!;

        if (config == newConfig) {
          final id = const Uuid().v1();
          ref.read(newOrEditConfigProvider.notifier).state = newConfig.copyWith(
            id: id,
            configName: 'My config',
          );

          Navigator.push(
            context,
            PageTransition(
              child: const ConfigScreen(),
              type: PageTransitionType.rightToLeft,
            ),
          );
        }
      },
    );
  }

  Row _sectionTitle(BuildContext context, List<ScrcpyConfig> allConfigs,
      AdbDevices? selectedDevice) {
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Config',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            SectionButton(
              tooltipmessage: 'Edit config',
              icondata: Icons.edit,
              ontap: !defaultConfigs.contains(selectedConfig)
                  ? () async {
                      final res = ScrcpyUtils.checkForIncompatibleFlags(ref);

                      bool proceed = res.where((r) => !r.ok).isEmpty;

                      if (proceed == false) {
                        proceed = (await showDialog(
                              context: context,
                              builder: (context) => OverrideDialog(
                                  isEdit: true,
                                  offendingFlags:
                                      res.where((r) => !r.ok).toList()),
                            )) ??
                            false;
                      }

                      if (proceed == true) {
                        ref.read(newOrEditConfigProvider.notifier).state =
                            selectedConfig;

                        Navigator.push(
                          context,
                          PageTransition(
                            child: const ConfigScreen(),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      }
                    }
                  : null,
            ),
            SectionButton(
              tooltipmessage: 'Delete config',
              icondata: Icons.delete,
              ontap: !defaultConfigs.contains(selectedConfig)
                  ? () async {
                      final savedLastUsed =
                          await ScrcpyUtils.getLastUsedConfig(ref);
                      final lastused = ref.read(selectedConfigProvider);
                      ref
                          .read(configsProvider.notifier)
                          .removeConfig(selectedConfig);

                      ref.read(selectedConfigProvider.notifier).state =
                          defaultMirror;

                      if (lastused.id == savedLastUsed.id) {
                        await ScrcpyUtils.saveLastUsedConfig(defaultMirror);
                      }

                      final toSave = ref
                          .read(configsProvider)
                          .where((e) => !defaultConfigs.contains(e))
                          .toList();

                      ScrcpyUtils.saveConfigs(ref, context, toSave);
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
