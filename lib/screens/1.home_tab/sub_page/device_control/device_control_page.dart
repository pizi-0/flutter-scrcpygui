import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/navigation_shell.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'widgets/big_control_page.dart';
import 'widgets/small_control_page.dart';

class DeviceControlPage extends ConsumerStatefulWidget {
  static const route = 'device-control';
  final AdbDevices device;
  const DeviceControlPage({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceControlPageState();
}

class _DeviceControlPageState extends ConsumerState<DeviceControlPage> {
  final FocusNode klNode = FocusNode(debugLabel: 'keyboard-listener');

  ScrcpyConfig? config;

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    return KeyboardListener(
      focusNode: klNode,
      autofocus: true,
      onKeyEvent: (value) async {
        if (value.physicalKey == PhysicalKeyboardKey.slash) {
          if (!searchBoxFocusNode.hasFocus) {
            await Future.delayed(10.milliseconds);
            searchBoxFocusNode.requestFocus();
          }
        }

        if (value.physicalKey == PhysicalKeyboardKey.escape) {
          klNode.requestFocus();
        }
      },
      child: GestureDetector(
        onTap: () => klNode.requestFocus(),
        child: PgScaffoldCustom(
          onBack: context.pop,
          title: 'Lounge / ${device.name}',
          scaffoldBody: ResponsiveBuilder(
            builder: (context, sizingInfo) {
              double sidebarWidth = 52;

              if (sizingInfo.isTablet || sizingInfo.isDesktop) {
                sidebarWidth = _findSidebarWidth();
              }

              if (sizingInfo.isMobile) {
                sidebarWidth = 52;
              }
              bool wrapped = sizingInfo.screenSize.width >=
                  ((appWidth * 2) + sidebarWidth + 40);

              if (!wrapped) {
                return SmallControlPage(device: device);
              } else {
                return BigControlPage(device: device);
              }
            },
          ),
        ),
      ),
    );
  }

  _findSidebarWidth() {
    final box = sidebarKey.currentContext?.findRenderObject();

    if (box != null) {
      return (box as RenderBox).size.width;
    } else {
      return 0;
    }
  }
}
