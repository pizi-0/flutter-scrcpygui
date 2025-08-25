// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/app_grid_settings_provider.dart';
import 'package:scrcpygui/providers/server_settings_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/connection_error_dialog.dart';
// import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../providers/app_config_pair_provider.dart';
import '../../providers/automation_provider.dart';
import '../../providers/device_info_provider.dart';
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

    await SetupUtils.initScrcpy(ref);

    ref.read(appVersionProvider.notifier).state =
        await AppUtils.getAppVersion();

    final deviceInfos = await Db.getDeviceInfos();
    ref.read(infoProvider.notifier).setDevicesInfo(deviceInfos);

    final confs = await Db.getSavedConfig();
    for (final c in confs) {
      ref.read(configsProvider.notifier).addConfig(c);
    }

    for (final c in defaultConfigs) {
      if (!confs.contains(c)) {
        ref.read(configsProvider.notifier).addConfig(c);
      }
    }

    final allConfigs = ref.read(configsProvider);

    final hidden = await Db.getHiddenConfigs();
    ref.read(hiddenConfigsProvider.notifier).state = hidden;

    final lastUsedConfig = await Db.getLastUsedConfig(ref);
    ref
        .read(selectedConfigProvider.notifier)
        .state = allConfigs.firstWhereOrNull(
            (conf) => conf == lastUsedConfig && !hidden.contains(conf.id)) ??
        allConfigs.firstWhereOrNull((conf) => !hidden.contains(conf.id));

    final wirelessHistory = await Db.getWirelessHistory();
    ref.read(ipHistoryProvider.notifier).update((state) => wirelessHistory);

    final appConfigPairs = await Db.getAppConfigPairs();
    final finalPairs = appConfigPairs
        .where((p) => allConfigs.where((c) => c.id == p.config.id).isNotEmpty)
        .toList();
    ref.read(appConfigPairProvider.notifier).setPairs(finalPairs);

    final pid = await AppUtils.getAppPid();

    final companionServerSettings = await Db.getCompanionServerSettings();

    if (companionServerSettings != null) {
      ref
          .read(companionServerProvider.notifier)
          .setSettings(companionServerSettings);
    }

    ref.read(appPidProvider.notifier).update((state) => state = pid);

    final autoConnects = await Db.getAutoConnect();
    ref.read(autoConnectProvider.notifier).setList(autoConnects);

    final autoLaunches = await Db.getAutoLaunch();
    ref.read(autoLaunchProvider.notifier).setList(autoLaunches);

    final appGridSettings = await Db.getAppGridSettings();
    ref.read(appGridSettingsProvider.notifier).setSettings(appGridSettings);

    if (appGridSettings.lastUsedConfig != null) {
      final controlPageConfig = allConfigs.firstWhereOrNull(
          (conf) => conf.id == appGridSettings.lastUsedConfig);

      if (controlPageConfig != null) {
        ref.read(controlPageConfigProvider.notifier).state = controlPageConfig;
      }
    }

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
