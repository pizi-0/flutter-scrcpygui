// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/utils/custom_scheme.dart';
import 'package:scrcpygui/widgets/extractor_indicator.dart';
import 'package:scrcpygui/widgets/navigation_shell.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../providers/icon_extractor_provider.dart';
import '../../providers/settings_provider.dart';
import '../../screens/1.home_tab/sub_page/config_screen/config_screen.dart';
import '../../screens/3.scrcpy_manager_tab/scrcpy_manager.dart';
import '../../screens/4.settings_tab/settings_tab.dart';
import '../../screens/5.companion_tab/companion_tab.dart';
import '../../screens/about_tab/about_tab.dart';

class PgNavigationRail extends ConsumerStatefulWidget {
  final Color? backgroundColor;
  const PgNavigationRail({super.key, this.backgroundColor});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PgNavigationRailState();
}

class _PgNavigationRailState extends ConsumerState<PgNavigationRail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _width;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _width = CurvedAnimation(parent: _controller, curve: Curves.decelerate);

    _width = Tween<double>(begin: 50, end: 200).animate(_width);

    ref.listenManual(
      appSideBarStateProvider,
      (previous, next) {
        if (next) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toExtract = ref.watch(iconsToExtractProvider);

    return TapRegion(
      onTapOutside: (event) =>
          ref.read(appSideBarStateProvider.notifier).state = false,
      child: AnimatedBuilder(
        animation: _width,
        builder: (context, child) => OutlinedContainer(
          surfaceBlur: theme.surfaceBlur,
          surfaceOpacity: theme.surfaceOpacity,
          borderColor: Colors.transparent,
          backgroundColor: background(context),
          borderWidth: 0,
          width: _width.value,
          borderRadius: BorderRadius.zero,
          child: child!,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              PgNavRailButton(
                icon: Icons.menu_rounded,
                label: 'Menu',
              ),
              const Divider(),
              PgNavRailButton(
                index: 0,
                icon: Icons.home_rounded,
                label: el.homeLoc.title,
                route: HomeTab.route,
              ),
              PgNavRailButton(
                index: 1,
                icon: Icons.link_rounded,
                label: el.connectLoc.title,
                route: ConnectTab.route,
              ),
              PgNavRailButton(
                index: 2,
                icon: Icons.system_update_alt_rounded,
                label: el.scrcpyManagerLoc.title,
                route: ScrcpyManagerTab.route,
              ),
              PgNavRailButton(
                index: 3,
                icon: Icons.phone_android_rounded,
                label: el.companionLoc.title,
                route: CompanionTab.route,
              ),
              Divider(),
              PgNavRailButton(
                index: 4,
                icon: Icons.settings_rounded,
                label: el.settingsLoc.title,
                route: SettingsTab.route,
              ),
              Divider(),
              PgNavRailButton(
                index: 5,
                icon: Icons.info_rounded,
                label: el.aboutLoc.title,
                route: AboutTab.route,
              ),
              Spacer(),
              if (toExtract.isNotEmpty) ExtractorIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class PgNavRailButton extends ConsumerStatefulWidget {
  final int? index;
  final IconData icon;
  final String label;
  final String? route;

  const PgNavRailButton({
    super.key,
    required this.icon,
    this.index,
    this.route,
    required this.label,
  });

  @override
  ConsumerState<PgNavRailButton> createState() => _PgNavRailButtonState();
}

class _PgNavRailButtonState extends ConsumerState<PgNavRailButton> {
  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(mainScreenPage) == widget.index;
    final expanded = ref.watch(appSideBarStateProvider);
    final theme = Theme.of(context);
    final preventNavigation = ref.watch(preventNavigationProvider);

    return Button(
      style: selected
          ? ButtonStyle.primary(density: ButtonDensity.compact)
          : ButtonStyle.ghost(density: ButtonDensity.compact),
      onPressed: () async {
        if (widget.index != null) {
          bool navigate = true;
          final showWarning =
              ref.read(settingsProvider).behaviour.showWarningOnBack;

          if (showWarning && preventNavigation) {
            navigate = (await showDialog(
                  context: context,
                  builder: (context) => OnbackWarning(),
                )) ??
                false;
          }

          if (navigate) {
            ref.read(preventNavigationProvider.notifier).state = false;
            ref.read(mainScreenPage.notifier).state = widget.index!;
            context.go(widget.route!);
          }
        } else {
          ref.read(appSideBarStateProvider.notifier).update((state) => !state);
        }
      },
      child: Align(
        alignment: AlignmentGeometry.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 8, 0, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 9,
            children: [
              Icon(widget.icon),
              Expanded(
                child: FadeIn(
                  duration: 200.milliseconds,
                  animate: expanded,
                  child: OverflowMarquee(
                      duration: 2.seconds,
                      delayDuration: 1.seconds,
                      child: Text(widget.label)
                          .textStyle(theme.typography.xSmall)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
