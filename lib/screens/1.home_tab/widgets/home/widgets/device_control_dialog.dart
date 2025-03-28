import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/app_config_pair.dart';
import 'package:scrcpygui/models/device_key.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/app_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/app_config_pair_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'pinned_app_display.dart';

class ControlDialog extends ConsumerStatefulWidget {
  final AdbDevices device;
  const ControlDialog(this.device, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ControlDialogState();
}

class _ControlDialogState extends ConsumerState<ControlDialog> {
  bool loading = false;
  bool gettingInfo = false;
  ScrcpyApp? selectedApp;
  ScrcpyConfig? selectedConfig;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      final workDir = ref.read(execDirProvider);
      if (widget.device.info == null) {
        gettingInfo = true;
        setState(() {});
        final info = await AdbUtils.getScrcpyDetailsFor(workDir, widget.device);
        ref
            .read(savedAdbDevicesProvider.notifier)
            .addEditDevices(widget.device.copyWith(info: info));

        await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));

        if (mounted) {
          gettingInfo = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(adbProvider);
    final allconfigs = ref.read(configsProvider);
    final size = MediaQuery.sizeOf(context);
    final appConfigPairs = ref.watch(appConfigPairProvider
        .select((pair) => pair.where((p) => p.deviceId == widget.device.id)));

    final appslist = widget.device.info?.appList ?? [];

    appslist
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final dev =
        connected.firstWhereOrNull((conn) => conn.id == widget.device.id);

    if (dev == null) context.pop();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: appWidth),
      child: AlertDialog(
        title: Row(
          spacing: 8,
          children: [
            if (dev!.id.isIpv4 || dev.id.contains(adbMdns))
              Icon(Icons.wifi_rounded),
            Text(widget.device.name ?? widget.device.modelName),
            Text(widget.device.id.replaceAll('.$adbMdns', '')).xSmall().muted(),
          ],
        ),
        content: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: appWidth, maxHeight: size.height - 161),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 0,
              children: [
                if (appConfigPairs.isNotEmpty)
                  PgSectionCard(
                    label: 'Pinned (${appConfigPairs.length}/6)',
                    children: [PinnedAppDisplay(device: widget.device)],
                  ),
                PgSectionCard(
                  label: el.deviceControlDialogLoc.controls,
                  children: [
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: _buttonList(),
                      ),
                    ),
                  ],
                ),
                if (widget.device.info != null)
                  PgSectionCard(
                    label: el.appSection.title,
                    children: [
                      Text('${el.configLoc.start}:'),
                      Select(
                        filled: true,
                        value: selectedApp,
                        placeholder: Text(el.appSection.select.label),
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
                              children: appslist
                                  .where((app) => app.name
                                      .toLowerCase()
                                      .contains(
                                          searchQuery?.toLowerCase() ?? ''))
                                  .map((e) => SelectItemButton(
                                      value: e, child: Text(e.name)))
                                  .toList(),
                            );
                          },
                        ).call,
                        itemBuilder: (context, value) => Text(value.name),
                      ),
                      Text('${el.deviceControlDialogLoc.onConfig.label}:'),
                      Select(
                        filled: true,
                        itemBuilder: (context, value) => Text(value.configName),
                        onChanged: selectedApp == null
                            ? null
                            : (config) {
                                selectedConfig = config as ScrcpyConfig?;

                                setState(() {});
                              },
                        placeholder: Text(
                            el.deviceControlDialogLoc.onConfig.ddPlaceholder),
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
                    ],
                  ),
              ],
            ),
          ),
        ),
        actions: [
          if (selectedApp != null &&
              selectedConfig != null &&
              appConfigPairs.length < 6)
            Tooltip(
              tooltip:
                  const TooltipContainer(child: Text('Pin app/config pair'))
                      .call,
              child: IconButton(
                density: ButtonDensity.icon,
                variance: ButtonVariance.secondary,
                icon: Icon(Icons.push_pin).iconSmall(),
                onPressed: () {
                  final pair = AppConfigPair(
                      deviceId: widget.device.id,
                      app: selectedApp!,
                      config: selectedConfig!);
                  ref.read(appConfigPairProvider.notifier).addOrEditPair(pair);
                  Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
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
                        selectedConfig: selectedConfig!.copyWith(
                          appOptions: (selectedConfig!.appOptions ??
                                  SAppOptions(forceClose: false))
                              .copyWith(selectedApp: selectedApp),
                        ),
                        customInstanceName:
                            '${selectedApp!.name} (${selectedConfig!.configName})',
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
          SecondaryButton(
            child: Text(el.buttonLabelLoc.close),
            onPressed: () => context.pop(),
          )
        ],
      ),
    );
  }

  _buttonList() {
    final workDir = ref.read(execDirProvider);
    return [
      DestructiveButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.power_settings_new_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.power),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.back),
        child: const Icon(Icons.arrow_back_rounded),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.home_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.home),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.history_rounded),
        onPressed: () => widget.device.sendKeyEvent(workDir, DeviceKey.recent),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.skip_previous_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaPrevious),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.play_arrow_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.playPause),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.skip_next_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.mediaNext),
      ),
      VerticalDivider().sized(height: 20),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.volume_down_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.volumeDown),
      ),
      SecondaryButton(
        density: ButtonDensity.icon,
        child: const Icon(Icons.volume_up_rounded),
        onPressed: () =>
            widget.device.sendKeyEvent(workDir, DeviceKey.volumeUp),
      ),
    ];
  }
}
