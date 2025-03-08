// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:collection/collection.dart';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/navigation_shell.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'providers/adb_provider.dart';
import 'providers/scrcpy_provider.dart';
import 'utils/automation_utils.dart';
import 'utils/bonsoir_utils.dart';
import 'utils/const.dart';
import 'utils/tray_utils.dart';

final mainScreenPage = StateProvider((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  final List<Widget> children;
  const MainScreen({super.key, required this.children});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WindowListener, TrayListener, AutomaticKeepAliveClientMixin {
  late BonsoirDiscovery discovery;

  Timer? autoDevicesPingTimer;
  Timer? autoLaunchConfigTimer;
  Timer? runningInstancePingTimer;
  FocusNode node = FocusNode();

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
      await windowManager.setMinimumSize(const Size(480, 580));
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
      await trayManager.destroy();
      await TrayUtils.initTray(ref, context);
    } else {
      await windowManager.show();
      await trayManager.destroy();
      await TrayUtils.initTray(ref, context);
    }

    super.onTrayIconMouseDown();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.watch(pollAdbProvider);

    return Focus(
      focusNode: node,
      child: GestureDetector(
        onTap: node.requestFocus,
        child: NavigationShell(children: widget.children),
      ),
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

class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: children.mapIndexed(
      (int index, Widget navigator) {
        return FadeInUp(
          duration: 100.milliseconds,
          animate: index == currentIndex,
          child: Opacity(
            opacity: index == currentIndex ? 1 : 0,
            child: _branchNavigatorWrapper(index, navigator),
          ),
        );
      },
    ).toList());
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}
