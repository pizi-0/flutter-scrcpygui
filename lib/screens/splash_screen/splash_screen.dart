// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrcpygui/screens/main_screen/main_screen.dart';
import 'package:scrcpygui/models/settings_model/app_theme.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/dependencies_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/utils/theme_utils.dart';

import '../../utils/app_utils.dart';
import '../install_screen/install_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final AppTheme theme;
  const SplashScreen(this.theme, {super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init().then((value) {
        final dep = ref.read(dependenciesProvider);

        bool dependenciesSatisfied = dep.adb && dep.scrcpy;
        if (dependenciesSatisfied) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const MainScreen(), type: PageTransitionType.fade));
        } else {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const InstallScreen(), type: PageTransitionType.fade));
        }
      });
    });
  }

  Future<void> _init() async {
    final start = DateTime.now().millisecondsSinceEpoch;

    final adb = await AdbUtils.adbInstalled();
    final scrcpy = await ScrcpyUtils.scrcpyInstalled();
    ref
        .read(dependenciesProvider.notifier)
        .update((state) => state = state.copyWith(adb: adb, scrcpy: scrcpy));

    if (adb && scrcpy) {
      var savedDevices = await AdbUtils.getSavedAdbDevice();

      ref.read(savedAdbDevicesProvider.notifier).setDevices(savedDevices);

      var confs = await ScrcpyUtils.getSavedConfig();

      for (final c in confs) {
        ref.read(configsProvider.notifier).addConfig(c);
      }

      var adbDevices = await AdbUtils.connectedDevices();
      ref.read(adbProvider.notifier).setConnected(adbDevices);

      var wirelessHistory = await AdbUtils.getWirelessHistory();
      ref
          .read(wirelessDevicesHistoryProvider.notifier)
          .update((state) => wirelessHistory);

      ref.read(selectedConfigProvider.notifier).state =
          await ScrcpyUtils.getLastUsedConfig(ref);

      ref.read(autoConnectDevicesProvider.notifier).state =
          await AdbUtils.getAutoConnectDevices();

      final pid = await AppUtils.getAppPid();

      ref.read(appPidProvider.notifier).update((state) => state = pid);
    }

    final end = DateTime.now().millisecondsSinceEpoch;

    if ((end - start) < 300) {
      await Future.delayed(Duration(milliseconds: 300 - (end - start)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeUtils.themeData(ref),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.adb_rounded,
                size: 50,
              ),
              SizedBox(height: 20),
              Text('Loading..')
            ],
          ),
        ),
      ),
    );
  }
}
