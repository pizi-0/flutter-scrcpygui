import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/0.splash_screen/splash_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_manager/config_manager.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/config_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/sub_page/log_screen/log_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/device_control_page.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/device_settings_screen.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/scrcpy_manager.dart';
import 'package:scrcpygui/screens/4.settings_tab/settings_tab.dart';
import 'package:scrcpygui/screens/5.companion_tab/companion_tab.dart';
import 'package:scrcpygui/screens/about_tab/about_tab.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/custom_scheme.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  final settings = await Db.getAppSettings();

  final lastWinSize = await Db.getWinSize();

  WindowOptions windowOptions = WindowOptions(
    size:
        settings.behaviour.rememberWinSize ? lastWinSize : const Size(500, 600),
    minimumSize: Size(500, 600),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  if (Platform.isWindows || Platform.isMacOS) {
    if (await FlutterSingleInstance().isFirstInstance()) {
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });

      runApp(
        ProviderScope(
          child: MyApp(settings: settings),
        ),
      );
    } else {
      logger.i('App is already running');

      final err = await FlutterSingleInstance().focus();

      if (err != null) {
        logger.i('Error focusing window: $err');
      }
      exit(0);
    }
  } else {
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    Db.getAppSettings().then((settings) {
      runApp(
        ProviderScope(
          child: MyApp(settings: settings),
        ),
      );
    });
  }
}

class MyApp extends ConsumerStatefulWidget {
  final AppSettings settings;
  const MyApp({super.key, required this.settings});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) async {
      ref.read(settingsProvider.notifier).setSettings(widget.settings);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final looks = settings.looks;
    final behaviour = settings.behaviour;

    return ShadcnApp.router(
      supportedLocales: supportedLocales,
      locale: Locale(behaviour.languageCode, ''),
      localizationsDelegates: [
        ...localizationsDelegates,
        const ShadcnLocalizationsDelegate()
      ],
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: looks.useOldScheme
            ? looks.scheme.light
            : mySchemeLight(looks.scheme.light.primary),
        radius: looks.widgetRadius,
        surfaceBlur: 0,
        surfaceOpacity: 1,
      ),
      darkTheme: ThemeData(
        colorScheme: looks.useOldScheme
            ? looks.scheme.dark
            : mySchemeDark(looks.scheme.dark.primary),
        radius: looks.widgetRadius,
        surfaceBlur: 0,
        surfaceOpacity: 1,
      ),
      themeMode: looks.themeMode,
      // home: const SplashScreen(),
    );
  }
}

final _rootNavKey = GlobalKey<NavigatorState>();
final _shellNavKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute(
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, navigationShell, children) =>
          MainScreen(children: children),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavKey,
          routes: [
            GoRoute(
              path: HomeTab.route,
              builder: (context, state) => const HomeTab(),
              routes: [
                GoRoute(
                  path: DeviceSettingsScreen.route,
                  builder: (context, state) =>
                      DeviceSettingsScreen(id: state.pathParameters['id']!),
                  pageBuilder: GoTransitions.cupertino.call,
                ),
                GoRoute(
                  path: ConfigScreen.route,
                  builder: (context, state) => const ConfigScreen(),
                  pageBuilder: GoTransitions.cupertino.call,
                ),
                GoRoute(
                  path: LogScreen.route,
                  builder: (context, state) => LogScreen(
                    instance: state.extra as ScrcpyRunningInstance,
                  ),
                  pageBuilder: GoTransitions.cupertino.call,
                ),
                GoRoute(
                  path: ConfigManager.route,
                  builder: (context, state) => ConfigManager(),
                  pageBuilder: GoTransitions.cupertino.call,
                ),
                GoRoute(
                  path: DeviceControlPage.route,
                  builder: (context, state) =>
                      DeviceControlPage(device: state.extra as AdbDevices),
                  pageBuilder: GoTransitions.cupertino.call,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ConnectTab.route,
              builder: (context, state) => const ConnectTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ScrcpyManagerTab.route,
              builder: (context, state) => const ScrcpyManagerTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: CompanionTab.route,
              builder: (context, state) => const CompanionTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: SettingsTab.route,
              builder: (context, state) => const SettingsTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AboutTab.route,
              builder: (context, state) => const AboutTab(),
            ),
          ],
        ),
      ],
    ),
  ],
);
