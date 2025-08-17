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

  @override
  Widget build(BuildContext context) {
    final origin = ref.watch(settingsProvider).behaviour.autoArrangeOrigin;

    return SizedBox(
      width: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(el.autoArrangeOriginLoc.alignments).textSmall,
          Gap(8),
          Divider(),
          Gap(8),
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
          PgExpandable(
            expand: origin != AutoArrangeOrigin.off,
            child: Column(
              spacing: 8,
              children: [
                SizedBox(),
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
        onEnter: (event) {
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
                        tr('auto_arrange_origin_loc.${widget.origin.value.replaceAll(' ', '_').toLowerCase()}'),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    )
                  : Text(
                      tr('auto_arrange_origin_loc.${widget.origin.value.replaceAll(' ', '_').toLowerCase()}'),
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
