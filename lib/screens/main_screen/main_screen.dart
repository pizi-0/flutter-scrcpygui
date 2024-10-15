// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/screens/main_screen/ms_desktop.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_container.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../providers/scrcpy_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/tray_utils.dart';
import '../../widgets/custom_main_screen_appbar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
    ref.read(scrcpyInstanceProvider.notifier).ref.listenSelf((a, b) async {
      if (!listEquals(a, b)) {
        await trayManager.destroy();
        await TrayUtils.initTray(ref, context);
      }
    });
  }

  _init() async {
    await windowManager.setPreventClose(true);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
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
    final looks = ref.watch(settingsProvider.select((s) => s.looks));
    ref.watch(pollAdbProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: looks.color,
          brightness: looks.brightness,
          tertiaryContainer: looks.brightness == Brightness.dark
              ? looks.color.lighten((looks.colorModifier).toInt())
              : looks.color.darken((looks.colorModifier).toInt()),
          secondaryContainer: looks.brightness == Brightness.dark
              ? looks.color.darken((looks.colorModifier * 0.8).toInt())
              : looks.color.lighten((looks.colorModifier * 0.8).toInt()),
          primaryContainer: looks.brightness == Brightness.dark
              ? looks.color.darken((looks.colorModifier * 0.2).toInt())
              : looks.color.lighten((looks.colorModifier * 0.2).toInt()),
          surface: looks.brightness == Brightness.dark
              ? looks.color.darken(looks.colorModifier)
              : looks.color.lighten(looks.colorModifier),
        ),
        useMaterial3: true,
      ),
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
