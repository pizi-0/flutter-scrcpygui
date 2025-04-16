// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config_tags.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/connection_error_dialog.dart';
// import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/configs_list_extension.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../providers/app_config_pair_provider.dart';
import '../../utils/app_utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String loadingText = 'Loading...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await _init().then((value) {
          context.pushReplacement('/home');
        });
      } on ProcessException catch (e) {
        logger.e(e);

        loadingText = el.statusLoc.error;
        setState(() {});

        showDialog(
          context: context,
          builder: (context) =>
              ErrorDialog(title: el.statusLoc.error, content: [
            Text(e.message),
            Text('Executable: ${e.executable}'),
          ]),
        );
      }
    });
  }

  Future<void> _init() async {
    final start = DateTime.now().millisecondsSinceEpoch;
    final settings = ref.read(settingsProvider);

    await SetupUtils.initScrcpy(ref);

    ref.read(appVersionProvider.notifier).state =
        await AppUtils.getAppVersion();

    // final workDir = ref.read(execDirProvider);
    final savedDevices = await Db.getSavedAdbDevice();

    ref.read(savedAdbDevicesProvider.notifier).setDevices(savedDevices);

    final confs = await Db.getSavedConfig();

    for (final c in confs) {
      ref.read(configsProvider.notifier).addConfig(c);
    }

    final allConfigs = ref.read(configsProvider);
    final lastUsedConfig = await Db.getLastUsedConfig(ref);
    ref.read(selectedConfigProvider.notifier).state = allConfigs.firstWhere(
        (conf) => conf == lastUsedConfig,
        orElse: () => defaultMirror);

    if (settings.behaviour.hideDefaultConfig) {
      ref.read(configTags.notifier).addTag(ConfigTag.customConfig);
      final filtered = allConfigs.filterByAnyTag([ConfigTag.customConfig]);

      if (!filtered.contains(lastUsedConfig)) {
        ref.read(selectedConfigProvider.notifier).state = filtered.firstOrNull;
      }
    }

    // final adbDevices = await AdbUtils.connectedDevices(workDir);
    // ref.read(adbProvider.notifier).setConnected(adbDevices, savedDevices);

    final wirelessHistory = await Db.getWirelessHistory();
    ref.read(ipHistoryProvider.notifier).update((state) => wirelessHistory);

    final appConfigPairs = await Db.getAppConfigPairs();
    ref.read(appConfigPairProvider.notifier).setPairs(appConfigPairs);

    final pid = await AppUtils.getAppPid();

    ref.read(appPidProvider.notifier).update((state) => state = pid);

    final end = DateTime.now().millisecondsSinceEpoch;

    if ((end - start) < 300) {
      await Future.delayed(Duration(milliseconds: 300 - (end - start)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
            ),
            const SizedBox(height: 20),
            Text(loadingText)
          ],
        ),
      ),
    );
  }
}
