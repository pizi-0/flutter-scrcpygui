import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/config_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/device_settings_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/home.dart';

import 'widgets/bottom_bar/home_bottom_bar.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/dev_settings') {
          return CupertinoPageRoute(
              builder: (context) => DeviceSettingsScreen(
                  device: settings.arguments as AdbDevices));
        }

        if (settings.name == '/create_config') {
          return CupertinoPageRoute(builder: (context) => const ConfigScreen());
        }

        return FluentPageRoute(
          builder: (context) => ScaffoldPage.withPadding(
            bottomBar: const HomeBottomBar(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            header: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: PageHeader(
                title: Text('Home'),
              ),
            ),
            content: const Home(),
          ),
        );
      },
    );
  }
}
