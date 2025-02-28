import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/0.splash_screen/splash_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/config_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/config_screen/sub_page/log_screen/log_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/device_settings_screen.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/scrcpy_manager.dart';
import 'package:scrcpygui/screens/4.settings_tab/settings_tab.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(480, 500),
    minimumSize: Size(480, 500),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
  );
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

    return FluentApp.router(
      supportedLocales: const [
        ...supportedLocales,
        ...FluentLocalizations.supportedLocales
      ],
      locale: Locale(behaviour.languageCode, ''),
      localizationsDelegates: [
        ...localizationsDelegates,
        FluentLocalizations.delegate
      ],
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        accentColor: looks.accentColor,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor:
              looks.accentColor.lighten(looks.accentTintLevel.toInt()),
          overlayBackgroundColor:
              looks.accentColor.lighten(looks.accentTintLevel.toInt()),
        ),
        cardColor: looks.accentColor.lighten(looks.accentTintLevel.toInt()),
        scaffoldBackgroundColor: looks.accentColor
            .lighten((looks.accentTintLevel.toInt() + 10).clamp(0, 100)),
        // menuColor: looks.accentColor.lighten((looks.accentTintLevel.toInt() * 0.95).toInt()),
        // cardColor: looks.accentColor.darken(90),
        micaBackgroundColor: looks.accentColor
            .lighten((looks.accentTintLevel.toInt() * 0.85).toInt()),
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: looks.accentColor,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor:
              looks.accentColor.darken(looks.accentTintLevel.toInt()),
          overlayBackgroundColor:
              looks.accentColor.darken(looks.accentTintLevel.toInt()),
        ),
        cardColor: const ResourceDictionary.dark()
            .layerOnMicaBaseAltFillColorSecondary,
        menuColor: looks.accentColor
            .darken((looks.accentTintLevel.toInt() * 0.8).toInt()),
        // cardColor: looks.accentColor.darken(90),
        micaBackgroundColor: looks.accentColor
            .darken((looks.accentTintLevel.toInt() * 0.85).toInt()),
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
          MainScreen(child: children),
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
              path: SettingsTab.route,
              builder: (context, state) => const SettingsTab(),
            ),
          ],
        ),
      ],
    ),
  ],
);
