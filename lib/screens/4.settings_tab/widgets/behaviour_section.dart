import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

class BehaviourSection extends ConsumerStatefulWidget {
  const BehaviourSection({super.key});

  @override
  ConsumerState<BehaviourSection> createState() => _BehaviourSectionState();
}

class _BehaviourSectionState extends ConsumerState<BehaviourSection> {
  @override
  Widget build(BuildContext context) {
    final behaviour = ref.watch(settingsProvider).behaviour;

    final minimizeDD = [
      ComboBoxItem(
        value: MinimizeAction.toTray,
        child: Text(
          el.settingsLoc.behavior.minimize.value.tray,
        ),
      ),
      ComboBoxItem(
        value: MinimizeAction.toTaskBar,
        child: Text(
          el.settingsLoc.behavior.minimize.value.taskbar,
        ),
      )
    ];

    final langDD = [
      const ComboBoxItem(
        value: 'en',
        child: Text('English'),
      ),
      const ComboBoxItem(
        value: 'es',
        child: Text('Spanish'),
      ),
      const ComboBoxItem(
        value: 'ms',
        child: Text('Bahasa Malaysia'),
      ),
    ];

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfigCustom(
            title: el.settingsLoc.behavior.label, child: const SizedBox()),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ConfigCustom(
                title: el.settingsLoc.behavior.language.label,
                showinfo: true,
                subtitle: el.settingsLoc.behavior.language.info,
                child: ComboBox(
                    value: behaviour.languageCode,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .changeLanguage(value!);
                    },
                    items: langDD),
              ),
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: el.settingsLoc.behavior.minimize.label,
                child: ComboBox(
                  value: behaviour.minimizeAction,
                  onChanged: (value) async {
                    ref
                        .read(settingsProvider.notifier)
                        .changeMinimizeBehaviour(value!);

                    await Db.saveAppSettings(ref.read(settingsProvider));
                  },
                  items: minimizeDD,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
