import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/info_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/tray_utils.dart';
import 'package:scrcpygui/widgets/start_stop_button.dart';
import 'package:tray_manager/tray_manager.dart';

import '../../utils/const.dart';
import '../../widgets/config_selector.dart';
import '../../widgets/connected_device_view.dart';

class DesktopMainScreen extends ConsumerStatefulWidget {
  const DesktopMainScreen({super.key});

  @override
  ConsumerState<DesktopMainScreen> createState() => _DesktopMainScreenState();
}

class _DesktopMainScreenState extends ConsumerState<DesktopMainScreen>
    with TrayListener {
  ScrollController scroll = ScrollController();

  @override
  void initState() {
    TrayUtils.initTray(ref, context);
    trayManager.addListener(this);
    ref.read(adbProvider.notifier).ref.listenSelf((prev, next) async {
      if (prev!.length < next.length) {
        final currentInfo = ref.read(infoProvider);

        for (final d in next) {
          if (currentInfo
              .where((i) => i.device.serialNo == d.serialNo)
              .isEmpty) {
            final info = await AdbUtils.getScrcpyDetailsFor(d);
            ref.read(infoProvider.notifier).addInfo(info);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: MainScreenFAB(scroll: scroll),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: scroll,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: const SizedBox(
                      width: appWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConnectedDevicesView(),
                            ConfigSelector(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
