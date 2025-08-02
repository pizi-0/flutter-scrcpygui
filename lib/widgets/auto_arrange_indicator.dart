import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/auto_arrange_origin.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../db/db.dart';
import '../providers/settings_provider.dart';

class AutoArrangeIndicator extends ConsumerStatefulWidget {
  const AutoArrangeIndicator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AutoArrangeIndicatorState();
}

class _AutoArrangeIndicatorState extends ConsumerState<AutoArrangeIndicator> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final autoArrangeOrigin =
        ref.watch(settingsProvider).behaviour.autoArrangeOrigin;

    // Map AutoArrangeOrigin to grid index (0-8)
    int? selectedIndex;
    switch (autoArrangeOrigin) {
      case AutoArrangeOrigin.topLeft:
        selectedIndex = 0;
        break;
      case AutoArrangeOrigin.topRight:
        selectedIndex = 2;
        break;
      case AutoArrangeOrigin.bottomLeft:
        selectedIndex = 6;
        break;
      case AutoArrangeOrigin.bottomRight:
        selectedIndex = 8;
        break;
      case AutoArrangeOrigin.centerLeft:
        selectedIndex = 3;
        break;
      case AutoArrangeOrigin.centerRight:
        selectedIndex = 5;
        break;
      case AutoArrangeOrigin.off:
        selectedIndex = null;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: Padding(
          padding: EdgeInsets.all(4.0),
          child: AnimatedSwitcher(
            duration: 200.milliseconds,
            child: autoArrangeOrigin == AutoArrangeOrigin.off
                ? Center(child: Icon(Icons.grid_off_rounded, color: Colors.red))
                : Center(
                    child: SizedBox.square(
                      dimension: 18,
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior()
                            .copyWith(overscroll: false, scrollbars: false),
                        child: Center(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 5.7,
                              childAspectRatio: 1,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              final isSelected = index == selectedIndex;
                              return AnimatedContainer(
                                duration: 200.milliseconds,
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.border,
                                    width: 1.5,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        onPressed: () async {
          showPopover(
            context: context,
            alignment: Alignment.bottomCenter,
            builder: (context) => Card(
              padding: const EdgeInsets.all(8.0),
              child: AutoArrangeOriginSelector(),
            ),
          );
        },
      ),
    );
  }
}

class AutoArrangeOriginSelector extends ConsumerWidget {
  const AutoArrangeOriginSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoArrangeOrigin =
        ref.watch(settingsProvider).behaviour.autoArrangeOrigin;

    int? selectedIndex;
    switch (autoArrangeOrigin) {
      case AutoArrangeOrigin.topLeft:
        selectedIndex = 0;
        break;
      case AutoArrangeOrigin.topRight:
        selectedIndex = 2;
        break;
      case AutoArrangeOrigin.bottomLeft:
        selectedIndex = 6;
        break;
      case AutoArrangeOrigin.bottomRight:
        selectedIndex = 8;
        break;
      case AutoArrangeOrigin.centerLeft:
        selectedIndex = 3;
        break;
      case AutoArrangeOrigin.centerRight:
        selectedIndex = 5;
        break;
      case AutoArrangeOrigin.off:
        selectedIndex = null;
        break;
    }

    return SizedBox(
      width: 116,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Switch(
            leading: OverflowMarquee(child: Text('Arrange').textSmall),
            value: autoArrangeOrigin != AutoArrangeOrigin.off,
            onChanged: (value) async {
              if (autoArrangeOrigin == AutoArrangeOrigin.off) {
                ref.read(settingsProvider.notifier).changeAutoArrangeOrigin(
                      AutoArrangeOrigin.topLeft,
                    );
              } else {
                ref.read(settingsProvider.notifier).changeAutoArrangeOrigin(
                      AutoArrangeOrigin.off,
                    );
              }
              await Db.saveAppSettings(ref.read(settingsProvider));
            },
          ),
          Divider(),
          SizedBox.square(
            dimension: 100,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Button(
                    style: isSelected
                        ? ButtonStyle.primary()
                        : ButtonStyle.outline(),
                    onPressed: _disabledIndices.contains(index)
                        ? null
                        : () async {
                            ref
                                .read(settingsProvider.notifier)
                                .changeAutoArrangeOrigin(index == 0
                                    ? AutoArrangeOrigin.topLeft
                                    : index == 2
                                        ? AutoArrangeOrigin.topRight
                                        : index == 3
                                            ? AutoArrangeOrigin.centerLeft
                                            : index == 5
                                                ? AutoArrangeOrigin.centerRight
                                                : index == 6
                                                    ? AutoArrangeOrigin
                                                        .bottomLeft
                                                    : index == 8
                                                        ? AutoArrangeOrigin
                                                            .bottomRight
                                                        : AutoArrangeOrigin
                                                            .off);
                            await Db.saveAppSettings(
                                ref.read(settingsProvider));
                          },
                    child: SizedBox.shrink(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<int> _disabledIndices = [
  1, // Top center
  4, // Center
  7, // Bottom center
];
