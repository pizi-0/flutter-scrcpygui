import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/4.settings_tab/widget_state/add_custom_shortcut_state.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../models/adb_devices.dart';
import '../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../models/tasks/task_type.dart';
import '../../../../providers/adb_provider.dart';
import '../../../../providers/config_provider.dart';
import '../../../../providers/device_info_provider.dart';
import '../../../../widgets/config_tiles.dart';

class Step1 extends ConsumerStatefulWidget {
  const Step1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Step1State();
}

class _Step1State extends ConsumerState<Step1> {
  List<ScrcpyConfig> availableConfigs = [];
  List<ToRun> availableTasks = [
    StartScrcpyTask(),
    StopScrcpyTask(),
  ];

  @override
  void initState() {
    availableConfigs = ref.read(configsProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AdbDevices> connectedDevices = [];
    ref.watch(adbProvider).forEach((dev) {
      if (connectedDevices
          .where((conn) => conn.serialNo == dev.serialNo)
          .isEmpty) {
        connectedDevices.add(dev);
      }
    });
    final dialogState = ref.watch(addShortcutDialogStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        SizedBox.shrink(),
        Divider(),
        ConfigCustom(
          title: 'Action',
          child: Select(
            value: dialogState.shortcut.task.toRun.first,
            onChanged: (value) => ref
                .read(addShortcutDialogStateProvider.notifier)
                .setToRunType(value!),
            popup: SelectPopup(
              items: SelectItemList(
                  children: availableTasks
                      .map((e) =>
                          SelectItemButton(value: e, child: Text(e.taskId)))
                      .toList()),
            ).call,
            itemBuilder: (context, value) => Text(value.taskId),
          ),
        ),
        Divider(),
        if (dialogState.shortcut.task.toRun.first is StartScrcpyTask) ...[
          ConfigCustom(
            title: 'Configuration',
            child: Row(
              spacing: 4,
              children: [
                Expanded(
                  child: Select(
                    value: dialogState.getConfig(ref),
                    onChanged: (value) => ref
                        .read(addShortcutDialogStateProvider.notifier)
                        .setConfig(value!),
                    placeholder:
                        OverflowMarquee(child: Text('Last used config')),
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          ...availableConfigs.map((conf) => SelectItemButton(
                              value: conf, child: Text(conf.configName)))
                        ],
                      ),
                    ).call,
                    itemBuilder: (context, value) =>
                        OverflowMarquee(child: Text(value.configName)),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ConfigCustom(
            title: 'Device',
            child: Row(
              spacing: 4,
              children: [
                Expanded(
                  child: Select(
                    onChanged: (value) => ref
                        .read(addShortcutDialogStateProvider.notifier)
                        .setDevice(value!),
                    value: dialogState.getDevice(ref),
                    placeholder: OverflowMarquee(
                        duration: 1.5.seconds,
                        delayDuration: 500.milliseconds,
                        child: Text('Current selected device')),
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          ...connectedDevices.map((dev) {
                            final info = ref.read(infoProvider);
                            final devInfo = info.firstWhereOrNull(
                                (i) => i.serialNo == dev.serialNo);

                            return SelectItemButton(
                              value: dev,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Text(devInfo?.deviceName ?? dev.modelName),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ).call,
                    itemBuilder: (context, dev) {
                      final info = ref.read(infoProvider);
                      final devInfo = info
                          .firstWhereOrNull((i) => i.serialNo == dev.serialNo);

                      return Row(
                        spacing: 8,
                        children: [
                          Text(devInfo?.deviceName ?? dev.modelName),
                        ],
                      );
                    },
                  ),
                ),
                if (dialogState.getDevice(ref) != null)
                  IconButton.ghost(
                    density: ButtonDensity.iconDense,
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () => ref
                        .read(addShortcutDialogStateProvider.notifier)
                        .setDevice(null),
                  ),
              ],
            ),
          ),
          if (dialogState.getDevice(ref) != null) ...[
            Divider(),
            ConfigCustom(
              title: 'Connection Preference',
              child: Select(
                value: dialogState.getConnectionPref(ref),
                onChanged: (value) => ref
                    .read(addShortcutDialogStateProvider.notifier)
                    .setConnectionPrefs(value!),
                popup: SelectPopup(
                  items: SelectItemList(
                      children: ConnectionPref.values
                          .map((e) =>
                              SelectItemButton(value: e, child: Text(e.name)))
                          .toList()),
                ).call,
                itemBuilder: (context, value) => Text(value.name),
              ),
            )
          ]
        ]
      ],
    );
  }
}
