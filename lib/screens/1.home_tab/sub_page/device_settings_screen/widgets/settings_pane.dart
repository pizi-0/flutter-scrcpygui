import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/device_info_model.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/device_settings_state_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../../models/automation.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../providers/device_info_provider.dart';
import '../../../../../widgets/config_tiles.dart';

class SettingsPane extends ConsumerStatefulWidget {
  final TextEditingController nameController;
  final bool expandContent;
  final AdbDevices device;
  const SettingsPane({
    super.key,
    this.expandContent = false,
    required this.device,
    required this.nameController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPaneState();
}

class _SettingsPaneState extends ConsumerState<SettingsPane> {
  FocusNode textBox = FocusNode();

  @override
  Widget build(BuildContext context) {
    final dev = widget.device;
    final state = ref.watch(deviceSettingsStateProvider(dev));

    final allconfigs = ref.watch(configsProvider);

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    return PgSectionCardNoScroll(
      label: el.deviceSettingsLoc.title,
      expandContent: widget.expandContent,
      content: widget.expandContent
          ? CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    spacing: 8,
                    children: [
                      _textbox(deviceInfo, dev),
                      if (dev.id.isIpv4 || dev.id.contains(':')) ...[
                        const Divider(),
                        _autoConnectToggle(),
                      ],
                      const Divider(),
                      _onConnectedSelect(allconfigs),
                      _configsSelect(allconfigs, dev),
                      const Divider(),
                    ],
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  spacing: 8,
                  children: [
                    _textbox(deviceInfo, dev),
                    if (dev.id.isIpv4 || dev.id.contains(':')) ...[
                      const Divider(),
                      _autoConnectToggle(),
                    ],
                    const Divider(),
                    _onConnectedSelect(allconfigs),
                    if (state.autoLaunch) Gap(2)
                  ],
                ),
                _configsSelect(allconfigs, dev),
              ],
            ),
    );
  }

  PgExpandable _configsSelect(List<ScrcpyConfig> allconfigs, AdbDevices dev) {
    final state = ref.watch(deviceSettingsStateProvider(dev));
    final theme = Theme.of(context);

    return PgExpandable(
        expand: state.autoLaunch,
        child: OutlinedContainer(
          backgroundColor: state.autoLaunch ? theme.colorScheme.accent : null,
          borderRadius: theme.borderRadiusMd,
          padding: EdgeInsets.all(2),
          child: Card(
            borderRadius: theme.borderRadiusMd,
            padding: EdgeInsets.all(4),
            child: GridView.builder(
              itemCount: allconfigs.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisExtent: 28,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final config = allconfigs[index];
                final selected = state.autoLaunchConfig
                    .where((a) => a.configId == config.id)
                    .isNotEmpty;

                return Chip(
                  style: selected
                      ? ButtonStyle.primary()
                          .withBorderRadius(borderRadius: theme.borderRadiusSm)
                      : ButtonStyle.secondary()
                          .withBorderRadius(borderRadius: theme.borderRadiusSm),
                  onPressed: () {
                    final ca =
                        ConfigAutomation(deviceId: dev.id, configId: config.id);

                    ref
                        .read(deviceSettingsStateProvider(dev).notifier)
                        .toggleConfig(ca);
                  },
                  child: OverflowMarquee(child: Text(config.configName)),
                );
              },
            ),
          ),
        ));
  }

  ConfigCustom _onConnectedSelect(List<ScrcpyConfig> allconfigs) {
    final state = ref.watch(deviceSettingsStateProvider(widget.device));

    return ConfigCustom(
      dimTitle: false,
      title: el.deviceSettingsLoc.onConnected.label,
      subtitle: el.deviceSettingsLoc.onConnected.info,
      child: Select(
        enabled: !state.loading,
        filled: true,
        placeholder: Text(el.deviceSettingsLoc.doNothing),
        itemBuilder: (context, value) => Text(state.autoLaunch
            ? el.configLoc.start
            : el.deviceSettingsLoc.doNothing),
        value: state.autoLaunch,
        onChanged: (value) => _onAutoLaunchToggled(),
        popup: SelectPopup(
          items: SelectItemList(children: [
            SelectItemButton(
              value: false,
              child: Text(el.deviceSettingsLoc.doNothing),
            ),
            SelectItemButton(
              value: true,
              child: Text(el.configLoc.start),
            ),
          ]),
        ).call,
      ),
    );
  }

  ConfigCustom _autoConnectToggle() {
    final state = ref.watch(deviceSettingsStateProvider(widget.device));

    return ConfigCustom(
      onPressed: state.loading ? null : _onAutoConnectToggled,
      title: el.deviceSettingsLoc.autoConnect.label,
      subtitle: el.deviceSettingsLoc.autoConnect.info,
      childExpand: false,
      child: Checkbox(
        enabled: !state.loading,
        state:
            state.autoConnect ? CheckboxState.checked : CheckboxState.unchecked,
        onChanged: (val) => _onAutoConnectToggled(),
      ),
    );
  }

  ConfigCustom _textbox(DeviceInfo? deviceInfo, AdbDevices dev) {
    final state = ref.watch(deviceSettingsStateProvider(dev));

    return ConfigCustom(
      dimTitle: false,
      title: el.deviceSettingsLoc.rename.label,
      subtitle: el.deviceSettingsLoc.rename.info,
      child: SizedBox(
        width: 180,
        child: TextField(
          enabled: !state.loading,
          filled: true,
          focusNode: textBox,
          placeholder: Text(deviceInfo?.deviceName ?? dev.modelName),
          controller: widget.nameController,
          onSubmitted: _onTextBoxSubmit,
          onChanged: (value) =>
              ref.read(deviceSettingsStateProvider(dev).notifier).rename(value),
        ),
      ),
    );
  }

  void _onAutoLaunchToggled() async {
    ref
        .read(deviceSettingsStateProvider(widget.device).notifier)
        .toggleAutoLaunch();
  }

  void _onTextBoxSubmit(String value) async {
    textBox.unfocus();
    ref.read(deviceSettingsStateProvider(widget.device).notifier).rename(value);
  }

  void _onAutoConnectToggled() async {
    ref
        .read(deviceSettingsStateProvider(widget.device).notifier)
        .toggleAutoConnect();
  }
}
