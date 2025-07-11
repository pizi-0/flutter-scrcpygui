import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/config_list.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../db/db.dart';
import '../../../../../models/adb_devices.dart';
import '../../../../../providers/device_info_provider.dart';
import '../../../../../providers/version_provider.dart';
import '../../../../../utils/adb_utils.dart';
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
    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == widget.device.serialNo);

    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (deviceInfo == null) {
        _getInfo();
      }
    });
  }

  Future<void> _getInfo() async {
    try {
      final workDir = ref.read(execDirProvider);
      final info = await AdbUtils.getDeviceInfoFor(workDir, widget.device);
      ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);

      await Db.saveDeviceInfos(ref.read(infoProvider));
    } on Exception catch (e) {
      logger.e(e);
      // ignore: use_build_context_synchronously
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == device.serialNo);

    if (deviceInfo == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          CircularProgressIndicator(),
          Text(el.statusLoc.gettingInfo).textSmall.muted,
        ],
      );
    } else {
      return AnimatedSize(
        duration: 200.milliseconds,
        child: Row(
          spacing: 8,
          children: [
            LeftColumn(
              shouldAlign: false,
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  ControlButtons(device: device),
                  Expanded(child: DeviceRunningInstances(device: device)),
                  ConfigListSmall(
                    showConfigManagerButton: false,
                  ),
                ],
              ),
            ),
            RightColumn(
                shouldAlign: false, flex: 5, child: AppGrid(device: device)),
          ],
        ),
      );
    }
  }
}
