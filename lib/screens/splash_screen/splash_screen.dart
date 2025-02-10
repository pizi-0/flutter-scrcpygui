// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/main_screen/main_screen.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/utils/setup.dart';

import '../../utils/app_utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init().then((value) {
        Navigator.pushReplacement(
            context, FluentPageRoute(builder: (context) => const MainScreen()));
      });
    });
  }

  Future<void> _init() async {
    final start = DateTime.now().millisecondsSinceEpoch;

    await SetupUtils.initScrcpy(ref);

    final workDir = ref.read(execDirProvider);
    var savedDevices = await AdbUtils.getSavedAdbDevice();

    ref.read(savedAdbDevicesProvider.notifier).setDevices(savedDevices);

    var confs = await ScrcpyUtils.getSavedConfig();

    for (final c in confs) {
      ref.read(configsProvider.notifier).addConfig(c);
    }

    var adbDevices = await AdbUtils.connectedDevices(workDir);
    ref.read(adbProvider.notifier).setConnected(adbDevices, savedDevices);

    var wirelessHistory = await AdbUtils.getWirelessHistory();
    ref
        .read(wirelessDevicesHistoryProvider.notifier)
        .update((state) => wirelessHistory);

    final pid = await AppUtils.getAppPid();

    ref.read(appPidProvider.notifier).update((state) => state = pid);

    final end = DateTime.now().millisecondsSinceEpoch;

    if ((end - start) < 300) {
      await Future.delayed(Duration(milliseconds: 300 - (end - start)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
            ),
            const SizedBox(height: 20),
            const Text('Loading..')
          ],
        ),
      ),
    );
  }
}
