// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../providers/adb_provider.dart';

// ignore: constant_identifier_names
const DO_NOTHING = 'Do nothing';

class DeviceSettingsScreen extends ConsumerStatefulWidget {
  final AdbDevices device;
  const DeviceSettingsScreen({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends ConsumerState<DeviceSettingsScreen> {
  late AdbDevices dev;
  late String ddValue;
  late TextEditingController namecontroller;
  bool loading = false;
  FocusNode textBox = FocusNode();

  @override
  void initState() {
    dev = ref.read(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == widget.device.id,
        orElse: () => widget.device);

    namecontroller =
        TextEditingController(text: dev.name?.toUpperCase() ?? dev.modelName);

    ddValue = dev.automationData?.actions
            .firstWhere((a) => a.type == ActionType.launchConfig,
                orElse: () => AutomationAction(type: null))
            .action ??
        DO_NOTHING;

    textBox.addListener(_onLoseFocus);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      if (dev.info == null) {
        final info =
            await AdbUtils.getScrcpyDetailsFor(ref.read(execDirProvider), dev);
        dev = dev.copyWith(info: info);
        ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
        await AdbUtils.saveAdbDevice(ref.read(savedAdbDevicesProvider));
        setState(() {});
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
    final info = dev.info;
    final theme = FluentTheme.of(context);
    final allconfigs = ref.watch(configsProvider);
    final isWireless =
        dev.id.isIpv4 || dev.id.isIpv6 || dev.id.contains(adbMdns);

    final autoConnect = (dev.automationData?.actions
                .where((a) => a.type == ActionType.autoconnect) ??
            [])
        .isNotEmpty;

    return NavigationView(
      appBar: NavigationAppBar(
        title: Text('Settings / ${dev.name}').textStyle(theme.typography.body),
        leading: IconButton(
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FluentIcons.back),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        size: const NavigationPaneSize(compactWidth: 0),
        menuButton: const SizedBox(),
        toggleable: false,
        selected: 0,
        items: [
          PaneItem(
            icon: const SizedBox(),
            body: info == null || loading
                ? const Center(child: CupertinoActivityIndicator())
                : ScaffoldPage.withPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    content: SingleChildScrollView(
                      child: Column(
                        spacing: 4,
                        children: [
                          Card(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                ConfigCustom(
                                  title: 'Rename',
                                  child: SizedBox(
                                    width: 180,
                                    child: TextBox(
                                      focusNode: textBox,
                                      placeholder: dev.name,
                                      controller: namecontroller,
                                      onChanged: (value) {
                                        namecontroller.value = TextEditingValue(
                                          text: value.toUpperCase(),
                                          selection: namecontroller.selection,
                                        );
                                      },
                                      onSubmitted: (v) async {
                                        dev =
                                            dev.copyWith(name: v.toUpperCase());
                                        ref
                                            .read(savedAdbDevicesProvider
                                                .notifier)
                                            .addEditDevices(dev);
                                        await AdbUtils.saveAdbDevice(
                                            ref.read(savedAdbDevicesProvider));
                                      },
                                    ),
                                  ),
                                ),
                                if (isWireless) const Divider(),
                                if (isWireless)
                                  ConfigCustom(
                                    title: 'Auto-connect',
                                    child: ToggleSwitch(
                                      checked: autoConnect,
                                      onChanged: (v) async {
                                        List<AutomationAction>
                                            currentAutomation =
                                            dev.automationData?.actions ?? [];

                                        if (autoConnect) {
                                          currentAutomation.remove(
                                              AutomationAction(
                                                  type:
                                                      ActionType.autoconnect));
                                        } else {
                                          currentAutomation.add(
                                              AutomationAction(
                                                  type:
                                                      ActionType.autoconnect));
                                        }
                                        dev = dev.copyWith(
                                            automationData: AutomationData(
                                                actions: currentAutomation));

                                        ref
                                            .read(savedAdbDevicesProvider
                                                .notifier)
                                            .addEditDevices(dev);
                                        await AdbUtils.saveAdbDevice(
                                            ref.read(savedAdbDevicesProvider));

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                const Divider(),
                                ConfigCustom(
                                  title: 'On connected',
                                  child: ComboBox(
                                    placeholder: const Text('Do nothing'),
                                    value: null,
                                    onChanged: (value) {
                                      print(value!.id);
                                    },
                                    items: allconfigs
                                        .map(
                                          (c) => ComboBoxItem(
                                            value: c,
                                            child: Text(c.configName),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PageHeader(
                            title: const Text('Info'),
                            commandBar: CommandBar(
                              mainAxisAlignment: MainAxisAlignment.end,
                              primaryItems: [
                                CommandBarButton(
                                  onPressed: () {},
                                  icon: const Icon(FluentIcons.refresh),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  _onLoseFocus() {
    if (!textBox.hasFocus) {
      namecontroller =
          TextEditingController(text: dev.name?.toUpperCase() ?? dev.modelName);
      setState(() {});
    }
  }
}
