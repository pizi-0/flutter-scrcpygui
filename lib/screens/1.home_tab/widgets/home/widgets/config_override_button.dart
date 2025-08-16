import 'package:awesome_extensions/awesome_extensions.dart' show PaddingX;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../providers/config_provider.dart';

class OverrideButton extends ConsumerStatefulWidget {
  final AbstractButtonStyle buttonVariance;
  final ButtonDensity buttonDensity;
  final Widget? leading;

  const OverrideButton(
      {super.key,
      this.leading,
      this.buttonVariance = ButtonVariance.primary,
      this.buttonDensity = ButtonDensity.compact});

  @override
  ConsumerState<OverrideButton> createState() => _OverrideButtonState();
}

class _OverrideButtonState extends ConsumerState<OverrideButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      leading: widget.leading,
      variance: widget.buttonVariance,
      density: widget.buttonDensity,
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
      icon: Icon(
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
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: sectionWidth / 2, maxHeight: sectionWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Config override').textLarge.bold.paddingOnly(bottom: 8),
                Spacer(),
                if (overrides.isNotEmpty)
                  ClipRRect(
                    borderRadius: theme.borderRadiusMd,
                    child: DestructiveButton(
                      density: ButtonDensity.dense,
                      onPressed: overrideNotifier.clearOverride,
                      child: Text('Clear'),
                    ),
                  )
              ],
            ),
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
                      Text('Record'),
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
                  child: Text('Landscape'),
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
                  child: Text('Mute'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
