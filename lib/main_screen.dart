import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrcpygui/providers/poll_provider.dart';
import 'package:scrcpygui/providers/theme_provider.dart';
import 'package:scrcpygui/screens/main_screen/ms_desktop.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_container.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:window_manager/window_manager.dart';

import 'widgets/custom_main_screen_appbar.dart';

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
    final appTheme = ref.watch(appThemeProvider);
    ref.watch(pollAdbProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appTheme.color,
          brightness: appTheme.brightness,
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
