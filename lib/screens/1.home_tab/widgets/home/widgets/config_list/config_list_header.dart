import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/app_grid_settings_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../db/db.dart';
import '../../../../../../models/config_list_screen_state.dart';
import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../providers/config_provider.dart';
import '../config_filter_button.dart';
import 'config_override_widget.dart';

class ConfigListHeader extends ConsumerStatefulWidget {
  final List<ScrcpyConfig> reordered;
  final List<String> hiddenList;

  const ConfigListHeader({
    super.key,
    required this.reordered,
    required this.hiddenList,
  });

  @override
  ConsumerState<ConfigListHeader> createState() => _ConfigListHeaderState();
}

class _ConfigListHeaderState extends ConsumerState<ConfigListHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = ref.watch(configTags);
    final headerState = ref.watch(configListStateProvider);
    final overrides = ref.watch(configOverridesProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.border,
          ),
        ),
        color: theme.colorScheme.border.withAlpha(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PgExpandable(
          expand: headerState.isOpen,
          title: ButtonGroup(
            children: [
              Button(
                style: headerState.filtering
                    ? ButtonStyle.primary(density: ButtonDensity.dense)
                    : ButtonStyle.secondary(density: ButtonDensity.dense),
                onPressed: () {
                  ref.read(configListStateProvider.notifier).state =
                      headerState.copyWith(
                          filtering: !headerState.filtering,
                          edit: false,
                          override: false);
                },
                onSecondaryTapUp: (details) =>
                    ref.read(configTags.notifier).clearTag(),
                child: tags.isNotEmpty
                    ? Text('${el.buttonLabelLoc.filter} (${tags.length})')
                    : Text(el.buttonLabelLoc.filter),
              ),
              Button(
                style: headerState.edit
                    ? ButtonStyle.primary(density: ButtonDensity.dense)
                    : ButtonStyle.secondary(density: ButtonDensity.dense),
                onPressed: () {
                  ref.read(configListStateProvider.notifier).state =
                      headerState.copyWith(
                          filtering: false,
                          edit: !headerState.edit,
                          override: false);

                  ref.read(configTags.notifier).clearTag();
                },
                child: Text(el.buttonLabelLoc.edit),
              ),
              Button(
                style: headerState.override
                    ? ButtonStyle.primary(density: ButtonDensity.dense)
                    : ButtonStyle.secondary(density: ButtonDensity.dense),
                onPressed: () {
                  ref.read(configListStateProvider.notifier).state =
                      headerState.copyWith(
                          filtering: false,
                          edit: false,
                          override: !headerState.override);
                },
                onSecondaryTapUp: (details) {
                  ref.read(configOverridesProvider.notifier).clearOverride();
                },
                child: overrides.isEmpty
                    ? Text(el.buttonLabelLoc.override)
                    : Text(
                        '${el.buttonLabelLoc.override} (${overrides.length})'),
              ),
            ],
          ),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(),
              Divider(),
              AnimatedSwitcher(
                duration: 200.milliseconds,
                child: _switcherChild(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switcherChild() {
    final headerState = ref.watch(configListStateProvider);

    switch (headerState) {
      case ConfigListState(filtering: true):
        return ConfigFilterButtonBig(key: const ValueKey('filter'));
      case ConfigListState(edit: true):
        return Row(
          key: const ValueKey('reorder'),
          spacing: 8,
          children: [
            Chip(
              style: ButtonStyle.destructiveIcon(),
              child: Icon(Icons.close_rounded).iconSmall(),
              onPressed: () => ref
                  .read(configListStateProvider.notifier)
                  .state = headerState.copyWith(edit: false),
            ),
            Chip(
              style: ButtonStyle.primary(),
              onPressed: () async {
                for (final conf in widget.reordered) {
                  ref.read(configsProvider.notifier).removeConfig(conf);
                  ref.read(configsProvider.notifier).addConfig(conf);
                }

                ref
                    .read(configListStateProvider.notifier)
                    .update((state) => state.copyWith(edit: false));

                ref.read(hiddenConfigsProvider.notifier).state =
                    widget.hiddenList;

                final filteredConfig = ref
                    .read(filteredConfigsProvider)
                    .where((c) => !widget.hiddenList.contains(c.id));
                final selectedConfig = ref.read(selectedConfigProvider);

                if (filteredConfig.isEmpty) {
                  ref.read(selectedConfigProvider.notifier).state = null;
                  ref.read(controlPageConfigProvider.notifier).state = null;
                } else {
                  if (selectedConfig != null &&
                      !filteredConfig.contains(selectedConfig)) {
                    ref.read(selectedConfigProvider.notifier).state =
                        filteredConfig.first;
                  }

                  ref.read(controlPageConfigProvider.notifier).state = ref
                      .read(filteredConfigsProvider)
                      .firstWhereOrNull((c) =>
                          c.id ==
                          ref.read(appGridSettingsProvider).lastUsedConfig);
                }

                await Db.saveConfigs(ref.read(configsProvider));
                await Db.saveHiddenConfigs(ref.read(hiddenConfigsProvider));
              },
              child: Text(el.buttonLabelLoc.save).small,
            ),
          ],
        );
      case ConfigListState(override: true):
        return OverrideWidgets();
      default:
        return const SizedBox.shrink(key: ValueKey('empty'));
    }
  }
}
