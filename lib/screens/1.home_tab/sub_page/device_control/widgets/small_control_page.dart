// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/device_info_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/app_grid.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import '../../../../../utils/const.dart';

class SmallControlPage extends ConsumerStatefulWidget {
  const SmallControlPage({
    super.key,
    required this.device,
  });

  final AdbDevices device;

  @override
  ConsumerState<SmallControlPage> createState() => _SmallControlPageState();
}

class _SmallControlPageState extends ConsumerState<SmallControlPage> {
  ScrcpyApp? selectedApp;
  bool loading = false;
  ScrollController scrollController = ScrollController();
  double controlsHeight = 109.3;

  @override
  void initState() {
    super.initState();
    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == widget.device.serialNo);

    scrollController.addListener(
      () {
        if (scrollController.offset >
                scrollController.position.maxScrollExtent / 5 &&
            controlsHeight != 0) {
          controlsHeight = 0;
          setState(() {});
        }

        if (scrollController.offset == 0 && controlsHeight != 109.3) {
          if (controlsHeight != 109.3) {
            controlsHeight = 109.3;
            setState(() {});
          }
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (deviceInfo == null) {
        _getInfo();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _getInfo() async {
    try {
      final workDir = ref.read(execDirProvider);
      final info = await AdbUtils.getDeviceInfoFor(workDir, widget.device);
      ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);

      await Db.saveDeviceInfos(ref.read(infoProvider));
    } on Exception catch (e) {
      logger.e(e);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == device.serialNo);

    final appsList = deviceInfo?.appList ?? [];

    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Column(
      spacing: 8,
      children: [
        if (deviceInfo == null)
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              CircularProgressIndicator(),
              Text(el.statusLoc.gettingInfo).textSmall.muted,
            ],
          ))
        else
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: appWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  AnimatedContainer(
                    duration: 200.milliseconds,
                    height: controlsHeight,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: ControlButtons(device: device),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AppGrid(
                      device: device,
                      persistentHeader: false,
                      scrollController: scrollController,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
