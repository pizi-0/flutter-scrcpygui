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
    return SizedBox(
      width: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text('Alignment').textSmall,
          Divider(),
          Column(
            spacing: 4,
            children: [
              AnimatedSize(
                duration: 200.milliseconds,
                child: Row(
                  spacing: 4,
                  children: [
                    OriginBox(origin: AutoArrangeOrigin.topLeft),
                    OriginBox(origin: AutoArrangeOrigin.topRight),
                  ],
                ),
              ),
              AnimatedSize(
                duration: 200.milliseconds,
                child: Row(
                  spacing: 4,
                  children: [
                    OriginBox(origin: AutoArrangeOrigin.centerLeft),
                    OriginBox(origin: AutoArrangeOrigin.off),
                    OriginBox(origin: AutoArrangeOrigin.centerRight),
                  ],
                ),
              ),
              AnimatedSize(
                duration: 200.milliseconds,
                child: Row(
                  spacing: 4,
                  children: [
                    OriginBox(origin: AutoArrangeOrigin.bottomLeft),
                    OriginBox(origin: AutoArrangeOrigin.bottomRight),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox.square(
          //   dimension: 100,
          //   child: GridView.builder(
          //     shrinkWrap: true,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //     ),
          //     itemCount: 9,
          //     itemBuilder: (context, index) {
          //       final isSelected = index == selectedIndex;
          //       return Padding(
          //         padding: const EdgeInsets.all(2.0),
          //         child: Button(
          //           style: isSelected
          //               ? ButtonStyle.primary()
          //               : ButtonStyle.outline(),
          //           onPressed: _disabledIndices.contains(index)
          //               ? null
          //               : () async {
          //                   ref
          //                       .read(settingsProvider.notifier)
          //                       .changeAutoArrangeOrigin(index == 0
          //                           ? AutoArrangeOrigin.topLeft
          //                           : index == 2
          //                               ? AutoArrangeOrigin.topRight
          //                               : index == 3
          //                                   ? AutoArrangeOrigin.centerLeft
          //                                   : index == 5
          //                                       ? AutoArrangeOrigin.centerRight
          //                                       : index == 6
          //                                           ? AutoArrangeOrigin
          //                                               .bottomLeft
          //                                           : index == 8
          //                                               ? AutoArrangeOrigin
          //                                                   .bottomRight
          //                                               : AutoArrangeOrigin
          //                                                   .off);
          //                   await Db.saveAppSettings(
          //                       ref.read(settingsProvider));
          //                 },
          //           child: SizedBox.shrink(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          SizedBox(),
        ],
      ),
    );
  }
}

class OriginBox extends ConsumerStatefulWidget {
  final AutoArrangeOrigin origin;

  const OriginBox({super.key, required this.origin});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OriginBoxState();
}

class _OriginBoxState extends ConsumerState<OriginBox> {
  bool isSelected = false;
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOrigin =
        ref.watch(settingsProvider).behaviour.autoArrangeOrigin;
    isSelected = selectedOrigin == widget.origin;

    return Expanded(
      flex: hover ? 2 : 1,
      child: MouseRegion(
        onHover: (event) {
          if (mounted) {
            hover = true;
            setState(() {});
          }
        },
        onExit: (event) {
          if (mounted) {
            hover = false;
            setState(() {});
          }
        },
        child: Button(
          style: widget.origin == AutoArrangeOrigin.off && isSelected
              ? ButtonStyle.destructive(
                  density: ButtonDensity.dense,
                )
              : isSelected
                  ? ButtonStyle.outline(
                      density: ButtonDensity.dense,
                    ).withBackgroundColor(
                      color: theme.colorScheme.primary,
                      hoverColor: theme.colorScheme.primary)
                  : ButtonStyle.outline(
                      density: ButtonDensity.dense,
                    ).withBackgroundColor(
                      hoverColor: widget.origin == AutoArrangeOrigin.off
                          ? theme.colorScheme.destructive
                          : theme.colorScheme.muted),
          onPressed: () {
            ref.read(settingsProvider.notifier).changeAutoArrangeOrigin(
                  widget.origin,
                );
            Db.saveAppSettings(ref.read(settingsProvider));
          },
          child: SizedBox(
            height: 20,
            child: Center(
              child: hover
                  ? OverflowMarquee(
                      child: Text(
                        widget.origin.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    )
                  : Text(
                      widget.origin.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
