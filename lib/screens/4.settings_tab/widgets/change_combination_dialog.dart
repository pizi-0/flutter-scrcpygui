import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../models/settings_model/shortcut.dart';

class ChangeShortcutComb extends StatefulWidget {
  final Shortcut shortcut;
  const ChangeShortcutComb({
    super.key,
    required this.shortcut,
  });

  @override
  State<ChangeShortcutComb> createState() => _ChangeShortcutCombState();
}

class _ChangeShortcutCombState extends State<ChangeShortcutComb> {
  HotKey? recorded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recorded = widget.shortcut.hotKey;
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
          HotKeyRecorder(
            initalHotKey: widget.shortcut.hotKey,
            onHotKeyRecorded: (value) {
              recorded = value;
            },
          ),
        ],
      ),
      actions: [
        PrimaryButton(
          onPressed: () =>
              context.pop(Shortcut(id: widget.shortcut.id, hotKey: recorded!)),
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
