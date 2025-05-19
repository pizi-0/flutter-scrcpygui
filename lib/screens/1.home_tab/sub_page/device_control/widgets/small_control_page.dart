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
    final appsList = widget.device.info?.appList ?? [];
    final selectedConfig = ref.watch(controlPageConfigProvider);
    final allconfigs = ref.watch(configsProvider);
    final appConfigPairs = ref.watch(appConfigPairProvider
        .select((pair) => pair.where((p) => p.deviceId == widget.device.id)));

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        spacing: 8,
        children: [
          ControlButtons(device: widget.device),
          PgSectionCardNoScroll(
              label: 'Pinned apps',
              content: PinnedAppDisplay(device: widget.device)),
          PgSectionCard(
            label: el.appSection.title,
            children: [
              Text('${el.configLoc.start}:').textSmall,
              Select(
                filled: true,
                value: selectedApp,
                placeholder: Text(el.appSection.select.label),
                popupConstraints: BoxConstraints(maxHeight: appWidth - 100),
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
                          .map((e) =>
                              SelectItemButton(value: e, child: Text(e.name)))
                          .toList(),
                    );
                  },
                ).call,
                itemBuilder: (context, value) => Text(value.name),
              ),
              Text('${el.deviceControlDialogLoc.onConfig.label}:').textSmall,
              Select<ScrcpyConfig>(
                filled: true,
                itemBuilder: (context, value) => Text(value.configName),
                onChanged: selectedApp == null
                    ? null
                    : (config) {
                        ref.read(controlPageConfigProvider.notifier).state =
                            config;
                      },
                placeholder:
                    Text(el.deviceControlDialogLoc.onConfig.ddPlaceholder),
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
              if (selectedApp != null &&
                  selectedConfig != null &&
                  appConfigPairs.length < 6)
                Divider(),
              Row(
                spacing: 8,
                children: [
                  if (selectedApp != null &&
                      selectedConfig != null &&
                      appConfigPairs.length < 6)
                    Tooltip(
                      tooltip: const TooltipContainer(
                              child: Text('Pin app/config pair'))
                          .call,
                      child: IconButton(
                        density: ButtonDensity.icon,
                        variance: ButtonVariance.secondary,
                        icon: Icon(Icons.push_pin).iconSmall(),
                        onPressed: () {
                          final pair = AppConfigPair(
                              deviceId: widget.device.id,
                              app: selectedApp!,
                              config: selectedConfig);
                          ref
                              .read(appConfigPairProvider.notifier)
                              .addOrEditPair(pair);
                          Db.saveAppConfigPairs(
                              ref.read(appConfigPairProvider));
                        },
                      ),
                    ),
                  Spacer(),
                  if (selectedApp != null && selectedConfig != null)
                    PrimaryButton(
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
                      child: loading
                          ? CircularProgressIndicator()
                          : Text(el.configLoc.start),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
