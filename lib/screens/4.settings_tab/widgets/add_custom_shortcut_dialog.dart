import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

class AddCustomShortcutDialog extends ConsumerStatefulWidget {
  const AddCustomShortcutDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCustomShortcutDialogState();
}

class _AddCustomShortcutDialogState
    extends ConsumerState<AddCustomShortcutDialog> {
  final StepperController controller = StepperController();
  int currentStep = 0;
  ShortcutAction selectedAction =
      ShortcutAction(name: 'Start', action: ShortcutActionEnum.startScrcpy);
  ScrcpyConfig? config;
  AdbDevices? device;
  List<ScrcpyConfig> availableConfigs = [];
  ScrcpyConfig lastUsedConfig = defaultMirror;

  @override
  void initState() {
    controller.addListener(_onStepChange);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        lastUsedConfig = (await Db.getLastUsedConfig(ref)) ?? defaultMirror;
        availableConfigs = ref.read(configsProvider);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onStepChange() {
    currentStep = controller.value.currentStep;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final connectedDevices = ref.watch(adbProvider);

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
      child: AlertDialog(
        title: Text('Add Shortcut'),
        content: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
          child: OutlinedContainer(
            padding: EdgeInsets.all(8),
            child: Stepper(
              size: StepSize.small,
              controller: controller,
              steps: [
                Step(
                  title: Text('Action'),
                  contentBuilder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        SizedBox(height: 8),
                        ConfigCustom(
                          title: 'Action',
                          child: Select(
                            value: selectedAction,
                            onChanged: (value) => onActionSelection(value!),
                            popup: SelectPopup(
                              items: SelectItemList(
                                  children: shortcutAction
                                      .map((e) => SelectItemButton(
                                          value: e, child: Text(e.name)))
                                      .toList()),
                            ).call,
                            itemBuilder: (context, value) => Text(value.name),
                          ),
                        ),
                        Divider(),
                        if (selectedAction.action ==
                            ShortcutActionEnum.startScrcpy) ...[
                          ConfigCustom(
                            title: 'Configuration',
                            child: Row(
                              spacing: 4,
                              children: [
                                Expanded(
                                  child: Select(
                                    value: config,
                                    onChanged: (value) =>
                                        setState(() => config = value!),
                                    placeholder: OverflowMarquee(
                                        child: Text('Last used config')),
                                    popup: SelectPopup(
                                      items: SelectItemList(
                                        children: [
                                          ...availableConfigs.map((conf) =>
                                              SelectItemButton(
                                                  value: conf,
                                                  child: Text(conf.configName)))
                                        ],
                                      ),
                                    ).call,
                                    itemBuilder: (context, value) =>
                                        OverflowMarquee(
                                            child: Text(value.configName)),
                                  ),
                                ),
                                if (config != null)
                                  IconButton.ghost(
                                    density: ButtonDensity.iconDense,
                                    icon: Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      config = null;
                                      setState(() {});
                                    },
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
                                    onChanged: (value) =>
                                        setState(() => device = value!),
                                    value: device,
                                    placeholder: Text('First device'),
                                    popup: SelectPopup(
                                      items: SelectItemList(
                                        children: [
                                          ...connectedDevices.map((dev) {
                                            final info = ref.read(infoProvider);
                                            final devInfo =
                                                info.firstWhereOrNull((i) =>
                                                    i.serialNo == dev.serialNo);

                                            return SelectItemButton(
                                              value: dev,
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  isWireless(dev.id)
                                                      ? Icon(Icons.wifi_rounded,
                                                          size: 16)
                                                      : Icon(Icons.usb_rounded,
                                                          size: 16),
                                                  Text(devInfo?.deviceName ??
                                                      dev.id),
                                                ],
                                              ),
                                            );
                                          })
                                        ],
                                      ),
                                    ).call,
                                    itemBuilder: (context, dev) {
                                      final info = ref.read(infoProvider);
                                      final devInfo = info.firstWhereOrNull(
                                          (i) => i.serialNo == dev.serialNo);

                                      return Row(
                                        spacing: 8,
                                        children: [
                                          isWireless(dev.id)
                                              ? Icon(Icons.wifi_rounded,
                                                  size: 16)
                                              : Icon(Icons.usb_rounded,
                                                  size: 16),
                                          Text(devInfo?.deviceName ?? dev.id),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                if (device != null)
                                  IconButton.ghost(
                                    density: ButtonDensity.iconDense,
                                    icon: Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      device = null;
                                      setState(() {});
                                    },
                                  ),
                              ],
                            ),
                          )
                        ]
                      ],
                    );
                  },
                ),
                Step(title: Text('Keys')),
              ],
            ),
          ),
        ),
        actions: [
          Spacer(),
          if (currentStep != 0)
            SecondaryButton(
              onPressed: controller.previousStep,
              child: Text('Back'),
            ),
          if (currentStep < 1)
            PrimaryButton(
              onPressed: controller.nextStep,
              child: Text('Next'),
            ),
          if (controller.value.currentStep == 1)
            PrimaryButton(child: Text('Add')),
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void onActionSelection(ShortcutAction action) {
    selectedAction = action;
    config = null;
    device = null;

    setState(() {});
  }

  List<ShortcutAction> shortcutAction = [
    ShortcutAction(name: 'Start', action: ShortcutActionEnum.startScrcpy),
    ShortcutAction(name: 'Stop', action: ShortcutActionEnum.stopLastScrcpy),
  ];

  bool isWireless(String id) {
    return id.contains(':') || id.contains(adbMdns) || id.isIpv4;
  }
}

enum ShortcutActionEnum {
  startScrcpy,
  stopLastScrcpy,
}

class ShortcutAction {
  final String name;
  final ShortcutActionEnum action;
  const ShortcutAction({required this.name, required this.action});
}
