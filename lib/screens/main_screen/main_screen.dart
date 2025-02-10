// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/main.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/home.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/wifi_adb_small.dart';
import 'package:scrcpygui/screens/update_screen/update_screen.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/widgets/title_bar_button.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../providers/adb_provider.dart';
import '../../providers/scrcpy_provider.dart';
import '../../utils/automation_utils.dart';
import '../../utils/bonsoir_utils.dart';
import '../../utils/const.dart';
import '../../utils/tray_utils.dart';

final mainScreenPage = StateProvider((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WindowListener, TrayListener, AutomaticKeepAliveClientMixin {
  late BonsoirDiscovery discovery;

  Timer? autoDevicesPingTimer;
  Timer? autoLaunchConfigTimer;
  Timer? runningInstancePingTimer;

  @override
  void initState() {
    _init();
    windowManager.addListener(this);
    trayManager.addListener(this);
    try {
      discovery = BonsoirDiscovery(type: adbMdns);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
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
      await windowManager.setMinimumSize(const Size(480, 500));
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
    super.build(context);
    ref.watch(pollAdbProvider);
    final currentPage = ref.watch(mainScreenPage);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return NavigationView(
          appBar: NavigationAppBar(
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 20,
                  width: 20,
                ),
                Expanded(
                    child: DragToMoveArea(
                        child: Row(
                  spacing: 4,
                  children: [
                    const Text('Scrcpy GUI').alignAtCenterLeft(),
                    const Text('by pizi-0', style: TextStyle(fontSize: 8))
                  ],
                ))),
                Center(
                  child: IconButton(
                    icon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FluentIcons.sunny),
                    ),
                    onPressed: () {
                      final mode = ref.read(tempThemeMode);
                      if (mode == ThemeMode.dark) {
                        ref.read(tempThemeMode.notifier).state =
                            ThemeMode.light;
                      } else {
                        ref.read(tempThemeMode.notifier).state = ThemeMode.dark;
                      }
                    },
                  ),
                ),
                const Divider(
                  direction: Axis.vertical,
                ),
                const TitleBarButton(),
              ],
            ),
          ),
          transitionBuilder: (child, animation) => FadeInUp(
            duration: 100.milliseconds,
            child: child,
          ),
          onDisplayModeChanged: (value) {},
          pane: NavigationPane(
            selected: currentPage,
            displayMode: PaneDisplayMode.compact,
            // header: const Text('SSL'),
            onChanged: (value) {
              ref.read(mainScreenPage.notifier).state = value;
            },
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.home),
                title: const Text('Home'),
                body: const Home(),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.link),
                title: const Text('Connect'),
                body: const WifiScanner(),
              ),
            ],
            footerItems: [
              PaneItem(
                icon: const Icon(FluentIcons.movers),
                title: const Text('Update'),
                body: const UpdateScreen(),
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

  _init() async {
    await windowManager.setPreventClose(true);
    TrayUtils.initTray(ref, context);

    ref.read(scrcpyInstanceProvider.notifier).ref.listenSelf((a, b) async {
      if (!listEquals(a, b)) {
        if (mounted) {
          await trayManager.destroy();
          await TrayUtils.initTray(ref, context);
        }
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

  @override
  bool get wantKeepAlive => true;
}
