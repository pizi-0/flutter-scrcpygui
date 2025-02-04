import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/automation_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/body_container.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/section_button.dart';

import '../../providers/adb_provider.dart';
import 'widgets/info_container.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = dev.info;
    final configs = ref.watch(configsProvider);
    final appTheme = ref.read(settingsProvider).looks;
    final colorScheme = Theme.of(context).colorScheme;

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: buttonStyle,
          tooltip: 'ESC',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: colorScheme.inverseSurface,
          ),
        ),
        title: const Text('Device Settings'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
      ),
      body: info == null || loading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyContainer(
                      spacing: 4,
                      children: [
                        ConfigCustom(
                          label: 'Rename',
                          child: Container(
                            height: 40,
                            width: 150,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(
                                    appTheme.widgetRadius * 0.6)),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              textCapitalization: TextCapitalization.characters,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              maxLines: 1,
                              onSubmitted: (value) async {
                                dev = dev.copyWith(
                                    name: namecontroller.text.toUpperCase());

                                ref
                                    .read(savedAdbDevicesProvider.notifier)
                                    .addEditDevices(dev);

                                await AdbUtils.saveAdbDevice(
                                    ref.read(savedAdbDevicesProvider));
                              },
                              inputFormatters: [
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.copyWith(
                                      text: newValue.text.toUpperCase()),
                                )
                              ],
                              controller: namecontroller,
                              // textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.inverseSurface,
                              ),
                            ),
                          ),
                        ),
                        ConfigCustom(
                          childBackgroundColor: Colors.transparent,
                          label: 'Autoconnect if available',
                          child: Checkbox(
                            value: dev.automationData == null
                                ? false
                                : dev.automationData!.actions.contains(
                                    AutomationAction(
                                        type: ActionType.autoconnect)),
                            onChanged: (v) async {
                              bool enabled = dev.automationData?.actions
                                      .contains(AutomationAction(
                                          type: ActionType.autoconnect)) ??
                                  false;

                              if (enabled) {
                                final current =
                                    dev.automationData ?? defaultAutomationData;

                                current.actions.removeWhere(
                                    (e) => e.type == ActionType.autoconnect);

                                dev = dev.copyWith(
                                    automationData: current.copyWith(
                                        actions: current.actions));

                                setState(() {});
                              } else {
                                final current =
                                    dev.automationData ?? defaultAutomationData;

                                current.actions.add(AutomationAction(
                                    type: ActionType.autoconnect));

                                dev = dev.copyWith(
                                  automationData: current.copyWith(
                                      actions: current.actions),
                                );

                                setState(() {});
                              }
                              AutomationUtils.setAutoConnect(ref, dev);
                              final saved = ref.read(savedAdbDevicesProvider);
                              await AdbUtils.saveAdbDevice(saved);
                            },
                          ),
                        ),
                        ConfigDropdownOthers(
                          initialValue: ddValue,
                          onSelected: (v) async {
                            setState(() {
                              ddValue = v!;
                            });
                            if (v == DO_NOTHING) {
                              var currentAutoData = dev.automationData ??
                                  AutomationData(actions: []);

                              currentAutoData.actions.removeWhere(
                                  (e) => e.type == ActionType.launchConfig);
                            } else {
                              var currentAutoData = dev.automationData ??
                                  AutomationData(actions: []);

                              currentAutoData.actions.removeWhere(
                                  (e) => e.type == ActionType.launchConfig);

                              dev = dev.copyWith(
                                  automationData:
                                      currentAutoData.copyWith(actions: [
                                ...currentAutoData.actions,
                                AutomationAction(
                                  type: ActionType.launchConfig,
                                  action: v,
                                )
                              ]));
                            }
                            ref
                                .read(savedAdbDevicesProvider.notifier)
                                .addEditDevices(dev);
                            final saved = ref.read(savedAdbDevicesProvider);
                            await AdbUtils.saveAdbDevice(saved);
                          },
                          items: [
                            const DropdownMenuItem(
                              value: DO_NOTHING,
                              child: Text('Do nothing'),
                            ),
                            ...configs.where((c) => c != newConfig).map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.configName),
                                  ),
                                )
                          ],
                          label: 'On autoconnect success',
                        ),
                      ],
                    ),
                    BodyContainer(
                      headerTitle: 'Info',
                      headerTrailing: SectionButton(
                        tooltipmessage: 'Get info',
                        icondata: Icons.refresh,
                        ontap: () async {
                          loading = true;
                          setState(() {});

                          final info = await AdbUtils.getScrcpyDetailsFor(
                              ref.read(execDirProvider), dev);
                          dev = dev.copyWith(info: info);
                          ref
                              .read(savedAdbDevicesProvider.notifier)
                              .addEditDevices(dev);
                          await AdbUtils.saveAdbDevice(
                              ref.read(savedAdbDevicesProvider));

                          if (mounted) {
                            loading = false;
                            setState(() {});
                          }
                        },
                      ),
                      children: [
                        InfoContainer(info: dev.info!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
