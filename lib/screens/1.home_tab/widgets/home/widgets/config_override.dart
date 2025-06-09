import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../providers/config_provider.dart';

class OverrideButton extends ConsumerStatefulWidget {
  const OverrideButton({super.key});

  @override
  ConsumerState<OverrideButton> createState() => _OverrideButtonState();
}

class _OverrideButtonState extends ConsumerState<OverrideButton> {
  @override
  Widget build(BuildContext context) {
    final overrides = ref.watch(configOverridesProvider);
    final theme = Theme.of(context);

    return IconButton(
      variance: ButtonVariance.menubar,
      onPressed: () {
        showDialog(context: context, builder: (context) => OverrideConfigDialog());
      },
      onSecondaryTapUp: (details) => ref.read(configOverridesProvider.notifier).clearOverride(),
      onLongPressStart: (details) => ref.read(configOverridesProvider.notifier).clearOverride(),
      icon: Icon(
        Icons.tune_rounded,
        color: overrides.isNotEmpty ? theme.colorScheme.primary : null,
      ),
    );
  }
}

class OverrideConfigDialog extends ConsumerStatefulWidget {
  const OverrideConfigDialog({
    super.key,
  });

  @override
  ConsumerState<OverrideConfigDialog> createState() => _OverrideConfigDialogState();
}

class _OverrideConfigDialogState extends ConsumerState<OverrideConfigDialog> {
  @override
  Widget build(BuildContext context) {
    final overrides = ref.watch(configOverridesProvider);
    final overrideNotifier = ref.read(configOverridesProvider.notifier);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: appWidth, maxHeight: appWidth),
      child: AlertDialog(
        title: Text('Config override'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            SecondaryButton(
              trailing: Checkbox(
                state: overrides.contains(ScrcpyOverride.record) ? CheckboxState.checked : CheckboxState.unchecked,
                onChanged: (value) => overrideNotifier.toggleOverride(ScrcpyOverride.record),
              ),
              onPressed: () => overrideNotifier.toggleOverride(ScrcpyOverride.record),
              child: Text('Record'),
            ),
            SecondaryButton(
              trailing: Checkbox(
                state: overrides.contains(ScrcpyOverride.landscape) ? CheckboxState.checked : CheckboxState.unchecked,
                onChanged: (value) => overrideNotifier.toggleOverride(ScrcpyOverride.landscape),
              ),
              onPressed: () => overrideNotifier.toggleOverride(ScrcpyOverride.landscape),
              child: Text('Landscape'),
            ),
            SecondaryButton(
              trailing: Checkbox(
                state: overrides.contains(ScrcpyOverride.mute) ? CheckboxState.checked : CheckboxState.unchecked,
                onChanged: (value) => overrideNotifier.toggleOverride(ScrcpyOverride.mute),
              ),
              onPressed: () => overrideNotifier.toggleOverride(ScrcpyOverride.mute),
              child: Text('Mute'),
            ),
          ],
        ),
        actions: [
          GhostButton(
            onPressed: overrideNotifier.clearOverride,
            child: Text('Clear'),
          ),
          Spacer(),
          PrimaryButton(
            onPressed: _startWithOverrides,
            child: Text('Start'),
          ),
          SecondaryButton(
            onPressed: context.pop,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  _startWithOverrides() async {
    final overrides = ref.read(configOverridesProvider);
    final config = ref.read(selectedConfigProvider)!;

    final overridden = ScrcpyUtils.handleOverrides(overrides, config);

    await ScrcpyUtils.newInstance(ref, selectedConfig: overridden);
  }
}
