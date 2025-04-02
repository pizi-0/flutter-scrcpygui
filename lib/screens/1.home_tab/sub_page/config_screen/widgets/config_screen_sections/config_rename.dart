import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

List<String> defaultName = [
  'New config',
  'Default (Mirror)',
  'Default (Record)'
];

class RenameConfig extends ConsumerStatefulWidget {
  final ScrcpyConfig oldConfig;
  const RenameConfig({super.key, required this.oldConfig});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RenameConfigState();
}

class _RenameConfigState extends ConsumerState<RenameConfig> {
  TextEditingController controller = TextEditingController();
  FocusNode node = FocusNode();
  bool nameExist = false;
  bool notAllowed = false;

  @override
  void initState() {
    final selectedConfig = ref.read(configScreenConfig)!;

    controller = TextEditingController(text: selectedConfig.configName);
    node.addListener(_onFocusLost);
    super.initState();
  }

  @override
  dispose() {
    node.removeListener(_onFocusLost);
    super.dispose();
  }

  _onFocusLost() {
    if (!node.hasFocus && nameExist || controller.text.isEmpty) {
      controller.text = widget.oldConfig.configName.trim();
      ref
          .read(configScreenConfig.notifier)
          .setName(widget.oldConfig.configName.trim());
      nameExist = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);
    final theme = Theme.of(context);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgSectionCard(
      label: el.renameSection.title,
      children: [
        ConfigCustom(
          dimTitle: false,
          title: el.closeDialogLoc.name.removeSpecial,
          subtitle: el.closeDialogLoc.nameExist.removeSpecial,
          showinfo: nameExist,
          child: TextField(
            decoration: nameExist
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.radiusMd),
                    color: theme.colorScheme.destructive,
                    border: Border.all(
                      color: theme.colorScheme.destructive,
                    ),
                  )
                : null,
            filled: true,
            controller: controller,
            focusNode: node,
            onChanged: (value) {
              nameExist = allConfigs
                  .where((conf) =>
                      conf.configName.trim().toLowerCase() ==
                          value.trim().toLowerCase() &&
                      conf.id != widget.oldConfig.id)
                  .isNotEmpty;

              setState(() {});
              ref.read(configScreenConfig.notifier).setName(value.trim());
            },
            onSubmitted: nameExist
                ? null
                : (value) =>
                    ref.read(configScreenConfig.notifier).setName(value.trim()),
          ),
        )
      ],
    );
  }
}
