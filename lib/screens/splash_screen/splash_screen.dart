// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pg_scrcpy/main_screen.dart';
import 'package:pg_scrcpy/models/app_theme.dart';
import 'package:pg_scrcpy/providers/adb_provider.dart';
import 'package:pg_scrcpy/providers/config_provider.dart';
import 'package:pg_scrcpy/providers/dependencies_provider.dart';
import 'package:pg_scrcpy/providers/scrcpy_provider.dart';
import 'package:pg_scrcpy/providers/toast_providers.dart';
import 'package:pg_scrcpy/utils/adb_utils.dart';
import 'package:pg_scrcpy/utils/scrcpy_utils.dart';

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
      var toastEnabled = await AppUtils.getNotiPreference();
      ref.read(toastEnabledProvider.notifier).state = toastEnabled;

      var adbDevices = await AdbUtils.connectedDevices();
      ref.read(adbProvider.notifier).setConnected(adbDevices);

      var savedDevices = await AdbUtils.getSavedAdbDevice();
      ref
          .read(savedAdbDevicesProvider.notifier)
          .update((state) => savedDevices);

      var wirelessHistory = await AdbUtils.getWirelessHistory();
      ref
          .read(wirelessDevicesHistoryProvider.notifier)
          .update((state) => wirelessHistory);

      var confs = await ScrcpyUtils.getSavedConfig();

      for (final c in confs) {
        ref.read(configsProvider.notifier).addConfig(c);
      }

      ref.read(selectedConfigProvider.notifier).state =
          await ScrcpyUtils.getLastUsedConfig();

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
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: widget.theme.color,
          brightness: widget.theme.brightness,
        ),
        useMaterial3: true,
      ),
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
