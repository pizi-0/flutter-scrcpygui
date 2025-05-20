import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/app_config_pair.dart';
import 'package:scrcpygui/providers/app_config_pair_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/device_control_page.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
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

class BigControlPage2 extends ConsumerStatefulWidget {
  final AdbDevices device;
  const BigControlPage2({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BigControlPage2State();
}

class _BigControlPage2State extends ConsumerState<BigControlPage2> {
  TextEditingController appSearchController = TextEditingController();
  ScrollController appScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(controlPageConfigProvider);

    final device = widget.device;
    final allConfigs = ref.watch(configsProvider);
    final appsList = device.info?.appList ?? [];
    appsList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final filteredList =
        appsList.where((app) => app.name.toLowerCase().contains(appSearchController.text.toLowerCase())).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
      child: Column(
        spacing: 8,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ControlButtons(device: device),
              PgSectionCardNoScroll(label: 'Pinned apps', content: PinnedAppDisplay(device: device)),
            ],
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Text('All apps ').textSmall,
                    ],
                  ).paddingVertical(8),
                  Expanded(
                    child: Scrollbar(
                      controller: appScrollController,
                      child: Card(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: CustomScrollView(
                            controller: appScrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    spacing: 8,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Config to start app on:').textSmall,
                                      Expanded(
                                        child: Select<ScrcpyConfig>(
                                          filled: true,
                                          placeholder: Text('Select config'),
                                          value: config,
                                          onChanged: (value) {
                                            ref.read(controlPageConfigProvider.notifier).state = value;
                                          },
                                          popup: SelectPopup(
                                            items: SelectItemList(
                                                children: allConfigs
                                                    .map((c) => SelectItemButton(value: c, child: Text(c.configName)))
                                                    .toList()),
                                          ).call,
                                          itemBuilder: (context, value) => Text(value.configName),
                                        ),
                                      ),
                                      SizedBox(height: 20, child: VerticalDivider()),
                                      Text('Search:').textSmall,
                                      Expanded(
                                        child: TextField(
                                          filled: true,
                                          placeholder: Text("Press '/' to search"),
                                          focusNode: searchBoxFocusNode,
                                          controller: appSearchController,
                                          onChanged: (value) => setState(() {}),
                                          onSubmitted: (value) {
                                            controlPageKeyboardListenerNode.requestFocus();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(),
                                ),
                              ),
                              SliverGrid.builder(
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 120,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 16 / 8),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final app = filteredList[index];

                                  return Tooltip(
                                    tooltip: TooltipContainer(
                                        child: Text(
                                      '${app.name}\n${app.packageName}',
                                      textAlign: TextAlign.center,
                                    )).call,
                                    child: AppGridTile(ref: ref, app: app, device: widget.device),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppGridTile extends ConsumerStatefulWidget {
  const AppGridTile({
    super.key,
    required this.ref,
    required this.device,
    required this.app,
  });

  final WidgetRef ref;
  final AdbDevices device;
  final ScrcpyApp app;

  @override
  ConsumerState<AppGridTile> createState() => _AppGridTileState();
}

class _AppGridTileState extends ConsumerState<AppGridTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(controlPageConfigProvider);

    return ContextMenu(
      items: [
        MenuButton(
          enabled: config != null,
          onPressed: (context) async {
            controlPageKeyboardListenerNode.requestFocus();
            ref
                .read(appConfigPairProvider.notifier)
                .addOrEditPair(AppConfigPair(deviceId: widget.device.id, app: widget.app, config: config!));

            await Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
          },
          leading: Icon(Icons.push_pin_rounded),
          child: Text('Pin'),
        ),
        MenuButton(
          enabled: config != null,
          onPressed: (context) async {
            loading = true;
            setState(() {});

            controlPageKeyboardListenerNode.requestFocus();
            await ScrcpyUtils.newInstance(widget.ref,
                selectedConfig:
                    config!.copyWith(appOptions: config.appOptions.copyWith(selectedApp: widget.app, forceClose: true)),
                selectedDevice: widget.device);

            if (mounted) {
              loading = false;
              setState(() {});
            }
          },
          leading: Icon(Icons.play_arrow_rounded),
          child: Text('Force close & start'),
        ),
      ],
      child: Button.secondary(
          onPressed: loading || config == null
              ? null
              : () async {
                  loading = true;
                  setState(() {});

                  controlPageKeyboardListenerNode.requestFocus();
                  await ScrcpyUtils.newInstance(widget.ref,
                      selectedConfig: config.copyWith(appOptions: config.appOptions.copyWith(selectedApp: widget.app)),
                      selectedDevice: widget.device);

                  if (mounted) {
                    loading = false;
                    setState(() {});
                  }
                },
          child: Text(
            widget.app.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).textAlignment(TextAlign.center)),
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
            IconButton.ghost(icon: Icon(Icons.push_pin_rounded), onPressed: config == null ? null : () {}),
            IconButton.ghost(icon: Icon(Icons.play_arrow_rounded), onPressed: config == null ? null : () {}),
          ],
        ),
      ),
    );
  }
}
