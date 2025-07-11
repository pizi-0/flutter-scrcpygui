import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../../providers/device_info_provider.dart';
import 'widgets/big_control_page.dart';
import 'widgets/small_control_page.dart';

final FocusNode controlPageKeyboardListenerNode =
    FocusNode(debugLabel: 'keyboard-listener');

class DeviceControlPage extends ConsumerStatefulWidget {
  static const route = 'device-control';
  final AdbDevices device;
  const DeviceControlPage({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceControlPageState();
}

class _DeviceControlPageState extends ConsumerState<DeviceControlPage> {
  ScrcpyConfig? config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connected = ref.watch(adbProvider);
    final device = widget.device;
    final isWireless = device.id.isIpv4 || device.id.contains(adbMdns);

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == device.serialNo);

    final stillConnected = connected.where((c) => c.id == device.id).isNotEmpty;

    return KeyboardListener(
      focusNode: controlPageKeyboardListenerNode,
      autofocus: true,
      onKeyEvent: (value) async {
        if (value.physicalKey == PhysicalKeyboardKey.slash) {
          if (!searchBoxFocusNode.hasFocus) {
            await Future.delayed(10.milliseconds);
            searchBoxFocusNode.requestFocus();
          }
        }

        if (value.physicalKey == PhysicalKeyboardKey.escape) {
          controlPageKeyboardListenerNode.requestFocus();
        }
      },
      child: GestureDetector(
        onTap: () => controlPageKeyboardListenerNode.requestFocus(),
        child: PgScaffoldCustom(
          onBack: context.pop,
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: theme.typography.xLarge.fontSize,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: theme.colorScheme.foreground),
              children: [
                TextSpan(text: 'Lounge'),
                TextSpan(text: ' / '),
                WidgetSpan(
                    baseline: TextBaseline.ideographic,
                    child: isWireless
                        ? Icon(
                            Icons.wifi_rounded,
                            size: 22,
                          )
                        : Icon(Icons.usb_rounded)),
                TextSpan(text: ' ${deviceInfo?.deviceName ?? device.modelName}')
              ],
            ),
          ),
          scaffoldBody: stillConnected
              ? ResponsiveBuilder(
                  builder: (context, sizingInfo) {
                    return AnimatedSwitcher(
                      duration: 200.milliseconds,
                      child: sizingInfo.isMobile || sizingInfo.isTablet
                          ? SmallControlPage(device: device)
                          : BigControlPage2(device: device),
                    );
                  },
                )
              : Center(
                  child: Text('Device disconnected'),
                ),
        ),
      ),
    );
  }
}
