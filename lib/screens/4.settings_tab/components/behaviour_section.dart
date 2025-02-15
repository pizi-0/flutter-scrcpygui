import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

class BehaviourSection extends ConsumerStatefulWidget {
  const BehaviourSection({super.key});

  @override
  ConsumerState<BehaviourSection> createState() => _BehaviourSectionState();
}

class _BehaviourSectionState extends ConsumerState<BehaviourSection> {
  @override
  Widget build(BuildContext context) {
    final behaviour =
        ref.watch(settingsProvider.select((sett) => sett.behaviour));

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConfigCustom(title: 'App behavior', child: SizedBox()),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Minimize',
                subtitle: 'app behaviour when minimize triggered',
                child: ComboBox(
                  value: behaviour.minimizeAction,
                  onChanged: (value) async {
                    ref
                        .read(settingsProvider.notifier)
                        .changeMinimizeBehaviour(value!);

                    await AppUtils.saveAppSettings(ref.read(settingsProvider));
                  },
                  items: MinimizeAction.values
                      .map((v) => ComboBoxItem(value: v, child: Text(v.name)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
