import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/section_button.dart';

import '../models/scrcpy_related/scrcpy_config.dart';
import '../providers/theme_provider.dart';
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
    final settings = ref.watch(appThemeProvider);

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
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(settings.widgetRadius),
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
    final settings = ref.watch(appThemeProvider);

    return CustomDropdown.search(
      //decoration
      decoration: CustomDropdownDecoration(
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        expandedBorderRadius:
            BorderRadius.circular(settings.widgetRadius * 0.8),
        closedBorderRadius: BorderRadius.circular(settings.widgetRadius * 0.8),
        // expandedBorder: Border.all(
        //     color: Theme.of(context).colorScheme.inversePrimary, width: 5),
        listItemDecoration: ListItemDecoration(
          selectedColor: Theme.of(context).colorScheme.onPrimary,
        ),
        closedFillColor: Theme.of(context).colorScheme.onPrimary,
        expandedFillColor: Theme.of(context).colorScheme.onPrimary,
        expandedBorder: Border.all(
            color: Theme.of(context).colorScheme.onPrimary, width: 4),
      ),
      listItemPadding: const EdgeInsets.all(0),
      itemsListPadding: const EdgeInsets.only(right: 4),
      //items
      headerBuilder: (context, selectedItem, enabled) => Row(
        children: [
          Text(selectedItem.configName),
          const Spacer(),
          ConfigVisualizer(conf: selectedItem)
        ],
      ),
      listItemBuilder: (context, item, isSelected, onItemSelect) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
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
              Text(item == newConfig ? 'Create new config' : item.configName),
              const Spacer(),
              if (item != newConfig) ConfigVisualizer(conf: item),
            ],
          ),
        ),
      ),
      initialItem: ref.watch(selectedConfigProvider),
      items: allConfigs,
      onChanged: (config) {
        ref.read(selectedConfigProvider.notifier).state = config!;

        if (config == newConfig) {
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
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
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
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          PageTransition(
                            child: const ConfigScreen(),
                            type: PageTransitionType.rightToLeft,
                          ),
                        ).then(
                          (value) => ref
                              .read(configToEditProvider.notifier)
                              .state = null,
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
                      final lastUsed = await ScrcpyUtils.getLastUsedConfig();
                      ref
                          .read(configsProvider.notifier)
                          .removeConfig(selectedConfig);

                      ref.read(selectedConfigProvider.notifier).state =
                          defaultMirror;

                      if (ref.read(selectedConfigProvider) == lastUsed) {
                        await ScrcpyUtils.saveLastUsedConfig(defaultMirror);
                      }

                      final toSave = ref
                          .read(configsProvider)
                          .where((e) => !defaultConfigs.contains(e))
                          .toList();

                      ScrcpyUtils.saveConfigs(ref, toSave);
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
