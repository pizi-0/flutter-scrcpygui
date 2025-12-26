import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/keyboard_shortcut_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../models/settings_model/shortcut.dart';

class ChangeShortcutComb extends ConsumerStatefulWidget {
  final Shortcut shortcut;
  const ChangeShortcutComb({
    super.key,
    required this.shortcut,
  });

  @override
  ConsumerState<ChangeShortcutComb> createState() => _ChangeShortcutCombState();
}

class _ChangeShortcutCombState extends ConsumerState<ChangeShortcutComb> {
  HotKey? recorded;
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recorded = widget.shortcut.hotKey;
      disabled = ref
          .read(disabledKeyboardShortcutProvider)
          .contains(widget.shortcut.id);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Record Shortcut'),
        ],
      ),
      content: Column(
        children: [
          Center(
            child: OutlinedContainer(
              padding: EdgeInsets.all(16),
              child: HotKeyRecorder(
                initalHotKey: widget.shortcut.hotKey,
                onHotKeyRecorded: (value) {
                  recorded = value;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        Checkbox(
          leading: Text('Disable'),
          state: disabled ? CheckboxState.checked : CheckboxState.unchecked,
          onChanged: (value) {
            disabled = value == CheckboxState.checked;
            setState(() {});
          },
        ),
        Spacer(),
        PrimaryButton(
          onPressed: () => context.pop(HKEditResult(
              isDisabled: disabled,
              shortcut: Shortcut(id: widget.shortcut.id, hotKey: recorded!))),
          child: Text(el.buttonLabelLoc.save),
        ),
        SecondaryButton(
          onPressed: () => context.pop(),
          child: Text(el.buttonLabelLoc.cancel),
        ),
      ],
    );
  }
}

class HKEditResult {
  final bool isDisabled;
  final Shortcut shortcut;

  HKEditResult({
    required this.isDisabled,
    required this.shortcut,
  });
}
