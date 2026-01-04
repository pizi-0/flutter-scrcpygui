import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/models/tasks/task_model.dart';
import 'package:scrcpygui/screens/4.settings_tab/widget_state/add_custom_shortcut_state.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/add_shortcut_steps/step_1.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/add_shortcut_steps/step_2.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AddCustomShortcutDialog extends ConsumerStatefulWidget {
  final Tasks? tasks;
  const AddCustomShortcutDialog({super.key, this.tasks});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCustomShortcutDialogState();
}

class _AddCustomShortcutDialogState
    extends ConsumerState<AddCustomShortcutDialog> {
  final StepperController controller = StepperController();
  Tasks? currentTasks;

  @override
  void initState() {
    currentTasks ??= widget.tasks ?? Tasks(toRun: []);
    controller.addListener(_onStepChanged);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller.removeListener(_onStepChanged);
    super.dispose();
  }

  void _onStepChanged() {
    ref
        .read(addShortcutDialogStateProvider.notifier)
        .setStep(controller.value.currentStep);
  }

  @override
  Widget build(BuildContext context) {
    final dialogState = ref.watch(addShortcutDialogStateProvider);

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
      child: AlertDialog(
        title: Text('Add Shortcut'),
        content: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: sectionWidth, minWidth: sectionWidth),
          child: OutlinedContainer(
            padding: EdgeInsets.all(8),
            child: Stepper(
              size: StepSize.small,
              controller: controller,
              steps: [
                Step(
                  title: Text('Action'),
                  contentBuilder: (context) {
                    return Step1();
                  },
                ),
                Step(
                  title: Text('Keys'),
                  contentBuilder: (context) => Step2(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Spacer(),
          if (dialogState.currentStep != 0)
            SecondaryButton(
              onPressed: controller.previousStep,
              child: Text('Back'),
            ),
          if (dialogState.currentStep < 1)
            PrimaryButton(
              onPressed: controller.nextStep,
              child: Text('Next'),
            ),
          if (controller.value.currentStep == 1)
            PrimaryButton(
              onPressed: () async {
                final shortcut = dialogState.buildShortcut();
                context.pop(shortcut);
              },
              child: Text('Add'),
            ),
          SecondaryButton(
            onPressed: context.pop,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
