import 'package:flutter/material.dart' show kToolbarHeight;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../widgets/custom_ui/pg_list_tile.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../../../widgets/home/widgets/pinned_app_display.dart';

final FocusNode searchBoxFocusNode = FocusNode();

class BigControlPage extends ConsumerStatefulWidget {
  final AdbDevices device;
  const BigControlPage({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BigControlPageState();
}

class _BigControlPageState extends ConsumerState<BigControlPage> {
  TextEditingController appSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(controlPageConfigProvider);
    final size = MediaQuery.sizeOf(context);
    final device = widget.device;
    final allConfigs = ref.watch(configsProvider);
    final appsList = device.info?.appList ?? [];
    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final filteredList = appsList
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        SizedBox(
          height: size.height - kToolbarHeight - 32,
          width: appWidth,
          child: _leftColumn(device),
        ),
        SizedBox(
          height: size.height - kToolbarHeight - 32,
          width: appWidth,
          child: PgSectionCardNoScroll(
            label: 'All apps',
            content: SizedBox(
              height: size.height - kToolbarHeight - 32 - 112,
              width: appWidth,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('${el.deviceControlDialogLoc.onConfig.label}:')
                            .textSmall,
                        Row(
                          children: [
                            Expanded(
                              child: Select<ScrcpyConfig>(
                                filled: true,
                                placeholder: Text('Config to start app on'),
                                value: config,
                                onChanged: (value) {
                                  ref
                                      .read(controlPageConfigProvider.notifier)
                                      .state = value;
                                },
                                popup: SelectPopup(
                                  items: SelectItemList(
                                      children: allConfigs
                                          .map((c) => SelectItemButton(
                                              value: c,
                                              child: Text(c.configName)))
                                          .toList()),
                                ).call,
                                itemBuilder: (context, value) =>
                                    Text(value.configName),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Text('Search app:').textSmall,
                        TextField(
                          filled: true,
                          placeholder: Text("Press '/' to search"),
                          focusNode: searchBoxFocusNode,
                          controller: appSearchController,
                          onChanged: (value) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                    itemBuilder: (context, index) {
                      final app = filteredList[index];
                      return AppListTile(app: app, config: config);
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: filteredList.length,
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _leftColumn(AdbDevices device) {
    return Column(
      spacing: 8,
      children: [
        ControlButtons(device: device),
        PgSectionCardNoScroll(
            label: 'Pinned apps', content: PinnedAppDisplay(device: device)),
      ],
    );
  }
}

class AppListTile extends StatefulWidget {
  final ScrcpyApp app;
  final ScrcpyConfig? config;

  const AppListTile({
    super.key,
    required this.app,
    required this.config,
  });

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final config = widget.config;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PgListTile(
        title: app.name,
        subtitle: app.packageName,
        showSubtitle: true,
        trailing: Row(
          children: [
            IconButton.ghost(
                icon: Icon(Icons.push_pin_rounded),
                onPressed: config == null ? null : () {}),
            IconButton.ghost(
                icon: Icon(Icons.play_arrow_rounded),
                onPressed: config == null ? null : () {}),
          ],
        ),
      ),
    );
  }
}
