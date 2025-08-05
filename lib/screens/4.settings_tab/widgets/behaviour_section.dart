import 'package:awesome_extensions/awesome_extensions_dart.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../models/settings_model/auto_arrange_origin.dart';

class BehaviourSection extends ConsumerStatefulWidget {
  const BehaviourSection({super.key});

  @override
  ConsumerState<BehaviourSection> createState() => _BehaviourSectionState();
}

class _BehaviourSectionState extends ConsumerState<BehaviourSection> {
  final windowToScreenRatioFocusNode = FocusNode();
  TextEditingController? windowToScreenRatioController;

  @override
  void initState() {
    windowToScreenRatioController = TextEditingController(
      text: ref
          .read(settingsProvider)
          .behaviour
          .windowToScreenHeightRatio
          .toString(),
    );
    windowToScreenRatioFocusNode.addListener(onRatioNodeFocusLost);
    super.initState();
  }

  void onRatioNodeFocusLost() {
    windowToScreenRatioController?.text = ref
        .read(settingsProvider)
        .behaviour
        .windowToScreenHeightRatio
        .toString();

    setState(() {});
  }

  @override
  void dispose() {
    windowToScreenRatioFocusNode.dispose();
    windowToScreenRatioController?.dispose();
    windowToScreenRatioFocusNode.removeListener(onRatioNodeFocusLost);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final behaviour = ref.watch(settingsProvider).behaviour;

    final langDD = [
      const SelectItemButton(
        value: 'en',
        child: Text('English'),
      ),
      const SelectItemButton(
        value: 'es',
        child: Text('Español'),
      ),
      const SelectItemButton(
        value: 'it',
        child: Text('Italiano'),
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
        Column(
          children: [
            PgListTile(
              title: el.settingsLoc.behavior.autoArrange.label,
              trailing: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30),
                child: Select(
                  value: behaviour.autoArrangeOrigin,
                  onChanged: (value) async {
                    ref
                        .read(settingsProvider.notifier)
                        .changeAutoArrangeOrigin(value!);

                    await Db.saveAppSettings(ref.read(settingsProvider));
                  },
                  filled: true,
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: AutoArrangeOrigin.values.map((status) {
                        return SelectItemButton(
                          value: status,
                          child: Text(tr(
                              'auto_arrange_origin_loc.${status.value.replaceAll(' ', '_').toLowerCase()}')),
                        );
                      }).toList(),
                    ),
                  ).call,
                  itemBuilder: (context, value) => Text(
                    tr('auto_arrange_origin_loc.${value.value.replaceAll(' ', '_').toLowerCase()}'),
                  ),
                ),
              ),
            ),
            PgExpandable(
              expand: behaviour.autoArrangeOrigin != AutoArrangeOrigin.off,
              child: Column(
                children: [
                  Gap(8),
                  OutlinedContainer(
                    borderRadius: theme.borderRadiusMd,
                    backgroundColor: theme.colorScheme.muted,
                    padding: const EdgeInsets.all(4),
                    child: OutlinedContainer(
                      borderRadius: theme.borderRadiusMd,
                      backgroundColor: theme.colorScheme.background,
                      padding: const EdgeInsets.all(8),
                      child: ConfigCustom(
                        dimTitle: false,
                        title:
                            el.settingsLoc.behavior.windowToScreenRatio.label,
                        subtitle: 'Min: 0.4, Max: 1.0',
                        showinfo: true,
                        child: TextField(
                          features: [
                            InputFeature.trailing(
                              IconButton.ghost(
                                density: ButtonDensity.compact,
                                icon: Icon(Icons.refresh_rounded),
                                onPressed: () {
                                  ref
                                      .read(settingsProvider.notifier)
                                      .changeWindowToScreenHeightRatio(0.88);

                                  windowToScreenRatioController?.text = '0.88';
                                  windowToScreenRatioFocusNode.unfocus();

                                  Db.saveAppSettings(
                                      ref.read(settingsProvider));
                                },
                              ),
                            )
                          ],
                          focusNode: windowToScreenRatioFocusNode,
                          textAlign: TextAlign.end,
                          filled: true,
                          controller: windowToScreenRatioController,
                          onSubmitted: (value) {
                            final val = double.tryParse(value) ?? 0.88;

                            if (val < 0.4 || val > 1.0) {
                              windowToScreenRatioFocusNode.unfocus();
                              return;
                            }

                            ref
                                .read(settingsProvider.notifier)
                                .changeWindowToScreenHeightRatio(
                                    double.tryParse(value) ?? 0.88);
                            windowToScreenRatioFocusNode.unfocus();

                            Db.saveAppSettings(ref.read(settingsProvider));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
