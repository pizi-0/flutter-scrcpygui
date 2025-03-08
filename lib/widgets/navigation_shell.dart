import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/main_screen.dart';
import 'package:scrcpygui/screens/1.home_tab/home_tab.dart';
import 'package:scrcpygui/screens/2.connect_tab/connect_tab.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/scrcpy_manager.dart';
import 'package:scrcpygui/screens/4.settings_tab/settings_tab.dart';
import 'package:scrcpygui/widgets/title_bar_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:window_manager/window_manager.dart';

// class NavigationShellLarge extends ConsumerStatefulWidget {
//   final List<Widget> children;
//   const NavigationShellLarge({super.key, required this.children});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       NavigationShellLargeState();
// }

// class NavigationShellLargeState extends ConsumerState<NavigationShellLarge> {
//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = ref.watch(mainScreenPage);

//     return Scaffold(
//       headers: [
//         AppBar(
//           leading: [
//             Image.asset(
//               'assets/logo.png',
//               height: 20,
//               width: 20,
//             )
//           ],
//           title: const DragToMoveArea(
//             child: Row(
//               children: [Expanded(child: Text('Scrcpy GUI'))],
//             ),
//           ),
//           trailing: const [TitleBarButton()],
//         ),
//       ],
//       child: Row(
//         children: [
//           const AppSideBar(),
//           Expanded(
//             child: AnimatedBranchContainer(
//               currentIndex: currentIndex,
//               children: widget.children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return Scaffold(
          headers: [
            AppBar(
              leading: [
                Image.asset(
                  'assets/logo.png',
                  height: 20,
                  width: 20,
                )
              ],
              title: DragToMoveArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          const Text('Scrcpy GUI  ').small(),
                          const Text('by pizi-0').fontSize(8).underline(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: const [TitleBarButton()],
            ),
          ],
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

class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
