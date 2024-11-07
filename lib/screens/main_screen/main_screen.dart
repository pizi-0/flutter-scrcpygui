// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/screens/main_screen/ms_desktop.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/theme_utils.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_container.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../providers/adb_provider.dart';
import '../../providers/scrcpy_provider.dart';
import '../../utils/adb_utils.dart';
import '../../utils/automation_utils.dart';
import '../../utils/tray_utils.dart';
import '../../widgets/custom_main_screen_appbar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WindowListener, TrayListener {
  Timer? autoDevicesPingTimer;

  @override
  void initState() {
    _init();
    windowManager.addListener(this);
    trayManager.addListener(this);

    super.initState();

    TrayUtils.initTray(ref, context);
    ref.read(adbProvider.notifier).ref.listenSelf((prev, next) async {
      if (prev!.length < next.length) {
        final saved = ref.read(savedAdbDevicesProvider);

        for (final d in next) {
          if (saved.where((s) => d.id == s.id).isEmpty) {
            var dev = d;

            final info = await AdbUtils.getScrcpyDetailsFor(dev);
            dev = dev.copyWith(info: info);

            ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);
            final newSaved = ref.read(savedAdbDevicesProvider);
            await AdbUtils.saveAdbDevice(newSaved);
          }
        }
      }
    });

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

    WidgetsBinding.instance.addPostFrameCallback((a) {
      autoDevicesPingTimer = Timer.periodic(1.seconds, (a) async {
        await AutomationUtils.autoconnectRunner(ref);
      });
    });
  }

  _init() async {
    await windowManager.setPreventClose(true);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    autoDevicesPingTimer?.cancel();
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) async {
    if (eventName == kWindowEventClose) {
      await AppUtils.onAppCloseRequested(ref, context);
    }
    super.onWindowEvent(eventName);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pollAdbProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeUtils.themeData(ref),
      home: Scaffold(
        appBar: const CustomAppbar(),
        body: Stack(
          children: [
            ResponsiveBuilder(
              builder: (context, sizingInformation) {
                switch (sizingInformation.deviceScreenType) {
                  case DeviceScreenType.desktop:
                    return const DesktopMainScreen();
                  case DeviceScreenType.tablet:
                    return const DesktopMainScreen();
                  case DeviceScreenType.mobile:
                    return const DesktopMainScreen();
                  default:
                    return const Text('Default');
                }
              },
            ),
            const SimpleToastContainer()
          ],
        ),
      ),
    );
  }
}
