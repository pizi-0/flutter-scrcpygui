import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config_tags.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ConfigFilterButton extends ConsumerStatefulWidget {
  const ConfigFilterButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigFilterButtonState();
}

class _ConfigFilterButtonState extends ConsumerState<ConfigFilterButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ref
        .watch(configTags)
        .where(
            (e) => e != ConfigTag.customConfig && e != ConfigTag.defaultConfig)
        .toList();

    return IconButton.ghost(
      icon: Icon(
        BootstrapIcons.filter,
        color: filters.isNotEmpty ? theme.colorScheme.primary : null,
      ),
      onSecondaryTapDown: (details) => ref.read(configTags.notifier).clearTag(),
      onLongPressStart: (details) => ref.read(configTags.notifier).clearTag(),
      onPressed: () {
        showPopover(
          context: context,
          alignment: Alignment.bottomCenter,
          follow: false,
          builder: (context) => ModalContainer(
            padding: EdgeInsets.all(8),
            child: ConfigFilterPopover(),
          ),
        );
      },
    );
  }
}

class ConfigFilterPopover extends ConsumerStatefulWidget {
  const ConfigFilterPopover({super.key});

  @override
  ConsumerState<ConfigFilterPopover> createState() =>
      _ConfigFilterPopoverState();
}

class _ConfigFilterPopoverState extends ConsumerState<ConfigFilterPopover> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(configTags);
    final tagsList = ConfigTag.values
        .where(
            (t) => t != ConfigTag.customConfig && t != ConfigTag.defaultConfig)
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150),
      child: GridView.builder(
        itemCount: tagsList.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 16 / 9,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) => Tooltip(
          tooltip: (context) => PgTooltipContainer(
              child: Text(getTooltip(tagsList[index].label))),
          child: Chip(
            style: filters.contains(tagsList[index])
                ? ButtonStyle.primary()
                : null,
            onPressed: () {
              ref.read(configTags.notifier).toggleTag(tagsList[index]);

              if (tagsList[index] == ConfigTag.mirror) {
                ref.read(configTags.notifier).removeTag(ConfigTag.recording);
              }
              if (tagsList[index] == ConfigTag.recording) {
                ref.read(configTags.notifier).removeTag(ConfigTag.mirror);
              }

              if (tagsList[index] == ConfigTag.audioOnly) {
                ref.read(configTags.notifier).removeTag(ConfigTag.videoOnly);
              }

              if (tagsList[index] == ConfigTag.videoOnly) {
                ref.read(configTags.notifier).removeTag(ConfigTag.audioOnly);
              }
            },
            child: Text(tagsList[index].label.substring(0, 3).toUpperCase()),
          ),
        ),
      ),
    );
  }

  getTooltip(String label) {
    switch (label.toLowerCase()) {
      case 'mir':
        return el.modeSection.mainMode.mirror;
      case 'rec':
        return el.modeSection.mainMode.record;
      case 'aud':
        return el.modeSection.scrcpyMode.audioOnly;
      case 'vid':
        return el.modeSection.scrcpyMode.videoOnly;
      case 'app':
        return 'With app';
      case 'virt':
        return 'Virtual display';
      default:
        return label;
    }
  }
}

class PgTooltipContainer extends StatelessWidget {
  final Widget child;
  const PgTooltipContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;

    return Padding(
      padding: const EdgeInsets.all(6) * scaling,
      child: Container(
        padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ) *
            scaling,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(theme.radiusSm),
        ),
        child: child.xSmall(),
      ),
    );
  }
}
