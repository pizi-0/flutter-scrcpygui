// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/providers/automation_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../providers/adb_provider.dart';

// ignore: constant_identifier_names
const DO_NOTHING = 'Do nothing';
final deviceSettingsShowInfo = StateProvider((ref) => false);

class DeviceSettingsScreen extends ConsumerStatefulWidget {
  final String id;
  static const route = 'device-settings/:id';
  const DeviceSettingsScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends ConsumerState<DeviceSettingsScreen> {
  late AdbDevices dev;
  String? autoLaunchConfigId;
  late TextEditingController namecontroller;
  ScrollController scrollController = ScrollController();
  bool loading = false;
  FocusNode textBox = FocusNode();

  @override
  void initState() {
    dev = ref.read(adbProvider).firstWhere((d) => d.id == widget.id);

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    final autoLaunch = ref
        .read(autoLaunchProvider)
        .firstWhereOrNull((a) => a.deviceId == dev.id);

    autoLaunchConfigId = autoLaunch?.configId;

    namecontroller =
        TextEditingController(text: deviceInfo?.deviceName ?? dev.modelName);

    textBox.addListener(_onLoseFocus);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (deviceInfo == null) {
        _getDeviceInfo();
      }
    });
  }

  @override
  void dispose() {
    namecontroller.dispose();
    textBox.removeListener(_onLoseFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showInfo = ref.watch(deviceSettingsShowInfo);
    final allconfigs = ref.watch(configsProvider);

    final autoConnect = ref
        .watch(autoConnectProvider)
        .where((a) => a.deviceIp == dev.id)
        .isNotEmpty;

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    return PgScaffold(
      title:
          '${el.deviceSettingsLoc.title} / ${deviceInfo?.deviceName ?? dev.modelName}',
      onBack: () => context.pop(),
      children: [
        PgSectionCard(
          label: el.deviceSettingsLoc.title,
          children: [
            ConfigCustom(
              dimTitle: false,
              title: el.deviceSettingsLoc.rename.label,
              subtitle: el.deviceSettingsLoc.rename.info,
              showinfo: showInfo,
              child: SizedBox(
                width: 180,
                child: TextField(
                  enabled: !loading,
                  filled: true,
                  focusNode: textBox,
                  placeholder: Text(deviceInfo?.deviceName ?? dev.modelName),
                  controller: namecontroller,
                  onSubmitted: _onTextBoxSubmit,
                ),
              ),
            ),
            if (dev.id.isIpv4 || dev.id.isIpv6) const Divider(),
            if (dev.id.isIpv4 || dev.id.isIpv6)
              ConfigCustom(
                onPressed: () => _onAutoConnectToggled(autoConnect),
                title: el.deviceSettingsLoc.autoConnect.label,
                subtitle: el.deviceSettingsLoc.autoConnect.info,
                showinfo: showInfo,
                childExpand: false,
                child: Checkbox(
                  enabled: !loading,
                  state: autoConnect
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (val) => _onAutoConnectToggled(autoConnect),
                ),
              ),
            const Divider(),
            ConfigCustom(
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
                      ? allconfigs
                          .firstWhere((conf) => conf.id == value)
                          .configName
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
                    ...allconfigs.map((c) => SelectItemButton(
                        value: c.id, child: Text(c.configName)))
                  ]),
                ).call,
              ),
            ),
          ],
        ),
        PgSectionCard(
          label: el.deviceSettingsLoc.scrcpyInfo.label,
          labelTrail: IconButton.ghost(
            density: ButtonDensity.dense,
            onPressed: _getDeviceInfo,
            icon: const Icon(Icons.refresh),
          ),
          children: loading || deviceInfo == null
              ? [
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ]
              : [
                  PgListTile(
                      title: el.deviceSettingsLoc.scrcpyInfo
                          .id(id: dev.id.replaceAll('.$adbMdns', ''))),
                  // const Divider(),
                  PgListTile(
                      title: el.deviceSettingsLoc.scrcpyInfo
                          .model(model: dev.modelName)),
                  // const Divider(),
                  PgListTile(
                      title: el.deviceSettingsLoc.scrcpyInfo
                          .version(version: deviceInfo.buildVersion)),
                  Accordion(
                    items: [
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo.displays(
                              count: '${deviceInfo.displays.length}')),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: deviceInfo.displays
                              .map((d) => Text('- ${d.toString()}'))
                              .toList(),
                        ),
                      ),
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo
                              .cameras(count: '${deviceInfo.cameras.length}')),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: deviceInfo.cameras
                              .map((c) => Text('- ${c.toString()}'))
                              .toList(),
                        ),
                      ),
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo.videoEnc(
                              count: '${deviceInfo.videoEncoders.length}')),
                        ),
                        content: Accordion(
                          items: deviceInfo.videoEncoders
                              .map((c) => AccordionItem(
                                    trigger: AccordionTrigger(
                                      child: Text(c.codec).li(),
                                    ),
                                    content: Column(
                                      spacing: 4,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: c.encoder
                                          .map((en) => Text('- $en'))
                                          .toList(),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo.audioEnc(
                              count: '${deviceInfo.audioEncoder.length}')),
                        ),
                        content: Accordion(
                          items: deviceInfo.audioEncoder
                              .map((c) => AccordionItem(
                                    trigger: AccordionTrigger(
                                        child: Text(c.codec).li()),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: c.encoder
                                          .map((en) => Text('- $en'))
                                          .toList(),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
        ),
      ],
    );
  }

  _getDeviceInfo() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    loading = true;
    setState(() {});

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    final info =
        await AdbUtils.getDeviceInfoFor(ref.read(execDirProvider), dev);

    if (deviceInfo == null) {
      ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);
    } else {
      final updatedInfo = info.copyWith(deviceName: deviceInfo.deviceName);
      ref.read(infoProvider.notifier).addOrEditDeviceInfo(updatedInfo);
    }

    await Db.saveDeviceInfos(ref.read(infoProvider));

    if (selectedDevice != null) {
      if (selectedDevice.id == dev.id) {
        ref.read(selectedDeviceProvider.notifier).state = dev;
      }
    }

    loading = false;
    setState(() {});
  }

  void _onConnectConfig(value) async {
    final autoLaunchNotifier = ref.read(autoLaunchProvider.notifier);

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

  void _onTextBoxSubmit(value) async {
    final deviceInfo = ref
        .read(infoProvider)
        .firstWhere((info) => info.serialNo == dev.serialNo);

    final updatedInfo =
        deviceInfo.copyWith(deviceName: namecontroller.text.trim());

    ref.read(infoProvider.notifier).addOrEditDeviceInfo(updatedInfo);
    textBox.unfocus();
    await Db.saveDeviceInfos(ref.read(infoProvider));
  }

  void _onAutoConnectToggled(bool autoConnect) async {
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

  _onLoseFocus() {
    if (!textBox.hasFocus) {
      final deviceInfo = ref
          .read(infoProvider)
          .firstWhereOrNull((info) => info.serialNo == dev.serialNo);
      namecontroller =
          TextEditingController(text: deviceInfo?.deviceName ?? dev.modelName);
      setState(() {});
    }
  }
}
