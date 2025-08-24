import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config_tags.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_button.dart';
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

    return Tooltip(
      tooltip: (context) =>
          TooltipContainer(child: Text(el.buttonLabelLoc.filter)),
      child: IconButton.ghost(
        icon: Icon(
          Icons.filter_alt_rounded,
          color: filters.isNotEmpty ? theme.colorScheme.primary : null,
        ).iconSmall(),
        onSecondaryTapDown: (details) =>
            ref.read(configTags.notifier).clearTag(),
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
      ),
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
    final filters = ref.watch(configTags).where(
        (f) => f != ConfigTag.customConfig && f != ConfigTag.defaultConfig);

    final tagsList = ConfigTag.values
        .where(
            (t) => t != ConfigTag.customConfig && t != ConfigTag.defaultConfig)
        .toList();

    List<Widget> children = [
      ...tagsList.map((t) => TagChip(tag: t)),
    ];

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(el.buttonLabelLoc.filter).textSmall.bold,
              Spacer(),
              IgnorePointer(
                ignoring: filters.isEmpty,
                child: FadeIn(
                  duration: 200.milliseconds,
                  animate: filters.isNotEmpty,
                  child: PgDestructiveButton(
                      density: ButtonDensity.dense,
                      onPressed: () => ref.read(configTags.notifier).clearTag(),
                      child: Text(el.buttonLabelLoc.clear)),
                ),
              )
            ],
          ),
          Divider(),
          GridView.builder(
            itemCount: children.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 16 / 9,
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) => children[index],
          ),
        ],
      ),
    );
  }
}

class ConfigFilterButtonBig extends ConsumerStatefulWidget {
  final bool disable;
  const ConfigFilterButtonBig({super.key, this.disable = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigFilterButtonBigState();
}

class _ConfigFilterButtonBigState extends ConsumerState<ConfigFilterButtonBig> {
  @override
  Widget build(BuildContext context) {
    final filters = ref
        .watch(configTags)
        .where(
            (t) => t != ConfigTag.customConfig && t != ConfigTag.defaultConfig)
        .toList();

    final tagsList = ConfigTag.values
        .where(
            (t) => t != ConfigTag.customConfig && t != ConfigTag.defaultConfig)
        .toList();

    return IgnorePointer(
      ignoring: widget.disable,
      child: Row(
        spacing: 4,
        // runSpacing: 4,
        children: [
          Chip(
            style: filters.isNotEmpty
                ? ButtonStyle.destructiveIcon()
                : ButtonStyle.secondary(),
            onPressed: filters.isEmpty
                ? null
                : () => ref.read(configTags.notifier).clearTag(),
            child: Icon(filters.isEmpty ? BootstrapIcons.filter : Icons.clear)
                .iconSmall(),
          ),
          Gap(0, crossAxisExtent: 4),
          ...tagsList.map((t) => TagChip(tag: t))
        ],
      ),
    );
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

class TagChip extends ConsumerWidget {
  final ConfigTag tag;
  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(configTags);

    return Tooltip(
      tooltip: (context) =>
          TooltipContainer(child: Text(getTooltip(tag.label))),
      child: Chip(
        style: filters.contains(tag) ? ButtonStyle.primary() : null,
        onPressed: () {
          ref.read(configTags.notifier).toggleTag(tag);

          if (tag == ConfigTag.mirror) {
            ref.read(configTags.notifier).removeTag(ConfigTag.recording);
          }
          if (tag == ConfigTag.recording) {
            ref.read(configTags.notifier).removeTag(ConfigTag.mirror);
          }

          if (tag == ConfigTag.audioOnly) {
            ref.read(configTags.notifier).removeTag(ConfigTag.videoOnly);
            ref.read(configTags.notifier).removeTag(ConfigTag.virtualDisplay);
          }

          if (tag == ConfigTag.videoOnly) {
            ref.read(configTags.notifier).removeTag(ConfigTag.audioOnly);
          }

          if (tag == ConfigTag.virtualDisplay) {
            ref.read(configTags.notifier).removeTag(ConfigTag.audioOnly);
          }
        },
        child: Text(tag.label.substring(0, 3).capitalize).small,
      ),
    );
  }

  String getTooltip(String label) {
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
        return el.configFiltersLoc.label.withApp;
      case 'virt':
        return el.configFiltersLoc.label.virt;
      default:
        return label;
    }
  }
}
