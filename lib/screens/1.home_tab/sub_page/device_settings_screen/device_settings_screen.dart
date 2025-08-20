// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/device_settings_screen_state.dart';
import 'package:scrcpygui/providers/automation_provider.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/widgets/info_pane.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/widgets/settings_pane.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../models/automation.dart';
import '../../../../providers/adb_provider.dart';
import 'device_settings_state_provider.dart';

// ignore: constant_identifier_names
const DO_NOTHING = 'Do nothing';

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

  ScrollController scrollController = ScrollController();
  bool loading = false;
  late DeviceSettingsScreenState oldState;
  late TextEditingController namecontroller;

  @override
  void initState() {
    dev = ref.read(adbProvider).firstWhere((d) => d.id == widget.id);

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    namecontroller =
        TextEditingController(text: deviceInfo?.deviceName ?? dev.modelName);

    oldState = ref
        .read(deviceSettingsStateProvider(dev))
        .copyWith(deviceName: deviceInfo?.deviceName ?? dev.modelName);

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
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    final currentState = ref.watch(deviceSettingsStateProvider(dev));
    final isWireless = dev.id.isIpv4 || dev.id.contains(adbMdns);

    return PgScaffoldCustom(
      onBack: context.pop,
      title: RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: theme.typography.xLarge.fontSize,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.foreground),
          children: [
            TextSpan(text: el.deviceSettingsLoc.title),
            TextSpan(text: ' / '),
            WidgetSpan(
                baseline: TextBaseline.ideographic,
                child: isWireless
                    ? Icon(
                        Icons.wifi_rounded,
                        size: 22,
                      )
                    : Icon(Icons.usb_rounded)),
            TextSpan(text: ' ${deviceInfo?.deviceName ?? dev.modelName}')
          ],
        ),
      ),
      leading: [
        PgExpandable(
          direction: Axis.horizontal,
          expand: oldState != currentState,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.primary(
              density: ButtonDensity.dense,
              trailing: Text(el.buttonLabelLoc.save),
              icon: Icon(Icons.save),
              onPressed: _save,
            ),
          ),
        ),
      ],
      scaffoldBody: ResponsiveBuilder(builder: (context, sizeInfo) {
        return AnimatedSwitcher(
          duration: 200.milliseconds,
          child: sizeInfo.isMobile || sizeInfo.isTablet
              ? DeviceSettingsSmall(device: dev, nameController: namecontroller)
              : DeviceSettingsBig(device: dev, nameController: namecontroller),
        );
      }),
    );
  }

  Future<void> _save() async {
    final newState = ref.read(deviceSettingsStateProvider(dev));
    final deviceInfo =
        ref.read(infoProvider).firstWhere((i) => i.serialNo == dev.serialNo);

    if (newState.deviceName != deviceInfo.deviceName) {
      final newInfo = deviceInfo.copyWith(deviceName: namecontroller.text);

      ref.read(infoProvider.notifier).addOrEditDeviceInfo(newInfo);
      await Db.saveDeviceInfos(ref.read(infoProvider));
    }

    if (newState.autoConnect) {
      final data = ConnectAutomation(deviceIp: dev.id);
      ref.read(autoConnectProvider.notifier).add(data);
      await Db.saveAutoConnect(ref.read(autoConnectProvider));
    } else {
      ref.read(autoConnectProvider.notifier).remove(dev.id);
      await Db.saveAutoConnect(ref.read(autoConnectProvider));
    }

    if (newState.autoLaunch) {
      ref.read(autoLaunchProvider.notifier).remove(dev.id);

      for (final ca in newState.autoLaunchConfig) {
        ref.read(autoLaunchProvider.notifier).add(ca);
      }

      await Db.saveAutoLaunch(ref.read(autoLaunchProvider));
    } else {
      ref.read(autoLaunchProvider.notifier).remove(dev.id);

      await Db.saveAutoLaunch(ref.read(autoLaunchProvider));
    }

    setState(() {
      oldState = newState;
    });
  }

  Future<void> _getDeviceInfo() async {
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

  // void _onLoseFocus() {
  //   if (!textBox.hasFocus) {
  //     final deviceInfo = ref
  //         .read(infoProvider)
  //         .firstWhereOrNull((info) => info.serialNo == dev.serialNo);
  //     namecontroller =
  //         TextEditingController(text: deviceInfo?.deviceName ?? dev.modelName);
  //     setState(() {});
  //   }
  // }
}

class DeviceSettingsSmall extends ConsumerWidget {
  final TextEditingController nameController;
  final AdbDevices device;

  const DeviceSettingsSmall(
      {super.key, required this.device, required this.nameController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Gap(6),
            Column(
              spacing: 8,
              children: [
                SettingsPane(device: device, nameController: nameController),
                InfoPane(device: device),
              ],
            ),
            Gap(8),
          ],
        ),
      ),
    );
  }
}

class DeviceSettingsBig extends ConsumerWidget {
  final TextEditingController nameController;
  final AdbDevices device;

  const DeviceSettingsBig(
      {super.key, required this.device, required this.nameController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 8,
      children: [
        LeftColumn(
          child: SettingsPane(
            nameController: nameController,
            device: device,
            expandContent: true,
          ),
        ),
        RightColumn(
          child: InfoPane(device: device, expandContent: true),
        )
      ],
    );
  }
}
