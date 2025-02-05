// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/screens/main_screen/small.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/utils/theme_utils.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_container.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../providers/adb_provider.dart';
import '../../providers/scrcpy_provider.dart';
import '../../utils/automation_utils.dart';
import '../../utils/bonsoir_utils.dart';
import '../../utils/const.dart';
import '../../utils/tray_utils.dart';
import '../../widgets/custom_main_screen_appbar.dart';

final mainScreenPage = StateProvider((ref) => 0);

class FlUIMainScreen extends ConsumerStatefulWidget {
  const FlUIMainScreen({super.key});

  @override
  ConsumerState<FlUIMainScreen> createState() => _FlUIMainScreenState();
}

class _FlUIMainScreenState extends ConsumerState<FlUIMainScreen>
    with WindowListener, TrayListener {
  late BonsoirDiscovery discovery;

  Timer? autoDevicesPingTimer;
  Timer? autoLaunchConfigTimer;
  Timer? runningInstancePingTimer;

  @override
  void initState() {
    _init();
    windowManager.addListener(this);
    trayManager.addListener(this);
    discovery = BonsoirDiscovery(type: adbMdns);
    BonsoirUtils.startDiscovery(discovery, ref);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    autoDevicesPingTimer?.cancel();
    autoLaunchConfigTimer?.cancel();
    runningInstancePingTimer?.cancel();
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) async {
    if (eventName == kWindowEventClose) {
      await AppUtils.onAppCloseRequested(ref, context);
    }

    if (eventName == kWindowEventResize) {
      await windowManager.setMinimumSize(const Size(400, 590));
    }

    super.onWindowEvent(eventName);
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
    super.onTrayIconRightMouseDown();
  }

  @override
  void onTrayIconMouseDown() async {
    final visible = await windowManager.isVisible();

    if (visible) {
      await windowManager.hide();
    } else {
      await windowManager.show();
    }

    super.onTrayIconMouseDown();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pollAdbProvider);
    final currentPage = ref.watch(mainScreenPage);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return NavigationView(
          pane: NavigationPane(
            selected: currentPage,
            displayMode: _paneDisplayMode(sizingInformation),
            toggleable: false,
            // header: const Text('SSL'),
            onChanged: (value) {
              ref.read(mainScreenPage.notifier).state = value;
            },
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.home),
                title: const Text('Home'),
                body: const Text('home'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.home),
                title: const Text('Home'),
                body: const Text('home'),
              ),
            ],
            footerItems: [
              PaneItemAction(
                icon: const Icon(FluentIcons.sunny),
                title: const Text('Light mode'),
                onTap: () {},
              ),
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text('Settings'),
                body: const Text('Settings'),
              ),
            ],
          ),
        );
      },
    );
  }

  _paneDisplayMode(SizingInformation size) {
    switch (size.deviceScreenType) {
      case DeviceScreenType.mobile:
        return PaneDisplayMode.auto;
      default:
        return PaneDisplayMode.compact;
    }
  }

  _init() async {
    await windowManager.setPreventClose(true);
    TrayUtils.initTray(ref, context);

    ref.read(scrcpyInstanceProvider.notifier).ref.listenSelf((a, b) async {
      if (!listEquals(a, b)) {
        await trayManager.destroy();
        await TrayUtils.initTray(ref, context);
      }
    });

    ref.read(savedAdbDevicesProvider.notifier).ref.listenSelf(
      (previous, next) async {
        trayManager.destroy();
        await TrayUtils.initTray(ref, context);
      },
    );

    ref.read(adbProvider.notifier).ref.listenSelf(
      (a, b) async {
        if (!listEquals(a, b)) {
          await trayManager.destroy();
          await TrayUtils.initTray(ref, context);
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((a) {
      autoDevicesPingTimer = Timer.periodic(1.seconds, (a) async {
        await AutomationUtils.autoconnectRunner(ref);
      });
      autoLaunchConfigTimer = Timer.periodic(1.seconds, (a) async {
        await AutomationUtils.autoLaunchConfigRunner(ref);
      });
      runningInstancePingTimer = Timer.periodic(1.seconds, (a) async {
        await ScrcpyUtils.pingRunning(ref);
      });
    });
  }
}
