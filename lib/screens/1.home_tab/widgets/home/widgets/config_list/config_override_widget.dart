import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../models/scrcpy_related/scrcpy_enum.dart';
import '../../../../../../providers/config_provider.dart';

class OverrideWidgets extends ConsumerStatefulWidget {
  const OverrideWidgets({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverrideWidgetsState();
}

class _OverrideWidgetsState extends ConsumerState<OverrideWidgets> {
  @override
  Widget build(BuildContext context) {
    final overrides = ref.watch(configOverridesProvider);

    return Row(
      spacing: 4,
      children: [
        Chip(
          style: overrides.isNotEmpty
              ? ButtonStyle.destructiveIcon()
              : ButtonStyle.secondary(),
          onPressed: overrides.isEmpty
              ? null
              : () =>
                  ref.read(configOverridesProvider.notifier).clearOverride(),
          child: Icon(overrides.isEmpty ? BootstrapIcons.gear : Icons.clear)
              .iconSmall(),
        ),
        Gap(0, crossAxisExtent: 4),
        ...ScrcpyOverride.values.map(
          (e) => Chip(
            style: overrides.contains(e) ? ButtonStyle.primary() : null,
            onPressed: () =>
                ref.read(configOverridesProvider.notifier).toggleOverride(e),
            trailing: _overrideChipTrailing(e, overrides.contains(e)),
            child: Text(context
                    .tr('config_override_loc.${e.name.toLowerCase()}.label'))
                .small,
          ),
        )
      ],
    );
  }

  Widget? _overrideChipTrailing(ScrcpyOverride e, bool selected) {
    final theme = Theme.of(context);

    switch (e) {
      case ScrcpyOverride.record:
        return Tooltip(
          tooltip: TooltipContainer(
                  child: Text(el.configOverrideLoc.record.openFolder))
              .call,
          child: IconButton(
            variance: ButtonStyle.link(),
            density: ButtonDensity.compact,
            onPressed: () => DirectoryUtils.openFolder(defaultRecord.savePath!),
            icon: Icon(
              Icons.folder_open_rounded,
              color: selected ? theme.colorScheme.primaryForeground : null,
            ).iconSmall(),
          ),
        );

      case ScrcpyOverride.landscape:
        return Tooltip(
          tooltip:
              TooltipContainer(child: Text(el.configOverrideLoc.landscape.info))
                  .call,
          child: Icon(Icons.info_outline_rounded).iconSmall(),
        );

      default:
        return null;
    }
  }
}
