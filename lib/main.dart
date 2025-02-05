import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/splash_screen/splash_screen.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 590),
    minimumSize: Size(400, 590),
    center: true,
    backgroundColor: Colors.transparent,
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
        child: MyApp(
          settings: settings,
        ),
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
      ref
          .read(settingsProvider.notifier)
          .update((state) => state = widget.settings);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(),
      darkTheme: FluentThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: SplashScreen(widget.settings.looks),
    );
  }
}
