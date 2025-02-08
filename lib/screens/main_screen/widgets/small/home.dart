import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/screens/device_settings_screen/device_settings_screen.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/home_small.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            header: const PageHeader(
              title: Text('Home'),
            ),
            content: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                switch (sizingInformation.deviceScreenType) {
                  case DeviceScreenType.mobile:
                    return const HomeSmall();
                  default:
                    return GridView.builder(
                      itemCount: 2,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 700),
                      itemBuilder: (context, index) => const Text('data'),
                    );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
