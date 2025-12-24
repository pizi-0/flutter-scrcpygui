import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AddCustomShortcutDialog extends ConsumerStatefulWidget {
  const AddCustomShortcutDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCustomShortcutDialogState();
}

class _AddCustomShortcutDialogState
    extends ConsumerState<AddCustomShortcutDialog> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
      child: AlertDialog(
        title: Text('Add Shortcut'),
        content: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
        actions: [
          Spacer(),
          PrimaryButton(child: Text('Add')),
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
