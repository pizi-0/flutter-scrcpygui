import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:scrcpygui/screens/4.settings_tab/widget_state/add_custom_shortcut_state.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Step2 extends ConsumerStatefulWidget {
  const Step2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Step2State();
}

class _Step2State extends ConsumerState<Step2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dialogState = ref.watch(addShortcutDialogStateProvider);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          SizedBox.shrink(),
          Divider(),
          Text('Enter your shortcut'),
          HotKeyRecorder(
            initalHotKey:
                dialogState.shortcut.hotKey == placeholderShortcut.hotKey
                    ? null
                    : dialogState.shortcut.hotKey,
            onHotKeyRecorded: (value) {
              ref
                  .read(addShortcutDialogStateProvider.notifier)
                  .setHotkey(value);
            },
          )
        ],
      ),
    );
  }
}
