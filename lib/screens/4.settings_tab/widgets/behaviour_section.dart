import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../models/settings_model/auto_arrange_status_enum.dart';

class BehaviourSection extends ConsumerStatefulWidget {
  const BehaviourSection({super.key});

  @override
  ConsumerState<BehaviourSection> createState() => _BehaviourSectionState();
}

class _BehaviourSectionState extends ConsumerState<BehaviourSection> {
  @override
  Widget build(BuildContext context) {
    final behaviour = ref.watch(settingsProvider).behaviour;

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
        value: 'it',
        child: Text('Italian'),
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
              value: minimizeDD(context)
                  .firstWhere((act) => act.$1 == behaviour.minimizeAction),
              onChanged: (act) async {
                ref
                    .read(settingsProvider.notifier)
                    .changeMinimizeBehaviour(act!.$1);

                await Db.saveAppSettings(ref.read(settingsProvider));
              },
              itemBuilder: (context, value) => OverflowMarquee(
                  duration: 5.seconds,
                  delayDuration: 1.seconds,
                  child: Text(value.$2)),
              popup: SelectPopup(
                items: SelectItemList(
                    children: minimizeDD(context)
                        .map((act) =>
                            SelectItemButton(value: act, child: Text(act.$2)))
                        .toList()),
              ).call,
            ),
          ),
        ),
        const Divider(),
        PgListTile(
          title: 'Auto arrange scrcpy window',
          trailing: ConstrainedBox(
              constraints:
                  BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30),
              child: Select(
                value: behaviour.autoArrangeStatus,
                onChanged: (value) async {
                  ref
                      .read(settingsProvider.notifier)
                      .changeAutoArrangeStatus(value!);

                  await Db.saveAppSettings(ref.read(settingsProvider));
                },
                filled: true,
                popup: SelectPopup(
                  items: SelectItemList(
                    children: AutoArrangeStatus.values.map((status) {
                      return SelectItemButton(
                        value: status,
                        child: Text(status.value),
                      );
                    }).toList(),
                  ),
                ).call,
                itemBuilder: (context, value) => Text(value.value),
              )),
        ),
        const Divider(),
        InkWell(
          onTap: _toggleRememberWinSize,
          child: PgListTile(
            title: el.settingsLoc.behavior.windowSize.label,
            trailing: ConstrainedBox(
              constraints:
                  BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30),
              child: Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                  state: behaviour.rememberWinSize
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (b) => _toggleRememberWinSize(),
                ),
              ),
            ),
          ),
        ),
        // Divider(),
        // InkWell(
        //   onTap: () async {
        //     ref.read(settingsProvider.notifier).changeHideConfig();

        //     if (!behaviour.hideDefaultConfig) {
        //       ref.read(configTags.notifier).addTag(ConfigTag.customConfig);
        //     } else {
        //       ref.read(configTags.notifier).removeTag(ConfigTag.customConfig);
        //     }

        //     await Db.saveAppSettings(ref.read(settingsProvider));
        //   },
        //   child: PgListTile(
        //     title: 'Hide default configs',
        //     trailing: ConstrainedBox(
        //       constraints: const BoxConstraints(
        //           minWidth: 180, maxWidth: 180, minHeight: 30),
        //       child: Align(
        //         alignment: Alignment.centerRight,
        //         child: Checkbox(
        //           state: behaviour.hideDefaultConfig
        //               ? CheckboxState.checked
        //               : CheckboxState.unchecked,
        //           onChanged: (val) async {
        //             ref.read(settingsProvider.notifier).changeHideConfig();

        //             if (!behaviour.hideDefaultConfig) {
        //               ref
        //                   .read(configTags.notifier)
        //                   .addTag(ConfigTag.customConfig);
        //             } else {
        //               ref
        //                   .read(configTags.notifier)
        //                   .removeTag(ConfigTag.customConfig);
        //             }

        //             await Db.saveAppSettings(ref.read(settingsProvider));
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future<void> _toggleRememberWinSize() async {
    ref.read(settingsProvider.notifier).changeRememberWinSize();
    await Db.saveAppSettings(ref.read(settingsProvider));
  }
}

//ddvalue

List<(MinimizeAction, String)> minimizeDD(BuildContext context) {
  return [
    (MinimizeAction.toTray, el.settingsLoc.behavior.minimize.value.tray),
    (MinimizeAction.toTaskBar, el.settingsLoc.behavior.minimize.value.taskbar)
  ];
}
