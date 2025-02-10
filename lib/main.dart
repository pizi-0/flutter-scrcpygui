import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/splash_screen/splash_screen.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:window_manager/window_manager.dart';

final tempThemeMode = StateProvider((ref) => ThemeMode.dark);

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

  AppUtils.getAppSettings().then((settings) {
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
    final looks = ref.watch(settingsProvider.select((sett) => sett.looks));

    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        accentColor: looks.accentColor,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: looks.accentColor.lighten(95),
          overlayBackgroundColor: looks.accentColor.lighten(95),
        ),
        cardColor: looks.accentColor.lighten(95),
        scaffoldBackgroundColor: looks.accentColor.lighten(100),
        menuColor: looks.accentColor.lighten(95),
        // cardColor: looks.accentColor.darken(90),
        micaBackgroundColor: looks.accentColor.lighten(80),
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: looks.accentColor,
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor: looks.accentColor.darken(90),
          overlayBackgroundColor: looks.accentColor.darken(90),
        ),

        cardColor: const ResourceDictionary.dark()
            .layerOnMicaBaseAltFillColorSecondary,
        menuColor: looks.accentColor.darken(60),
        // cardColor: looks.accentColor.darken(90),
        micaBackgroundColor: looks.accentColor.darken(80),
      ),
      themeMode: looks.themeMode,
      home: const SplashScreen(),
    );
  }
}
