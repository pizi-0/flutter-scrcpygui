import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/automation_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/body_container.dart';

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

  @override
  void initState() {
    dev = ref.read(savedAdbDevicesProvider).firstWhere(
        (d) => d.id == widget.device.id,
        orElse: () => widget.device);

    ddValue = dev.automationData?.actions
            .firstWhere((a) => a.type == ActionType.launchConfig,
                orElse: () => AutomationAction(type: null))
            .action ??
        DO_NOTHING;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final info = dev.info!;
    final configs = ref.watch(configsProvider);
    final appTheme = ref.read(settingsProvider).looks;
    final colorSheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(dev.name?.toUpperCase() ?? dev.id),
        centerTitle: true,
        backgroundColor: colorSheme.surface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyContainer(
                children: [
                  BodyContainerItem(
                    title: 'Autoconnect if available',
                    trailing: Checkbox(
                      value: dev.automationData == null
                          ? false
                          : dev.automationData!.actions.contains(
                              AutomationAction(type: ActionType.autoconnect)),
                      onChanged: (v) async {
                        bool enabled = dev.automationData?.actions.contains(
                                AutomationAction(
                                    type: ActionType.autoconnect)) ??
                            false;

                        if (enabled) {
                          final current =
                              dev.automationData ?? defaultAutomationData;

                          current.actions.removeWhere(
                              (e) => e.type == ActionType.autoconnect);

                          dev = dev.copyWith(
                              automationData:
                                  current.copyWith(actions: current.actions));

                          setState(() {});
                        } else {
                          final current =
                              dev.automationData ?? defaultAutomationData;

                          current.actions.add(
                              AutomationAction(type: ActionType.autoconnect));

                          dev = dev.copyWith(
                            automationData:
                                current.copyWith(actions: current.actions),
                          );

                          setState(() {});
                        }
                        AutomationUtils.setAutoConnect(ref, dev);
                        final saved = ref.read(savedAdbDevicesProvider);
                        await AdbUtils.saveAdbDevice(saved);
                      },
                    ),
                  ),
                  BodyContainerItem(
                    title: 'On autoconnect success',
                    trailing: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 6, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(
                              appTheme.widgetRadius * 0.8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: Theme.of(context).textTheme.bodyMedium,
                              value: ddValue,
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
                              onChanged: (v) async {
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              BodyContainer(
                headerTitle: 'Info',
                children: [
                  InfoContainer(info: info),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoContainer extends ConsumerWidget {
  final ScrcpyInfo info;
  const InfoContainer({super.key, required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.read(settingsProvider).looks;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 4),
      duration: 200.milliseconds,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.85),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build version: ${info.buildVersion}'),
            Text('Serial: ${info.device.serialNo}'),
            Text('Model name: ${info.device.modelName}'),
            const Text('\nScrcpy details: '),
            const Text('\nDisplays:'),
            ...info.displays.map((e) => Row(
                  children: [
                    const Text('- '),
                    Expanded(child: Text(e.toString())),
                  ],
                )),
            const Text('\nCamera:'),
            ...info.cameras.map((e) => Row(
                  children: [
                    const Text('- '),
                    Text(e.toString()),
                  ],
                )),
            const Text('\nAudio encoder:'),
            ...info.audioEncoder.map((e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- '),
                    Expanded(child: Text(e.toString())),
                  ],
                )),
            const Text('\nVideo encoder:'),
            ...info.videoEncoders.map((e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- '),
                    Expanded(child: Text(e.toString())),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
