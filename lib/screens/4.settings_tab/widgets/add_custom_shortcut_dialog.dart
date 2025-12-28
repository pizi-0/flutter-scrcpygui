import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/4.settings_tab/widget_state/add_custom_shortcut_state.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/add_shortcut_steps/step_1.dart';
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
  final StepperController controller = StepperController();

  @override
  void initState() {
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
                Step(title: Text('Keys')),
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
