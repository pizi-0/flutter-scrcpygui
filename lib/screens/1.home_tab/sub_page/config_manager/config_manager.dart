import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../db/db.dart';
import '../../../../providers/config_provider.dart';
import '../../widgets/home/widgets/config_list.dart';

class ConfigManager extends ConsumerStatefulWidget {
  static const String route = 'config-manager';
  const ConfigManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigManagerState();
}

class _ConfigManagerState extends ConsumerState<ConfigManager> {
  bool loading = false;
  bool reorder = false;

  List<ScrcpyConfig> reorderList = [];

  @override
  Widget build(BuildContext context) {
    final filteredConfigs = ref.watch(filteredConfigsProvider);

    reorderList = [...filteredConfigs];

    return PgScaffoldCustom(
        title: Text(el.configManagerLoc.title),
        onBack: () => context.pop(),
        scaffoldBody: Column(
          children: [
            Expanded(
              child: PgSectionCardNoScroll(
                expandContent: true,
                content: CustomScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                            child: Row(
                              spacing: 8,
                              children: [
                                Chip(
                                  style: reorder ? ButtonStyle.primary() : null,
                                  onPressed: _onReorderPressed,
                                  child: Text(!reorder
                                      ? el.buttonLabelLoc.reorder
                                      : el.buttonLabelLoc.save),
                                ),
                                if (reorder)
                                  FadeIn(
                                    duration: 100.milliseconds,
                                    child: Chip(
                                        child: Text(el.buttonLabelLoc.cancel),
                                        onPressed: () =>
                                            setState(() => reorder = false)),
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(),
                          )
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      child: ReorderableList(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _reorderableConfigListTIle(
                              index, filteredConfigs);
                        },
                        itemCount: reorder
                            ? reorderList.length
                            : filteredConfigs.length,
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = reorderList.removeAt(oldIndex);
                          reorderList.insert(newIndex, item);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _reorderableConfigListTIle(
      int index, List<ScrcpyConfig> filteredConfigs) {
    return Column(
      key: reorder
          ? ValueKey(reorderList[index].id)
          : ValueKey(filteredConfigs[index].id),
      spacing: 8,
      children: [
        Row(
          spacing: reorder ? 8 : 0,
          children: [
            AnimatedContainer(
              duration: 100.milliseconds,
              width: reorder ? 20 : 0,
              child: FittedBox(
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: ReorderableDragStartListener(
                      index: index, child: Icon(Icons.drag_indicator_rounded)),
                ),
              ),
            ),
            Expanded(
                child: ConfigListTile(
                    showStartButton: false,
                    conf:
                        reorder ? reorderList[index] : filteredConfigs[index])),
          ],
        ),
        if (reorder && index != reorderList.length - 1)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: const Divider(),
          ),
        if (!reorder && index != filteredConfigs.length - 1)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: const Divider(),
          )
      ],
    );
  }

  Future<void> _onReorderPressed() async {
    if (!reorder) {
      ref.read(configTags.notifier).clearTag();

      reorder = true;
    } else {
      for (final conf in reorderList) {
        ref.read(configsProvider.notifier).removeConfig(conf);
        ref.read(configsProvider.notifier).addConfig(conf);
      }
      reorderList.clear();

      await Db.saveConfigs(ref.read(configsProvider));

      reorder = false;
    }

    setState(() {});
  }
}
