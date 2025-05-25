import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../utils/const.dart';
import 'app_grid.dart';
import 'instance_manager.dart';

final FocusNode searchBoxFocusNode = FocusNode();

class BigControlPage2 extends ConsumerStatefulWidget {
  final AdbDevices device;
  const BigControlPage2({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BigControlPage2State();
}

class _BigControlPage2State extends ConsumerState<BigControlPage2> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(
      adbProvider,
      (previous, next) {
        if (!next.contains(widget.device)) {
          context.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    return Column(
      spacing: 10,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              ControlButtons(device: device),
              DeviceRunningInstances(device: device),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
          child: Divider(),
        ),
        Expanded(
          child: AppGrid(device: device),
        ),
      ],
    );
  }
}
