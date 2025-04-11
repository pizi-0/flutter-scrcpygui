// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/providers/config_provider.dart';
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
  late String ddValue;
  late TextEditingController namecontroller;
  ScrollController scrollController = ScrollController();
  bool loading = false;
  FocusNode textBox = FocusNode();

  @override
  void initState() {
    dev = ref.read(adbProvider).firstWhere((d) => d.id == widget.id);

    namecontroller = TextEditingController(text: dev.name ?? dev.modelName);

    ddValue = dev.automationData?.actions
            .firstWhere((a) => a.type == ActionType.launchConfig,
                orElse: () => AutomationAction(type: null))
            .action ??
        DO_NOTHING;

    textBox.addListener(_onLoseFocus);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (dev.info == null) {
        _getScrcpyInfo();
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
    final isWireless =
        dev.id.isIpv4 || dev.id.isIpv6 || dev.id.contains(adbMdns);

    final autoConnect = (dev.automationData?.actions
                .where((a) => a.type == ActionType.autoconnect) ??
            [])
        .isNotEmpty;

    return PgScaffold(
      title: '${el.deviceSettingsLoc.title} / ${dev.name}',
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
                  filled: true,
                  focusNode: textBox,
                  placeholder: Text(dev.name ?? dev.modelName),
                  controller: namecontroller,
                  onSubmitted: _onTextBoxSubmit,
                ),
              ),
            ),
            if (isWireless) const Divider(),
            if (isWireless)
              ConfigCustom(
                onPressed: () => _onAutoConnectToggled(),
                title: el.deviceSettingsLoc.autoConnect.label,
                subtitle: el.deviceSettingsLoc.autoConnect.info,
                showinfo: showInfo,
                childExpand: false,
                child: Checkbox(
                  state: autoConnect
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (val) => _onAutoConnectToggled(),
                ),
              ),
            const Divider(),
            ConfigCustom(
              dimTitle: false,
              title: el.deviceSettingsLoc.onConnected.label,
              subtitle: el.deviceSettingsLoc.onConnected.info,
              showinfo: showInfo,
              child: Select(
                filled: true,
                placeholder: Text(el.deviceSettingsLoc.doNothing),
                itemBuilder: (context, value) => Text(
                  allconfigs.where((conf) => conf.id == value).isNotEmpty
                      ? allconfigs
                          .firstWhere((conf) => conf.id == value)
                          .configName
                      : el.deviceSettingsLoc.doNothing,
                ),
                value: ddValue,
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
            onPressed: _getScrcpyInfo,
            icon: const Icon(Icons.refresh),
          ),
          children: loading || dev.info == null
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
                          .version(version: dev.info!.buildVersion)),
                  Accordion(
                    items: [
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo
                              .displays(count: '${dev.info!.displays.length}')),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dev.info!.displays
                              .map((d) => Text('- ${d.toString()}'))
                              .toList(),
                        ),
                      ),
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo
                              .cameras(count: '${dev.info!.cameras.length}')),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dev.info!.cameras
                              .map((c) => Text('- ${c.toString()}'))
                              .toList(),
                        ),
                      ),
                      AccordionItem(
                        trigger: AccordionTrigger(
                          child: Text(el.deviceSettingsLoc.scrcpyInfo.videoEnc(
                              count: '${dev.info!.videoEncoders.length}')),
                        ),
                        content: Accordion(
                          items: dev.info!.videoEncoders
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
                              count: '${dev.info!.audioEncoder.length}')),
                        ),
                        content: Accordion(
                          items: dev.info!.audioEncoder
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

  _getScrcpyInfo() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    loading = true;
    setState(() {});

    final info =
        await AdbUtils.getScrcpyDetailsFor(ref.read(execDirProvider), dev);
    dev = dev.copyWith(info: info);
    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
    await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));

    if (selectedDevice != null) {
      if (selectedDevice.id == dev.id) {
        ref.read(selectedDeviceProvider.notifier).state = dev;
      }
    }

    loading = false;
    setState(() {});
  }

  void _onConnectConfig(value) async {
    List<AutomationAction> currentAutomation =
        dev.automationData?.actions ?? [];

    if (ddValue == DO_NOTHING) {
      currentAutomation
          .add(AutomationAction(type: ActionType.launchConfig, action: value));

      dev = dev.copyWith(
          automationData: AutomationData(actions: currentAutomation));
    } else {
      currentAutomation.removeWhere((e) => e.type == ActionType.launchConfig);
      dev = dev.copyWith(
          automationData: AutomationData(actions: currentAutomation));
    }

    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
    await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));

    ddValue = value;
    setState(() {});
  }

  // void _toAllCaps(value) {
  //   namecontroller.value = TextEditingValue(
  //     text: value.toUpperCase(),
  //     selection: namecontroller.selection,
  //   );
  // }

  void _onTextBoxSubmit(value) async {
    dev = dev.copyWith(name: value);
    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
    textBox.unfocus();
    await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));
  }

  void _onAutoConnectToggled() async {
    final autoConnect = (dev.automationData?.actions
                .where((a) => a.type == ActionType.autoconnect) ??
            [])
        .isNotEmpty;

    List<AutomationAction> currentAutomation =
        dev.automationData?.actions ?? [];

    if (autoConnect) {
      currentAutomation.remove(AutomationAction(type: ActionType.autoconnect));
    } else {
      currentAutomation.add(AutomationAction(type: ActionType.autoconnect));
    }
    dev = dev.copyWith(
        automationData: AutomationData(actions: currentAutomation));

    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
    await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));

    setState(() {});
  }

  _onLoseFocus() {
    if (!textBox.hasFocus) {
      namecontroller = TextEditingController(text: dev.name ?? dev.modelName);
      setState(() {});
    }
  }
}
