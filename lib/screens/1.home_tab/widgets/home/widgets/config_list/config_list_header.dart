import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../db/db.dart';
import '../../../../../../models/config_list_screen_state.dart';
import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../providers/config_provider.dart';
import '../config_filter_button.dart';
import 'config_override_widget.dart';

class ConfigListHeader extends ConsumerStatefulWidget {
  final List<ScrcpyConfig> reordered;
  const ConfigListHeader({
    super.key,
    this.reordered = const [],
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: headerState.isOpen ? 8 : 0,
          children: [
            ButtonGroup(
              children: [
                Button(
                  style: headerState.filtering
                      ? ButtonStyle.primary(density: ButtonDensity.dense)
                      : ButtonStyle.secondary(density: ButtonDensity.dense),
                  onPressed: () {
                    ref.read(configListStateProvider.notifier).state =
                        headerState.copyWith(
                            filtering: !headerState.filtering,
                            reorder: false,
                            override: false);
                  },
                  onSecondaryTapUp: (details) =>
                      ref.read(configTags.notifier).clearTag(),
                  child: tags.isNotEmpty
                      ? Text('Filter (${tags.length})')
                      : Text('Filter'),
                ),
                Button(
                  style: headerState.reorder
                      ? ButtonStyle.primary(density: ButtonDensity.dense)
                      : ButtonStyle.secondary(density: ButtonDensity.dense),
                  onPressed: () {
                    ref.read(configListStateProvider.notifier).state =
                        headerState.copyWith(
                            filtering: false,
                            reorder: !headerState.reorder,
                            override: false);

                    ref.read(configTags.notifier).clearTag();
                  },
                  child: Text(el.buttonLabelLoc.reorder),
                ),
                Button(
                  style: headerState.override
                      ? ButtonStyle.primary(density: ButtonDensity.dense)
                      : ButtonStyle.secondary(density: ButtonDensity.dense),
                  onPressed: () {
                    ref.read(configListStateProvider.notifier).state =
                        headerState.copyWith(
                            filtering: false,
                            reorder: false,
                            override: !headerState.override);
                  },
                  onSecondaryTapUp: (details) {
                    ref.read(configOverridesProvider.notifier).clearOverride();
                  },
                  child: overrides.isEmpty
                      ? Text('Override')
                      : Text('Override (${overrides.length})'),
                ),
              ],
            ),
            if (headerState.isOpen)
              ZoomIn(duration: 200.milliseconds, child: Divider()),
            AnimatedContainer(
              duration: 200.milliseconds,
              height: headerState.isOpen ? 25 : 0,
              child: AnimatedSwitcher(
                duration: 200.milliseconds,
                child: _switcherChild(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _switcherChild() {
    final headerState = ref.watch(configListStateProvider);

    switch (headerState) {
      case ConfigListState(filtering: true):
        return ConfigFilterButtonBig(key: const ValueKey('filter'));
      case ConfigListState(reorder: true):
        return Row(
          key: const ValueKey('reorder'),
          spacing: 8,
          children: [
            Chip(
              style: ButtonStyle.destructiveIcon(),
              child: Icon(Icons.close_rounded).iconSmall(),
              onPressed: () => ref
                  .read(configListStateProvider.notifier)
                  .state = headerState.copyWith(reorder: false),
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
                    .update((state) => state.copyWith(reorder: false));

                await Db.saveConfigs(ref.read(configsProvider));
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
