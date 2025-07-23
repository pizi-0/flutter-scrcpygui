import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/app_grid_settings_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../db/db.dart';
import '../../../../providers/config_provider.dart';
import '../../widgets/home/widgets/config_list/config_list_tile.dart';

class ConfigManager extends ConsumerStatefulWidget {
  static const String route = 'config-manager';
  const ConfigManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigManagerState();
}

class _ConfigManagerState extends ConsumerState<ConfigManager> {
  bool loading = false;

  List<ScrcpyConfig> oldList = [];
  List<ScrcpyConfig> reorderList = [];

  List<String> oldHidden = [];
  List<String> hidden = [];

  int? selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(configTags.notifier).clearTag();
      final filteredConfigs = ref.read(filteredConfigsProvider);
      final hiddenConfigs = ref.read(hiddenConfigsProvider);

      oldList = [...filteredConfigs];
      reorderList = [...filteredConfigs];

      oldHidden = [...hiddenConfigs];
      hidden = [...hiddenConfigs];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PgScaffoldCustom(
      title: Text(el.configManagerLoc.title),
      leading: [
        IconButton.ghost(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: context.pop,
        ),
        FadeIn(
          animate: !listEquals(oldHidden, hidden) ||
              !listEquals(oldList, reorderList),
          duration: 200.milliseconds,
          child: IconButton.ghost(
            icon: Icon(Icons.save_rounded),
            onPressed: _save,
          ),
        ),
      ],
      appBarTrailing: [
        IconButton.ghost(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.transparent),
          onPressed: null,
        ),
        IconButton.ghost(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.transparent),
          onPressed: null,
        ),
      ],
      scaffoldBody: Align(
        alignment: Alignment.topCenter,
        child: PgSectionCardNoScroll(
          expandContent: true,
          cardPadding: EdgeInsets.all(0),
          content: Column(
            children: [
              Expanded(
                child: ReorderableList(
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final config = reorderList[index];

                    return _reorderableConfigListTIle(config);
                  },
                  itemCount: reorderList.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = reorderList.removeAt(oldIndex);
                    reorderList.insert(newIndex, item);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reorderableConfigListTIle(ScrcpyConfig config) {
    return Column(
      key: ValueKey(config.id),
      spacing: 8,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: ReorderableDragStartListener(
                  index: reorderList.indexOf(config),
                  child: Icon(Icons.drag_indicator_rounded).iconSmall()),
            ),
            IconButton.ghost(
              onPressed: () {
                if (hidden.contains(config.id)) {
                  hidden.remove(config.id);
                } else {
                  hidden.add(config.id);
                }

                setState(() {});
              },
              icon: Icon(
                hidden.contains(config.id)
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: hidden.contains(config.id) ? Colors.red : null,
              ).iconSmall(),
            ),
            Expanded(
              child: ConfigListTile(
                showStartButton: false,
                conf: config,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: const Divider(),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!listEquals(oldHidden, hidden)) {
      ref.read(hiddenConfigsProvider.notifier).state = hidden;

      oldHidden = [...hidden];

      await Db.saveHiddenConfigs(ref.read(hiddenConfigsProvider));
    }

    if (!listEquals(oldList, reorderList)) {
      for (final c in reorderList) {
        ref.read(configsProvider.notifier).removeConfig(c);
        ref.read(configsProvider.notifier).addConfig(c);
      }

      oldList = [...reorderList];

      await Db.saveConfigs(ref.read(configsProvider));
    }

    final filteredConfig =
        ref.read(filteredConfigsProvider).where((c) => !hidden.contains(c.id));
    final selectedConfig = ref.read(selectedConfigProvider);

    if (filteredConfig.isEmpty) {
      ref.read(selectedConfigProvider.notifier).state = null;
    } else {
      if (selectedConfig != null && !filteredConfig.contains(selectedConfig)) {
        ref.read(selectedConfigProvider.notifier).state = filteredConfig.first;
      }
    }

    ref.read(controlPageConfigProvider.notifier).state =
        filteredConfig.firstWhereOrNull(
            (c) => c.id == ref.read(appGridSettingsProvider).lastUsedConfig);

    setState(() {});
  }
}
