import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/settings_model/auto_arrange_origin.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_subtitle.dart';
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
              surfaceBlur: theme.surfaceBlur,
              surfaceOpacity: theme.surfaceOpacity,
              padding: const EdgeInsets.all(8.0),
              child: AutoArrangeOriginSelector(),
            ),
          );
        },
        onSecondaryTapUp: (details) {
          ref.read(settingsProvider.notifier).changeAutoArrangeOrigin(
                AutoArrangeOrigin.off,
              );
          Db.saveAppSettings(ref.read(settingsProvider));
        },
        onLongPressEnd: (details) {
          ref.read(settingsProvider.notifier).changeAutoArrangeOrigin(
                AutoArrangeOrigin.off,
              );
          Db.saveAppSettings(ref.read(settingsProvider));
        },
      ),
    );
  }
}

class AutoArrangeOriginSelector extends ConsumerStatefulWidget {
  const AutoArrangeOriginSelector({super.key});

  @override
  ConsumerState<AutoArrangeOriginSelector> createState() =>
      _AutoArrangeOriginSelectorState();
}

class _AutoArrangeOriginSelectorState
    extends ConsumerState<AutoArrangeOriginSelector> {
  final focusNode = FocusNode();
  TextEditingController ratio = TextEditingController();
  bool error = false;
  AutoArrangeOrigin? _hoveredOrigin;

  @override
  void initState() {
    ratio.text = ref
        .read(settingsProvider)
        .behaviour
        .windowToScreenHeightRatio
        .toString();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    ratio.dispose();
    super.dispose();
  }

  void _onHover(bool hovering, AutoArrangeOrigin origin) {
    setState(() {
      _hoveredOrigin = hovering ? origin : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final origin = ref.watch(settingsProvider).behaviour.autoArrangeOrigin;
    const double rowWidth = 180;
    const double spacing = 4;
    final row1Siblings = [
      AutoArrangeOrigin.topLeft,
      AutoArrangeOrigin.topRight
    ];
    final row2Siblings = [
      AutoArrangeOrigin.centerLeft,
      AutoArrangeOrigin.centerRight
    ];
    final row3Siblings = [
      AutoArrangeOrigin.bottomLeft,
      AutoArrangeOrigin.bottomRight
    ];

    return SizedBox(
      width: rowWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: OverflowMarquee(
                    duration: 1.5.seconds,
                    delayDuration: 1.seconds,
                    child: Text(el.autoArrangeOriginLoc.title, maxLines: 1)
                        .textSmall
                        .bold),
              ),
              Switch(
                value: origin != AutoArrangeOrigin.off,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleAutoArrange();
                  Db.saveAppSettings(ref.read(settingsProvider));
                },
              )
            ],
          ),
          PgExpandable.vertical(
            expand: origin != AutoArrangeOrigin.off,
            child: Column(
              spacing: 8,
              children: [
                Gap(4),
                Divider(),
                Row(
                  spacing: spacing,
                  children: [
                    OriginBox(
                      origin: AutoArrangeOrigin.topLeft,
                      siblings: row1Siblings,
                      totalWidth: rowWidth - spacing,
                      hoveredOrigin: _hoveredOrigin,
                      onHover: (hovering) =>
                          _onHover(hovering, AutoArrangeOrigin.topLeft),
                    ),
                    OriginBox(
                      origin: AutoArrangeOrigin.topRight,
                      siblings: row1Siblings,
                      totalWidth: rowWidth - spacing,
                      hoveredOrigin: _hoveredOrigin,
                      onHover: (hovering) =>
                          _onHover(hovering, AutoArrangeOrigin.topRight),
                    ),
                  ],
                ),
                Row(
                  spacing: spacing,
                  children: [
                    OriginBox(
                      origin: AutoArrangeOrigin.centerLeft,
                      siblings: row2Siblings,
                      totalWidth: rowWidth - (spacing),
                      hoveredOrigin: _hoveredOrigin,
                      onHover: (hovering) =>
                          _onHover(hovering, AutoArrangeOrigin.centerLeft),
                    ),
                    OriginBox(
                      origin: AutoArrangeOrigin.centerRight,
                      siblings: row2Siblings,
                      totalWidth: rowWidth - (spacing),
                      hoveredOrigin: _hoveredOrigin,
                      onHover: (hovering) =>
                          _onHover(hovering, AutoArrangeOrigin.centerRight),
                    ),
                  ],
                ),
                Row(
                  spacing: spacing,
                  children: [
                    OriginBox(
                      origin: AutoArrangeOrigin.bottomLeft,
                      siblings: row3Siblings,
                      totalWidth: rowWidth - spacing,
                      hoveredOrigin: _hoveredOrigin,
                      onHover: (hovering) =>
                          _onHover(hovering, AutoArrangeOrigin.bottomLeft),
                    ),
                    OriginBox(
                      origin: AutoArrangeOrigin.bottomRight,
                      siblings: row3Siblings,
                      totalWidth: rowWidth - spacing,
                      hoveredOrigin: _hoveredOrigin,
                      onHover: (hovering) =>
                          _onHover(hovering, AutoArrangeOrigin.bottomRight),
                    ),
                  ],
                ),
                Divider(),
                PgSubtitle(
                  showSubtitle: error,
                  subtitle: 'Min: 0.4, Max: ~1.0',
                  child: TextField(
                    padding: const EdgeInsets.all(4.0),
                    controller: ratio,
                    focusNode: focusNode,
                    filled: true,
                    features: [
                      InputFeature.leading(
                        Text('${el.settingsLoc.behavior.windowToScreenRatio.labelShort} :')
                            .textSmall,
                      ),
                      InputFeature.trailing(IconButton.outline(
                        density: ButtonDensity.compact,
                        icon: Icon(Icons.refresh_rounded),
                        onPressed: () {
                          ratio.text = '0.88';
                          ref
                              .read(settingsProvider.notifier)
                              .changeWindowToScreenHeightRatio(0.88);
                          error = false;
                          focusNode.unfocus();
                          Db.saveAppSettings(ref.read(settingsProvider));
                          setState(() {});
                        },
                      )),
                    ],
                    onChanged: (value) {
                      final r = double.tryParse(value);

                      if (r == null || r < 0.4 || r > 1.0) {
                        error = true;
                      } else {
                        error = false;
                      }
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      final r = double.tryParse(value) ?? 0.88;
                      if (r < 0.4 || r > 1.0) {
                        ratio.text = ref
                            .read(settingsProvider)
                            .behaviour
                            .windowToScreenHeightRatio
                            .toString();
                        setState(() {});
                        return;
                      }

                      ref
                          .read(settingsProvider.notifier)
                          .changeWindowToScreenHeightRatio(
                            double.tryParse(value) ?? 0.88,
                          );
                      focusNode.unfocus();
                      Db.saveAppSettings(ref.read(settingsProvider));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OriginBox extends ConsumerWidget {
  final AutoArrangeOrigin origin;
  final ValueChanged<bool> onHover;
  final AutoArrangeOrigin? hoveredOrigin;
  final List<AutoArrangeOrigin> siblings;
  final double totalWidth;

  const OriginBox({
    super.key,
    required this.origin,
    required this.onHover,
    required this.hoveredOrigin,
    required this.siblings,
    required this.totalWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOrigin =
        ref.watch(settingsProvider).behaviour.autoArrangeOrigin;
    final isSelected = selectedOrigin == origin;
    final isHovered = hoveredOrigin == origin;

    final double width;
    final isRowHovered =
        hoveredOrigin != null && siblings.contains(hoveredOrigin);

    if (!isRowHovered) {
      width = totalWidth / siblings.length;
    } else {
      if (isHovered) {
        width = totalWidth * 2 / (siblings.length + 1);
      } else {
        width = totalWidth * 1 / (siblings.length + 1);
      }
    }

    final text = Text(
      tr('auto_arrange_origin_loc.${origin.value.replaceAll(' ', '_').toLowerCase()}'),
      textAlign: TextAlign.center,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 12,
      ),
    );

    return AnimatedContainer(
      duration: 200.milliseconds,
      curve: Curves.easeInOut,
      width: width,
      child: Button(
        disableTransition: true,
        onHover: onHover,
        style: isSelected
            ? ButtonStyle.primary(
                density: ButtonDensity.dense,
              )
            : ButtonStyle.outline(
                density: ButtonDensity.dense,
              ),
        onPressed: () {
          ref.read(settingsProvider.notifier).changeAutoArrangeOrigin(origin);
          Db.saveAppSettings(ref.read(settingsProvider));
        },
        child: SizedBox(
          height: 20,
          child: Center(
            child: isHovered ? OverflowMarquee(child: text) : text,
          ),
        ),
      ),
    );
  }
}
