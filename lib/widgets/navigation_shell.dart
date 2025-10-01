import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart'
    show NumExtension, PaddingX, StyledText;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/widgets/auto_arrange_indicator.dart';
import 'package:scrcpygui/widgets/custom_ui/custom_clippers.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_navigation_rail.dart';
import 'package:scrcpygui/widgets/title_bar_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/custom_scheme.dart';

final sidebarKey = GlobalKey<_AppSideBarState>();

class NavigationShell extends ConsumerStatefulWidget {
  final List<Widget> children;
  const NavigationShell({super.key, required this.children});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NavigationShellState();
}

class NavigationShellState extends ConsumerState<NavigationShell> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = ref.watch(mainScreenPage);
    final expanded = ref.watch(appSideBarStateProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return Scaffold(
          headers: const [TitleBar()],
          child: Stack(
            children: [
              Row(
                children: [
                  const Gap(50),
                  Expanded(
                    child: AnimatedBranchContainer(
                      currentIndex: currentIndex,
                      children: widget.children,
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !expanded,
                  child: OutlinedContainer(
                    duration: 200.milliseconds,
                    surfaceOpacity: expanded ? 0.5 : 0,
                    backgroundColor: theme.colorScheme.background,
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    child: SizedBox.expand(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: const AppSideBar(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TitleBar extends ConsumerWidget {
  const TitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appversion = ref.watch(appVersionProvider);

    return Container(
      color: background(context),
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (Platform.isMacOS) ...[
            TitleBarButton(),
            VerticalDivider(indent: 16, endIndent: 16),
          ],
          Expanded(
            child: DragToMoveArea(
              child: Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsGeometry.only(left: Platform.isMacOS ? 0 : 4),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 20,
                      width: 20,
                    ).paddingOnly(left: 3),
                  ),
                  if (!Platform.isMacOS) SizedBox(),
                  Text('Scrcpy GUI ($appversion)').fontSize(12),
                  const Text('by pizi-0')
                      .fontSize(8)
                      .underline()
                      .paddingOnly(top: 4.5),
                ],
              ).paddingOnly(left: 8),
            ),
          ),
          AutoArrangeIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: IconButton(
              variance: ButtonVariance.ghost,
              size: ButtonSize.small,
              icon: Padding(
                padding: EdgeInsets.all(4.0),
                child: theme.brightness == Brightness.dark
                    ? const Icon(Icons.light_mode_rounded, color: Colors.yellow)
                    : const Icon(Icons.dark_mode_rounded, color: Colors.yellow),
              ),
              onPressed: () async {
                ref.read(settingsProvider.notifier).changeThememode(
                      theme.brightness == Brightness.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    );

                await Db.saveAppSettings(ref.read(settingsProvider));
              },
            ),
          ),
          if (!Platform.isMacOS) ...[
            VerticalDivider(indent: 16, endIndent: 16),
            const TitleBarButton()
          ]
        ],
      ),
    );
  }
}

class AnimatedBranchContainer extends ConsumerWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    return Stack(
        children: children.mapIndexed(
      (int index, Widget navigator) {
        return FadeInUp(
          duration: 100.milliseconds,
          animate: index == currentIndex,
          child: Opacity(
            opacity: index == currentIndex ? 1 : 0,
            child: _branchNavigatorWrapper(index, navigator),
          ),
        );
      },
    ).toList());
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: navigator,
      );
}

final appSideBarStateProvider = StateProvider<bool>((ref) => false);

class AppSideBar extends ConsumerStatefulWidget {
  const AppSideBar({super.key});

  @override
  ConsumerState<AppSideBar> createState() => _AppSideBarState();
}

class _AppSideBarState extends ConsumerState<AppSideBar> {
  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final theme = Theme.of(context);

    return Row(
      children: [
        PgNavigationRail(),
        Expanded(
          child: ClipPath(
            clipper: TransparentSquareClipper(radius: theme.radiusLg),
            child: OutlinedContainer(
              backgroundColor: background(context),
              borderColor: Colors.transparent,
              borderWidth: 0,
              surfaceBlur: theme.surfaceBlur,
              surfaceOpacity: theme.surfaceOpacity,
              borderRadius: BorderRadius.all(Radius.zero),
              child: OutlinedContainer(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(theme.radiusLg - 1),
                  bottomLeft: Radius.circular(theme.radiusLg - 1),
                  topRight: Radius.circular(theme.radiusLg - 1),
                ),
                child: SizedBox.expand(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
