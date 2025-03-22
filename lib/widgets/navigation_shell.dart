import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart'
    show StyledText, PaddingX, NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/scrcpy_manager.dart';
import 'package:scrcpygui/screens/4.settings_tab/settings_tab.dart';
import 'package:scrcpygui/widgets/title_bar_button.dart';
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
        return FScaffold(
          contentPad: false,
          header: TitleBar(),
          content: Stack(
            children: [
              Row(
                children: [
                  if (sizeInfo.isDesktop || sizeInfo.isTablet)
                    const AppSideBar(),
                  if (sizeInfo.isMobile) const SizedBox(width: 58),
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

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 20,
                      width: 20,
                    ),
                    const Text('Scrcpy GUI'),
                    const Text('by pizi-0').fontSize(8).paddingOnly(bottom: 2),
                  ],
                ),
              ),
            ),
          ),
          const TitleBarButton()
        ],
      ),
    );
  }
}

class AnimatedBranchContainer extends ConsumerWidget {
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  final int currentIndex;

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
    final theme = FTheme.of(context);

    final expanded = ref.watch(appSideBarStateProvider);
    final currentPage = ref.watch(mainScreenPage);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return TapRegion(
      onTapOutside: (event) =>
          ref.read(appSideBarStateProvider.notifier).state = false,
      child: ResponsiveBuilder(builder: (context, sizingInfo) {
        final shouldExpand = sizingInfo.isTablet || sizingInfo.isDesktop;

        return AnimatedContainer(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border(right: BorderSide(color: theme.colorScheme.border)),
          ),
          width: expanded || shouldExpand ? 250 : 58,
          duration: 150.milliseconds,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SidebarItem(
                icon: FAssets.icons.menu,
                label: '',
                onPress: () => ref
                    .read(appSideBarStateProvider.notifier)
                    .state = !expanded,
                showLabel: expanded || shouldExpand,
              ),
              FDivider(
                style: theme.dividerStyles.horizontalStyle
                    .copyWith(padding: EdgeInsets.zero),
              ),
              SidebarItem(
                icon: FAssets.icons.house,
                label: el.homeLoc.title,
                selected: currentPage == 0,
                onPress: () => {
                  ref.read(mainScreenPage.notifier).state = 0,
                  context.go(HomeTab.route),
                },
                showLabel: expanded || shouldExpand,
              ),
              SidebarItem(
                icon: FAssets.icons.link,
                label: el.connectLoc.title,
                selected: currentPage == 1,
                onPress: () => {
                  ref.read(mainScreenPage.notifier).state = 1,
                  context.go(ConnectTab.route)
                },
                showLabel: expanded || shouldExpand,
              ),
              SidebarItem(
                icon: FAssets.icons.circleArrowUp,
                selected: currentPage == 2,
                label: el.scrcpyManagerLoc.title,
                onPress: () => {
                  ref.read(mainScreenPage.notifier).state = 2,
                  context.go(ScrcpyManagerTab.route)
                },
                showLabel: expanded || shouldExpand,
              ),
              FDivider(
                style: theme.dividerStyles.horizontalStyle
                    .copyWith(padding: EdgeInsets.zero),
              ),
              SidebarItem(
                icon: FAssets.icons.settings,
                label: el.settingsLoc.title,
                selected: currentPage == 3,
                onPress: () => {
                  ref.read(mainScreenPage.notifier).state = 3,
                  context.go(SettingsTab.route)
                },
                showLabel: expanded || shouldExpand,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SidebarItem extends ConsumerWidget {
  final bool selected;
  final bool showLabel;
  final SvgAsset icon;
  final String label;
  final Function()? onPress;

  const SidebarItem({
    super.key,
    this.selected = false,
    this.showLabel = false,
    required this.icon,
    required this.label,
    this.onPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FTheme.of(context);

    final color =
        selected ? theme.colorScheme.primary : theme.colorScheme.foreground;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FTappable(
        focusedOutlineStyle: theme.style.focusedOutlineStyle,
        onPress: onPress,
        builder: (context, hovered, child) => AnimatedContainer(
          duration: 150.milliseconds,
          width: showLabel ? double.maxFinite : 50,
          height: 40,
          decoration: BoxDecoration(
            color: hovered.hovered
                ? theme.colorScheme.primary.withAlpha(50)
                : null,
            borderRadius: theme.style.borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FIcon(icon, color: color),
              ),
              if (showLabel)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).fontSize(13).textColor(color),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
