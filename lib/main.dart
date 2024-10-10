import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrcpygui/models/app_theme.dart';
import 'package:scrcpygui/providers/theme_provider.dart';
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

  AppUtils.getAppTheme().then((t) {
    if (t.fromWall) {
      AppUtils.getPrimaryColor().then(
        (c) => runApp(
          ProviderScope(
            child: MyApp(
              theme: AppTheme(
                widgetRadius: t.widgetRadius,
                color: c,
                brightness: t.brightness,
                fromWall: t.fromWall,
              ),
            ),
          ),
        ),
      );
    } else {
      runApp(
        ProviderScope(
          child: MyApp(
            theme: AppTheme(
              widgetRadius: t.widgetRadius,
              color: t.color,
              brightness: t.brightness,
              fromWall: t.fromWall,
            ),
          ),
        ),
      );
    }
  });
}

class MyApp extends ConsumerStatefulWidget {
  final AppTheme theme;
  const MyApp({super.key, required this.theme});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) async {
      ref.read(appThemeProvider.notifier).setTheme(widget.theme);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appTheme.color,
          brightness: appTheme.brightness,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(widget.theme),
    );
  }
}
