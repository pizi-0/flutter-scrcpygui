import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../providers/config_provider.dart';

class OverrideButton extends ConsumerStatefulWidget {
  final AbstractButtonStyle buttonVariance;
  final bool single;
  final Widget? leading;

  const OverrideButton({
    super.key,
    this.leading,
    this.single = true,
    required this.buttonVariance,
  });

  @override
  ConsumerState<OverrideButton> createState() => _OverrideButtonState();
}

class _OverrideButtonState extends ConsumerState<OverrideButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Button(
      style: widget.single
          ? widget.buttonVariance
          : widget.buttonVariance.withBorderRadius(
              borderRadius:
                  BorderRadius.horizontal(right: theme.radiusMdRadius),
              disabledBorderRadius:
                  BorderRadius.horizontal(right: theme.radiusMdRadius),
              focusBorderRadius:
                  BorderRadius.horizontal(right: theme.radiusMdRadius),
              hoverBorderRadius:
                  BorderRadius.horizontal(right: theme.radiusMdRadius),
            ),
      onPressed: () {
        showPopover(
          context: context,
          alignment: Alignment.bottomCenter,
          builder: (context) => OverrideConfigPopover(),
        );
      },
      onSecondaryTapUp: (details) =>
          ref.read(configOverridesProvider.notifier).clearOverride(),
      onLongPressStart: (details) =>
          ref.read(configOverridesProvider.notifier).clearOverride(),
      child: Icon(
        Icons.expand_less_rounded,
      ),
    );
  }
}

class OverrideConfigPopover extends ConsumerStatefulWidget {
  const OverrideConfigPopover({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverrideConfigPopoverState();
}

class _OverrideConfigPopoverState extends ConsumerState<OverrideConfigPopover> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overrides = ref.watch(configOverridesProvider);
    final overrideNotifier = ref.read(configOverridesProvider.notifier);

    return ModalContainer(
      padding: EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: sectionWidth / 2, maxHeight: sectionWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(el.buttonLabelLoc.override).textSmall.bold,
                Spacer(),
                IgnorePointer(
                  ignoring: overrides.isEmpty,
                  child: FadeIn(
                      animate: overrides.isNotEmpty,
                      duration: 200.milliseconds,
                      child: ButtonStyleOverride(
                        decoration: (context, states, value) {
                          return value.copyWithIfBoxDecoration(
                              borderRadius: theme.borderRadiusMd);
                        },
                        child: DestructiveButton(
                          density: ButtonDensity.dense,
                          onPressed: overrideNotifier.clearOverride,
                          child: Text(el.buttonLabelLoc.clear),
                        ),
                      )),
                )
              ],
            ),
            Divider(),
            ButtonGroup(
              direction: Axis.vertical,
              children: [
                SecondaryButton(
                  trailing: Checkbox(
                    state: overrides.contains(ScrcpyOverride.record)
                        ? CheckboxState.checked
                        : CheckboxState.unchecked,
                    onChanged: (value) =>
                        overrideNotifier.toggleOverride(ScrcpyOverride.record),
                  ),
                  onPressed: () =>
                      overrideNotifier.toggleOverride(ScrcpyOverride.record),
                  child: Row(
                    spacing: 8,
                    children: [
                      Text(el.configOverrideLoc.record.label),
                      IconButton.ghost(
                        density: ButtonDensity.compact,
                        onPressed: () =>
                            DirectoryUtils.openFolder(defaultRecord.savePath!),
                        icon: Icon(Icons.folder_open_rounded).iconSmall(),
                      ),
                    ],
                  ),
                ),
                SecondaryButton(
                  trailing: Checkbox(
                    state: overrides.contains(ScrcpyOverride.landscape)
                        ? CheckboxState.checked
                        : CheckboxState.unchecked,
                    onChanged: (value) => overrideNotifier
                        .toggleOverride(ScrcpyOverride.landscape),
                  ),
                  onPressed: () =>
                      overrideNotifier.toggleOverride(ScrcpyOverride.landscape),
                  child: Text(el.configOverrideLoc.landscape.label),
                ),
                SecondaryButton(
                  trailing: Checkbox(
                    state: overrides.contains(ScrcpyOverride.mute)
                        ? CheckboxState.checked
                        : CheckboxState.unchecked,
                    onChanged: (value) =>
                        overrideNotifier.toggleOverride(ScrcpyOverride.mute),
                  ),
                  onPressed: () =>
                      overrideNotifier.toggleOverride(ScrcpyOverride.mute),
                  child: Text(el.configOverrideLoc.mute.label),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
