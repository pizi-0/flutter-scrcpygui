// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/providers/automation_provider.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/widgets/info_pane.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/widgets/settings_pane.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../providers/adb_provider.dart';

// ignore: constant_identifier_names
const DO_NOTHING = 'Do nothing';
final deviceSettingsShowInfo = StateProvider((ref) => false);
final deviceSettingsLoading = StateProvider((ref) => false);

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
    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    return PgScaffoldCustom(
      title: Text(
          '${el.deviceSettingsLoc.title} / ${deviceInfo?.deviceName ?? dev.modelName}'),
      onBack: () => context.pop(),
      scaffoldBody: ResponsiveBuilder(builder: (context, sizeInfo) {
        return AnimatedSwitcher(
          duration: 200.milliseconds,
          child: sizeInfo.isMobile || sizeInfo.isTablet
              ? DeviceSettingsSmall(
                  loading: loading,
                  namecontroller: namecontroller,
                  textBox: textBox,
                  device: dev,
                )
              : DeviceSettingsBig(
                  loading: loading,
                  namecontroller: namecontroller,
                  textBox: textBox,
                  device: dev,
                ),
        );
      }),
    );
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

  void _onLoseFocus() {
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

class DeviceSettingsSmall extends ConsumerWidget {
  final bool expandContent;
  final AdbDevices device;
  final TextEditingController namecontroller;
  final bool loading;
  final FocusNode textBox;
  const DeviceSettingsSmall({
    super.key,
    this.expandContent = false,
    required this.loading,
    required this.namecontroller,
    required this.textBox,
    required this.device,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        spacing: 8,
        children: [
          SettingsPane(
            namecontroller: namecontroller,
            textBox: textBox,
            device: device,
          ),
          InfoPane(device: device)
        ],
      ),
    );
  }
}

class DeviceSettingsBig extends ConsumerWidget {
  final bool expandContent;
  final AdbDevices device;
  final TextEditingController namecontroller;
  final bool loading;
  final FocusNode textBox;
  const DeviceSettingsBig({
    super.key,
    this.expandContent = false,
    required this.loading,
    required this.namecontroller,
    required this.textBox,
    required this.device,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 8,
      children: [
        LeftColumn(
          child: SettingsPane(
            namecontroller: namecontroller,
            textBox: textBox,
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
