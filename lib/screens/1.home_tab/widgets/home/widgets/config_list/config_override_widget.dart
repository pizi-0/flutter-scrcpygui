import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

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
            child: Text(e.name.capitalize).small,
          ),
        )
      ],
    );
  }
}
