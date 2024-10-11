// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrcpygui/providers/toast_providers.dart';
import 'package:scrcpygui/screens/settings_screen/settings_screen.dart';
import 'package:scrcpygui/utils/tray_utils.dart';
import 'package:window_manager/window_manager.dart';

import '../providers/theme_provider.dart';
import '../utils/app_utils.dart';

class CustomAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _CustomAppbarState extends ConsumerState<CustomAppbar> {
  StreamSubscription? colorStream;

  _pollColor() {
    File file = File('/home/pizi/.cache/wal/colors.css');

    colorStream = file.watch().listen(
      (event) {
        if (event.type == FileSystemEvent.modify) {
          AppUtils.getPrimaryColor().then((c) {
            if (c != ref.read(appThemeProvider).color) {
              final currentTheme = ref.read(appThemeProvider);
              ref
                  .read(appThemeProvider.notifier)
                  .setTheme(currentTheme.copyWith(color: c));
            }
          });
        }
      },
    );
  }

  @override
  void initState() {
    if (ref.read(appThemeProvider).fromWall) {
      _pollColor();
    }
    super.initState();
  }

  @override
  void dispose() {
    colorStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          style: buttonStyle,
          onPressed: () async {
            await AppUtils.onAppCloseRequested(ref, context);
          },
          icon: const Icon(Icons.close_rounded, color: Colors.red),
        ),
        IconButton(
          style: buttonStyle,
          tooltip: 'Hide window',
          onPressed: () async {
            await windowManager.hide();
            await TrayUtils.initTray(ref, context);
          },
          icon: const Icon(Icons.minimize_rounded, color: Colors.yellow),
        ),
        const Expanded(child: DragToMoveArea(child: SizedBox.expand())),
        IconButton(
          style: buttonStyle,
          tooltip: ref.watch(toastEnabledProvider)
              ? 'Disable notification popup'
              : 'Enable notification popup',
          onPressed: () {
            ref
                .read(toastEnabledProvider.notifier)
                .update((state) => state = !state);
            AppUtils.saveNotiPreference(ref);
          },
          icon: Icon(
            ref.watch(toastEnabledProvider)
                ? Icons.notifications_rounded
                : Icons.notifications_off_rounded,
            color: ref.watch(toastEnabledProvider) ? Colors.green : Colors.red,
          ),
        ),
        IconButton(
          style: buttonStyle,
          tooltip: ref.watch(appThemeProvider).brightness == Brightness.dark
              ? 'Light mode'
              : 'Dark mode',
          onPressed: () =>
              ref.read(appThemeProvider.notifier).toggleBrightness(),
          icon: Icon(
            ref.watch(appThemeProvider).brightness == Brightness.dark
                ? Icons.sunny
                : Icons.nightlight_round,
            color: Colors.orange,
          ),
        ),
        IconButton(
          style: buttonStyle,
          tooltip: 'Settings',
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const SettingsScreen(),
                    type: PageTransitionType.rightToLeft));
          },
          icon: Icon(
            Icons.settings_rounded,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
