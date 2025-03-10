import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
      SelectItemButton(
        value: MinimizeAction.toTray,
        child: Text(
          el.settingsLoc.behavior.minimize.value.tray,
        ),
      ),
      SelectItemButton(
        value: MinimizeAction.toTaskBar,
        child: Text(
          el.settingsLoc.behavior.minimize.value.taskbar,
        ),
      )
    ];

    final langDD = [
      const SelectItemButton(
        value: 'en',
        child: Text('English'),
      ),
      const SelectItemButton(
        value: 'es',
        child: Text('Spanish'),
      ),
      const SelectItemButton(
        value: 'ms',
        child: Text('Bahasa Malaysia'),
      ),
    ];

    return PgSectionCard(
      label: el.settingsLoc.behavior.label,
      children: [
        PgListTile(
          title: el.settingsLoc.behavior.language.label,
          subtitle: el.settingsLoc.behavior.language.info,
          showSubtitle: true,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Select(
              filled: true,
              value: behaviour.languageCode,
              onChanged: (value) async {
                ref.read(settingsProvider.notifier).changeLanguage(value!);

                await Db.saveAppSettings(ref.read(settingsProvider));
              },
              itemBuilder: (context, value) =>
                  langDD.firstWhere((lang) => lang.value == value).child,
              popup: SelectPopup(items: SelectItemList(children: langDD)).call,
            ),
          ),
        ),
        const Divider(),
        PgListTile(
          title: el.settingsLoc.behavior.minimize.label,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Select(
              filled: true,
              value: behaviour.minimizeAction,
              onChanged: (value) async {
                ref
                    .read(settingsProvider.notifier)
                    .changeMinimizeBehaviour(value!);

                await Db.saveAppSettings(ref.read(settingsProvider));
              },
              itemBuilder: (context, value) => Text(value.name),
              popup: SelectPopup(
                items: SelectItemList(children: minimizeDD),
              ).call,
            ),
          ),
        ),
      ],
    );
  }
}
