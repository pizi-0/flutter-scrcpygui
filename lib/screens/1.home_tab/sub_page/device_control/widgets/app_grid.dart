import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/config_override_button.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/app_config_pair_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../widgets/navigation_shell.dart';
import '../device_control_page.dart';
import 'app_grid_icon.dart';
import 'big_control_page.dart';

class AppGrid extends ConsumerStatefulWidget {
  final AdbDevices device;
  final bool persistentHeader;
  const AppGrid(
      {super.key, required this.device, this.persistentHeader = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppGridState();
}

class _AppGridState extends ConsumerState<AppGrid> {
  TextEditingController appSearchController = TextEditingController();
  ScrollController appScrollController = ScrollController();
  double sidebarWidth = 52;

  @override
  void initState() {
    super.initState();
    if (widget.persistentHeader) {
      sidebarWidth = _findSidebarWidth();
    }
  }

  @override
  void dispose() {
    super.dispose();
    appSearchController.dispose();
    appScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final device = widget.device;
    final allConfigs = ref.watch(configsProvider);
    final config = ref.watch(controlPageConfigProvider);
    final overrides = ref.watch(configOverridesProvider);

    final devicePairs = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == device.id)
        .toList();

    final appsList = (device.info?.appList ?? [])
        .where((app) => devicePairs.where((dp) => dp.app == app).isEmpty)
        .toList();

    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    devicePairs.sort(
        (a, b) => a.app.name.toLowerCase().compareTo(b.app.name.toLowerCase()));

    final deviceAppslist = devicePairs.map((p) => p.app).toList();

    final finalList = [...deviceAppslist, ...appsList];

    final filteredList = finalList
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    final filteredDeviceAppslist = deviceAppslist
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    final filteredAppslist = appsList
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    final size = MediaQuery.sizeOf(context);

    return PgSectionCardNoScroll(
      constraints: BoxConstraints(maxWidth: (size.width - sidebarWidth) * 0.5),
      label: el.loungeLoc.launcher.label,
      labelTrail: OverrideButton(
        leading: Text('Overrides'),
        buttonVariance: overrides.isNotEmpty
            ? ButtonVariance.secondary
            : ButtonVariance.ghost,
        buttonDensity: ButtonDensity.dense,
      ),
      expandContent: true,
      content: Column(
        spacing: 8,
        children: [
          if (widget.persistentHeader) ...[
            _buildHeader(config, allConfigs),
            Divider()
          ],
          Expanded(
            child: CustomScrollView(
              controller: appScrollController,
              slivers: [
                if (!widget.persistentHeader) ...[
                  SliverToBoxAdapter(
                    child: Column(
                      spacing: 8,
                      children: [
                        _buildHeader(config, allConfigs),
                        Divider(),
                        SizedBox.shrink()
                      ],
                    ),
                  )
                ],
                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                        child: Text(el.loungeLoc.info.emptySearch)
                            .textSmall
                            .muted),
                  ),
                if (filteredDeviceAppslist.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted,
                          borderRadius: theme.borderRadiusSm,
                        ),
                        child: Text('Pinned').textSmall),
                  ),
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80,
                      mainAxisExtent: 80,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: filteredDeviceAppslist.length,
                    itemBuilder: (context, index) {
                      final app = filteredDeviceAppslist[index];

                      return AppGridIcon(
                          key: ValueKey(app.packageName),
                          ref: ref,
                          app: app,
                          device: widget.device);
                    },
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
                if (filteredAppslist.isNotEmpty) ...[
                  if (deviceAppslist.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted,
                            borderRadius: theme.borderRadiusSm,
                          ),
                          child: Text('Apps').textSmall),
                    ),
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80,
                      mainAxisExtent: 80,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: filteredAppslist.length,
                    itemBuilder: (context, index) {
                      final app = filteredAppslist[index];

                      return AppGridIcon(
                          key: ValueKey(app.packageName),
                          ref: ref,
                          app: app,
                          device: widget.device);
                    },
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeader(ScrcpyConfig? config, List<ScrcpyConfig> allConfigs) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Select<ScrcpyConfig>(
            filled: true,
            placeholder: OverflowMarquee(
                duration: 2.seconds,
                delayDuration: 0.5.seconds,
                child: Text(el.loungeLoc.placeholders.config)),
            value: config,
            onChanged: (value) {
              ref.read(controlPageConfigProvider.notifier).state = value;
            },
            popup: SelectPopup(
              items: SelectItemList(
                  children: allConfigs
                      .where((c) => !c.windowOptions.noWindow)
                      .map((c) => SelectItemButton(
                          value: c,
                          child: OverflowMarquee(
                              duration: 3.seconds,
                              delayDuration: 0.5.seconds,
                              child: Text(c.configName))))
                      .toList()),
            ).call,
            itemBuilder: (context, value) => OverflowMarquee(
                duration: 2.seconds,
                delayDuration: 0.5.seconds,
                child: Text(value.configName)),
          ),
        ),
        Expanded(
          child: TextField(
            padding: EdgeInsets.all(7),
            filled: true,
            placeholder: Text(el.loungeLoc.placeholders.search),
            focusNode: searchBoxFocusNode,
            controller: appSearchController,
            onChanged: (value) => setState(() {}),
            features: [
              if (appSearchController.text.isEmpty)
                InputFeature.leading(Icon(Icons.search_rounded)),
              if (appSearchController.text.isNotEmpty)
                InputFeature.trailing(IconButton(
                    variance: ButtonVariance.link,
                    onPressed: () {
                      appSearchController.clear();
                      controlPageKeyboardListenerNode.requestFocus();

                      setState(() {});
                    },
                    density: ButtonDensity.compact,
                    icon: Icon(Icons.close_rounded)))
            ],
            onSubmitted: (value) {
              controlPageKeyboardListenerNode.requestFocus();
            },
          ),
        )
      ],
    );
  }

  _findSidebarWidth() {
    final box = sidebarKey.currentContext?.findRenderObject();

    if (box != null) {
      return (box as RenderBox).size.width;
    } else {
      return 52;
    }
  }
}
