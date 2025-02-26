// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:collection/collection.dart';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/widgets/title_bar_button.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'providers/adb_provider.dart';
import 'providers/scrcpy_provider.dart';
import 'utils/automation_utils.dart';
import 'utils/bonsoir_utils.dart';
import 'utils/const.dart';
import 'utils/tray_utils.dart';

final mainScreenPage = StateProvider((ref) => 0);
final mainScreenNavViewKey = GlobalKey<NavigationViewState>();

class MainScreen extends ConsumerStatefulWidget {
  final List<Widget> child;
  const MainScreen({super.key, required this.child});

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
    final currentPage = ref.watch(mainScreenPage);

    return Focus(
      focusNode: node,
      child: GestureDetector(
        onTap: node.requestFocus,
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return NavigationView(
              key: mainScreenNavViewKey,
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
                        onPressed: () async {
                          final mode = ref
                              .read(
                                  settingsProvider.select((sett) => sett.looks))
                              .themeMode;
                          if (mode == ThemeMode.dark) {
                            ref
                                .read(settingsProvider.notifier)
                                .changeThememode(ThemeMode.light);
                          } else {
                            ref
                                .read(settingsProvider.notifier)
                                .changeThememode(ThemeMode.dark);
                          }
                          await Db.saveAppSettings(ref.read(settingsProvider));
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
              // transitionBuilder: (child, animation) => FadeInUp(
              //   duration: 100.milliseconds,
              //   child: child,
              // ),
              onDisplayModeChanged: (value) {},
              paneBodyBuilder: (item, body) => AnimatedBranchContainer(
                  currentIndex: currentPage, children: widget.child),
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
                    title: const Text('Home (Alt + 1)'),
                    body: FadeInUp(child: const HomeTab()),
                    onTap: () => context.go('/home'),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.link),
                    title: const Text('Connect'),
                    body: const ConnectTab(),
                    onTap: () => context.go('/connect'),
                  ),
                ],
                footerItems: [
                  PaneItem(
                    icon: const Icon(FluentIcons.movers),
                    title: const Text('Scrcpy manager'),
                    body: const SizedBox.shrink(),
                    onTap: () => context.go('/scrcpy-manager'),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.settings),
                    title: const Text('Settings'),
                    body: const SizedBox.shrink(),
                    onTap: () => context.go('/settings'),
                  ),
                ],
              ),
            );
          },
        ),
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
