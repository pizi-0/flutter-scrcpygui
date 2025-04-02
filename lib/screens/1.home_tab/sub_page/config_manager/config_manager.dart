import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../providers/config_provider.dart';

class ConfigManager extends ConsumerStatefulWidget {
  static const String route = 'config-manager';
  const ConfigManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigManagerState();
}

class _ConfigManagerState extends ConsumerState<ConfigManager> {
  List<SortableData<ScrcpyConfig>> configs = [];
  ScrollController controller = ScrollController();

  @override
  void initState() {
    configs = [...ref.read(configsProvider).map((conf) => SortableData(conf))];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PgScaffold(
      onBack: () => context.pop(),
      title: 'Configs manager',
      children: [
        PgSectionCard(
          children: [
            ConfigCustom(
              title: 'Hide default configs',
              childExpand: false,
              onPressed: () {},
              child: Checkbox(
                state: CheckboxState.unchecked,
                onChanged: (v) {},
              ),
            ),
          ],
        ),
        PgSectionCard(
          children: [
            SortableLayer(
                lock: true,
                child: SortableDropFallback(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: configs
                        .mapIndexed(
                          (i, conf) => Sortable(
                            key: ValueKey(i),
                            data: conf,
                            child: Card(
                              child: PgListTile(
                                title: conf.data.configName,
                              ),
                            ),
                            onAcceptBottom: (value) => setState(() {
                              configs.swapItem(value, i + 1);
                            }),
                            onAcceptTop: (value) => setState(() {
                              configs.swapItem(value, i);
                            }),
                          ),
                        )
                        .toList(),
                  ),
                ))
          ],
        )
      ],
    );
  }
}
