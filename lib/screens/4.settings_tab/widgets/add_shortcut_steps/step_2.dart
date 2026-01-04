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
  HotKey? recorded;
  @override
  Widget build(BuildContext context) {
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
            onHotKeyRecorded: (value) {
              ref
                  .read(addShortcutDialogStateProvider.notifier)
                  .setHotKey(value);
            },
          )
        ],
      ),
    );
  }
}
