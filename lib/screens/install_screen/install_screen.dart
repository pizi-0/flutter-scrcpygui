import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrcpygui/models/dependencies.dart';
import 'package:scrcpygui/providers/dependencies_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main_screen.dart';
import '../../providers/settings_provider.dart';
import '../../utils/const.dart';

class InstallScreen extends ConsumerStatefulWidget {
  const InstallScreen({super.key});

  @override
  ConsumerState<InstallScreen> createState() => _InstallScreenState();
}

class _InstallScreenState extends ConsumerState<InstallScreen> {
  Timer? t;

  _pollDependencies() {
    t = Timer.periodic(const Duration(seconds: 1), (a) async {
      final adb = await AdbUtils.adbInstalled();
      final scrcpy = await ScrcpyUtils.scrcpyInstalled();

      final initialDeps = Dependencies(adb: adb, scrcpy: scrcpy);

      if (initialDeps != ref.read(dependenciesProvider)) {
        ref.read(dependenciesProvider.notifier).update(
            (state) => state = state.copyWith(adb: adb, scrcpy: scrcpy));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pollDependencies();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final dependenciesSatisfied = ref.watch(dependenciesProvider).adb &&
        ref.watch(dependenciesProvider).scrcpy;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSans().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appTheme.color,
          brightness: appTheme.brightness,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        floatingActionButton: dependenciesSatisfied
            ? FloatingActionButton(
                child: const Icon(Icons.chevron_right_rounded),
                onPressed: () async {
                  t?.cancel();
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const MainScreen(),
                          type: PageTransitionType.fade));
                },
              )
            : null,
        body: const DependenciesStatusIndicator(),
      ),
    );
  }
}

class DependenciesStatusIndicator extends ConsumerWidget {
  const DependenciesStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deps = ref.watch(dependenciesProvider);
    return Center(
      child: SizedBox(
        width: appWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Scrcpy'),
                        const SizedBox(width: 20),
                        deps.scrcpy
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ADB'),
                        const SizedBox(width: 20),
                        deps.adb
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (!deps.scrcpy || !deps.adb)
              const Column(
                children: [SizedBox(height: 20), SiteLink()],
              ),
          ],
        ),
      ),
    );
  }
}

class SiteLink extends StatelessWidget {
  const SiteLink({super.key});

  _launchURL(String url) {
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    switch (Platform.operatingSystem) {
      case 'windows':
        return FittedBox(
          child: TextButton(
            child: const Text(
              'https://github.com/Genymobile/scrcpy/blob/master/doc/windows.md',
            ),
            onPressed: () => _launchURL(
                'https://github.com/Genymobile/scrcpy/blob/master/doc/windows.md'),
          ),
        );
      case 'macos':
        return FittedBox(
          child: TextButton(
            child: const Text(
              'https://github.com/Genymobile/scrcpy/blob/master/doc/macos.md',
            ),
            onPressed: () => _launchURL(
                'https://github.com/Genymobile/scrcpy/blob/master/doc/macos.md'),
          ),
        );
      case ('linux'):
        return FittedBox(
          child: TextButton(
            child: const Text(
              'https://github.com/Genymobile/scrcpy/blob/master/doc/linux.md',
            ),
            onPressed: () => _launchURL(
                'https://github.com/Genymobile/scrcpy/blob/master/doc/linux.md'),
          ),
        );
      default:
        return const Text('Unsupported');
    }
  }
}
