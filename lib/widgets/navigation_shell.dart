import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart'
    show StyledText, PaddingX, NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/scrcpy_manager.dart';
import 'package:scrcpygui/screens/4.settings_tab/settings_tab.dart';
import 'package:scrcpygui/screens/about_tab/about_tab.dart';
import 'package:scrcpygui/widgets/title_bar_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:window_manager/window_manager.dart';

class NavigationShell extends ConsumerStatefulWidget {
  final List<Widget> children;
  const NavigationShell({super.key, required this.children});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NavigationShellState();
}

class NavigationShellState extends ConsumerState<NavigationShell> {
  @override
  Widget build(BuildContext context) {
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
                  if (sizeInfo.isDesktop || sizeInfo.isTablet)
                    const AppSideBar(),
                  if (sizeInfo.isMobile) const Gap(62),
                  Expanded(
                    child: AnimatedBranchContainer(
                      currentIndex: currentIndex,
                      children: widget.children,
                    ),
                  ),
                ],
              ),
              if (sizeInfo.isMobile)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const AppSideBar(),
                      if (expanded)
                        Expanded(
                          child: Container(
                            color: Colors.black.withAlpha(50),
                          ),
                        )
                    ],
                  ),
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

    return OutlinedContainer(
      borderRadius: theme.borderRadiusXs,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (Platform.isMacOS) TitleBarButton(),
          if (Platform.isMacOS) VerticalDivider(indent: 16, endIndent: 16),
          Expanded(
            child: DragToMoveArea(
              child: Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 20,
                    width: 20,
                  ).paddingOnly(left: 3),
                  Text('Scrcpy GUI ($appversion)').fontSize(12),
                  const Text('by pizi-0')
                      .fontSize(8)
                      .underline()
                      .paddingOnly(top: 8),
                ],
              ).paddingOnly(left: 8),
            ),
          ),
          if (!Platform.isMacOS) VerticalDivider(indent: 16, endIndent: 16),
          if (!Platform.isMacOS) const TitleBarButton()
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
    final expanded = ref.watch(appSideBarStateProvider);
    final currentPage = ref.watch(mainScreenPage);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return TapRegion(
      onTapOutside: (event) =>
          ref.read(appSideBarStateProvider.notifier).state = false,
      child: ResponsiveBuilder(builder: (context, sizingInfo) {
        final shouldExpand = sizingInfo.isTablet || sizingInfo.isDesktop;

        return IntrinsicWidth(
          child: OutlinedContainer(
            borderRadius: const BorderRadius.all(Radius.zero),
            child: NavigationRail(
              expanded: expanded || shouldExpand,
              index: currentPage,
              alignment: NavigationRailAlignment.start,
              labelPosition: NavigationLabelPosition.end,
              labelType: NavigationLabelType.expanded,
              onSelected: (value) =>
                  ref.read(mainScreenPage.notifier).state = value,
              children: [
                NavigationButton(
                  alignment: Alignment.centerLeft,
                  onPressed: () => ref
                      .read(appSideBarStateProvider.notifier)
                      .update((state) => !state),
                  label: const Text('Menu'),
                  child: const Icon(Icons.menu),
                ),
                const NavigationDivider(),
                NavigationItem(
                  alignment: Alignment.centerLeft,
                  onChanged: (value) => context.go(HomeTab.route),
                  label: Text(el.homeLoc.title),
                  child: const Icon(Icons.home),
                ),
                NavigationItem(
                  alignment: Alignment.centerLeft,
                  onChanged: (value) => context.go(ConnectTab.route),
                  label: Text(el.connectLoc.title),
                  child: const Icon(Icons.link),
                ),
                NavigationItem(
                  alignment: Alignment.centerLeft,
                  onChanged: (value) => context.go(ScrcpyManagerTab.route),
                  label: Text(el.scrcpyManagerLoc.title),
                  child: const Icon(Icons.system_update_alt),
                ),
                const NavigationDivider(),
                NavigationItem(
                  alignment: Alignment.centerLeft,
                  onChanged: (value) => context.go(SettingsTab.route),
                  label: Text(el.settingsLoc.title),
                  child: const Icon(Icons.settings),
                ),
                const NavigationDivider(),
                NavigationItem(
                  alignment: Alignment.centerLeft,
                  onChanged: (value) => context.go(AboutTab.route),
                  label: Text(el.aboutLoc.title),
                  child: const Icon(Icons.info_rounded),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
