import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/device_info_model.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../../db/db.dart';
import '../../../../../models/automation.dart';
import '../../../../../providers/automation_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../providers/device_info_provider.dart';
import '../../../../../widgets/config_tiles.dart';
import '../device_settings_screen.dart';

class SettingsPane extends ConsumerStatefulWidget {
  final bool expandContent;
  final AdbDevices device;
  final TextEditingController namecontroller;
  final FocusNode textBox;
  const SettingsPane({
    super.key,
    this.expandContent = false,
    required this.namecontroller,
    required this.textBox,
    required this.device,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPaneState();
}

class _SettingsPaneState extends ConsumerState<SettingsPane> {
  String? autoLaunchConfigId;

  @override
  Widget build(BuildContext context) {
    final dev = widget.device;
    final showInfo = ref.watch(deviceSettingsShowInfo);
    final allconfigs = ref.watch(configsProvider);
    final loading = ref.watch(deviceSettingsLoading);

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    final autoConnect = ref
        .watch(autoConnectProvider)
        .where((a) => a.deviceIp == dev.id)
        .isNotEmpty;

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
                      _textbox(showInfo, deviceInfo, dev),
                      if (dev.id.isIpv4 || dev.id.isIpv6) const Divider(),
                      if (dev.id.isIpv4 || dev.id.isIpv6)
                        _autoConnectToggle(autoConnect, showInfo),
                      const Divider(),
                      _onConnectedSelect(showInfo, loading, allconfigs),
                      const Divider(),
                    ],
                  ),
                )
              ],
            )
          : Column(
              spacing: 8,
              children: [
                _textbox(showInfo, deviceInfo, dev),
                if (dev.id.isIpv4 || dev.id.isIpv6) const Divider(),
                if (dev.id.isIpv4 || dev.id.isIpv6)
                  _autoConnectToggle(autoConnect, showInfo),
                const Divider(),
                _onConnectedSelect(showInfo, loading, allconfigs),
              ],
            ),
    );
  }

  ConfigCustom _onConnectedSelect(
      bool showInfo, bool loading, List<ScrcpyConfig> allconfigs) {
    return ConfigCustom(
      dimTitle: false,
      title: el.deviceSettingsLoc.onConnected.label,
      subtitle: el.deviceSettingsLoc.onConnected.info,
      showinfo: showInfo,
      child: Select(
        enabled: !loading,
        filled: true,
        placeholder: Text(el.deviceSettingsLoc.doNothing),
        itemBuilder: (context, value) => Text(
          allconfigs.where((conf) => conf.id == value).isNotEmpty
              ? allconfigs.firstWhere((conf) => conf.id == value).configName
              : el.deviceSettingsLoc.doNothing,
        ),
        value: autoLaunchConfigId,
        onChanged: _onConnectConfig,
        popup: SelectPopup(
          items: SelectItemList(children: [
            SelectItemButton(
              value: DO_NOTHING,
              child: Text(el.deviceSettingsLoc.doNothing),
            ),
            ...allconfigs.map(
                (c) => SelectItemButton(value: c.id, child: Text(c.configName)))
          ]),
        ).call,
      ),
    );
  }

  ConfigCustom _autoConnectToggle(bool autoConnect, bool showInfo) {
    final loading = ref.watch(deviceSettingsLoading);

    return ConfigCustom(
      onPressed: () => _onAutoConnectToggled(autoConnect),
      title: el.deviceSettingsLoc.autoConnect.label,
      subtitle: el.deviceSettingsLoc.autoConnect.info,
      showinfo: showInfo,
      childExpand: false,
      child: Checkbox(
        enabled: !loading,
        state: autoConnect ? CheckboxState.checked : CheckboxState.unchecked,
        onChanged: (val) => _onAutoConnectToggled(autoConnect),
      ),
    );
  }

  ConfigCustom _textbox(bool showInfo, DeviceInfo? deviceInfo, AdbDevices dev) {
    final loading = ref.watch(deviceSettingsLoading);

    return ConfigCustom(
      dimTitle: false,
      title: el.deviceSettingsLoc.rename.label,
      subtitle: el.deviceSettingsLoc.rename.info,
      showinfo: showInfo,
      child: SizedBox(
        width: 180,
        child: TextField(
          enabled: !loading,
          filled: true,
          focusNode: widget.textBox,
          placeholder: Text(deviceInfo?.deviceName ?? dev.modelName),
          controller: widget.namecontroller,
          onSubmitted: _onTextBoxSubmit,
        ),
      ),
    );
  }

  void _onConnectConfig(String? value) async {
    final autoLaunchNotifier = ref.read(autoLaunchProvider.notifier);
    final dev = widget.device;

    if (value == null) {
      return;
    }

    if (value != DO_NOTHING) {
      if (autoLaunchConfigId == null) {
        autoLaunchNotifier
            .add(ConfigAutomation(deviceId: dev.id, configId: value));
      } else {
        autoLaunchNotifier.remove(dev.id);
        autoLaunchNotifier
            .add(ConfigAutomation(deviceId: dev.id, configId: value));
      }

      autoLaunchConfigId = value;
    } else {
      autoLaunchNotifier.remove(dev.id);
      autoLaunchConfigId = null;
    }

    await Db.saveAutoLaunch(ref.read(autoLaunchProvider));
    setState(() {});
  }

  void _onTextBoxSubmit(String value) async {
    final dev = widget.device;

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhere((info) => info.serialNo == dev.serialNo);

    final updatedInfo =
        deviceInfo.copyWith(deviceName: widget.namecontroller.text.trim());

    ref.read(infoProvider.notifier).addOrEditDeviceInfo(updatedInfo);
    widget.textBox.unfocus();
    await Db.saveDeviceInfos(ref.read(infoProvider));
  }

  void _onAutoConnectToggled(bool autoConnect) async {
    final dev = widget.device;
    final autoConnectNotifier = ref.read(autoConnectProvider.notifier);

    if (autoConnect) {
      autoConnectNotifier.remove(dev.id);
    } else {
      if (dev.id.isIpv4 || dev.id.isIpv6) {
        autoConnectNotifier.add(ConnectAutomation(deviceIp: dev.id));
      }
    }

    await Db.saveAutoConnect(ref.read(autoConnectProvider));

    setState(() {});
  }
}
