import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../db/db.dart';
import '../../../../../models/adb_devices.dart';
import '../../../../../models/app_config_pair.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import '../../../../../providers/app_config_pair_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../../../widgets/home/widgets/pinned_app_display.dart';

class SmallControlPage extends ConsumerStatefulWidget {
  const SmallControlPage({
    super.key,
    required this.device,
  });

  final AdbDevices device;

  @override
  ConsumerState<SmallControlPage> createState() => _SmallControlPageState();
}

class _SmallControlPageState extends ConsumerState<SmallControlPage> {
  ScrcpyApp? selectedApp;
  bool loading = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final appsList = device.info?.appList ?? [];
    final selectedConfig = ref.watch(controlPageConfigProvider);
    final allconfigs = ref.watch(filteredConfigsProvider);
    final appConfigPairs = ref.watch(appConfigPairProvider
        .select((pair) => pair.where((p) => p.deviceId == device.id)));

    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    bool isPinned = false;

    if (selectedApp != null && selectedConfig != null) {
      isPinned = appConfigPairs.contains(AppConfigPair(
          deviceId: device.id, app: selectedApp!, config: selectedConfig));
    }

    return Column(
      spacing: 8,
      children: [
        Expanded(
          child: Column(
            spacing: 8,
            children: [
              ControlButtons(device: device),
              Expanded(
                  child: PgSectionCardNoScroll(
                      // expandContent: true,
                      label: el.loungeLoc.pinnedApps.label,
                      content: appConfigPairs.isEmpty
                          ? Center(
                              child: Text(el.loungeLoc.info.emptyPin)
                                  .textSmall
                                  .muted,
                            )
                          : PinnedAppDisplay(device: widget.device))),
            ],
          ),
        ),
        PgSectionCardNoScroll(
          label: el.loungeLoc.launcher.label,
          labelTrail: Row(
            spacing: 8,
            children: [
              if (selectedApp != null && selectedConfig != null && !isPinned)
                Tooltip(
                  tooltip:
                      TooltipContainer(child: Text(el.loungeLoc.tooltip.pin))
                          .call,
                  child: GhostButton(
                    density: ButtonDensity.dense,
                    child: Icon(Icons.push_pin).iconSmall(),
                    onPressed: () {
                      final pair = AppConfigPair(
                          deviceId: widget.device.id,
                          app: selectedApp!,
                          config: selectedConfig);
                      ref
                          .read(appConfigPairProvider.notifier)
                          .addOrEditPair(pair);
                      Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
                    },
                  ),
                ),
              if (selectedApp != null && selectedConfig != null)
                PrimaryButton(
                  density: ButtonDensity.dense,
                  onPressed: loading
                      ? null
                      : () async {
                          loading = true;
                          setState(() {});
                          await ScrcpyUtils.newInstance(
                            ref,
                            selectedDevice: widget.device,
                            selectedConfig: selectedConfig.copyWith(
                              appOptions: (selectedConfig.appOptions)
                                  .copyWith(selectedApp: selectedApp),
                            ),
                            customInstanceName:
                                '${selectedApp!.name} (${selectedConfig.configName})',
                          );

                          if (mounted) {
                            loading = false;
                            setState(() {});
                          }
                        },
                  child: Text(el.configLoc.start),
                ),
            ],
          ),
          content: Column(
            children: [
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: Select<ScrcpyConfig>(
                      filled: true,
                      itemBuilder: (context, value) => Text(value.configName),
                      onChanged: (config) {
                        ref.read(controlPageConfigProvider.notifier).state =
                            config;
                      },
                      placeholder: Text(el.loungeLoc.placeholders.config),
                      value: selectedConfig,
                      popup: SelectPopup(
                        items: SelectItemList(
                          children: allconfigs
                              .where((e) => !e.windowOptions.noWindow)
                              .map((config) => SelectItemButton(
                                    value: config,
                                    child: Text(config.configName),
                                  ))
                              .toList(),
                        ),
                      ).call,
                    ),
                  ),
                  Expanded(
                    child: Select(
                      filled: true,
                      value: selectedApp,
                      placeholder: Text(el.loungeLoc.placeholders.app),
                      popupConstraints:
                          BoxConstraints(maxHeight: appWidth - 100),
                      onChanged: (app) {
                        selectedApp = app!;
                        setState(() {});
                      },
                      popup: SelectPopup.builder(
                        searchPlaceholder: Text('Search'),
                        builder: (context, searchQuery) {
                          return SelectItemList(
                            children: appsList
                                .where((app) => app.name
                                    .toLowerCase()
                                    .contains(searchQuery?.toLowerCase() ?? ''))
                                .map((e) => SelectItemButton(
                                    value: e,
                                    child: OverflowMarquee(
                                        duration: 2.seconds,
                                        delayDuration: 0.5.seconds,
                                        child: Text(e.name))))
                                .toList(),
                          );
                        },
                      ).call,
                      itemBuilder: (context, value) => OverflowMarquee(
                          duration: 2.seconds,
                          delayDuration: 0.5.seconds,
                          child: Text(value.name)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
