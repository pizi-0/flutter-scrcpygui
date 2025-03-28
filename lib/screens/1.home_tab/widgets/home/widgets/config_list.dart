import 'package:awesome_extensions/awesome_extensions.dart' show PaddingX;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_list_tile.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../db/db.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/directory_utils.dart';
import '../../../../../utils/scrcpy_utils.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';
import '../../../../../widgets/custom_ui/pg_select.dart' as pg;
import '../../bottom_bar/widgets/config_combobox_item.dart';
import '../../bottom_bar/widgets/config_delete_dialog.dart';
import '../../bottom_bar/widgets/config_detail_dialog.dart';
import 'connection_error_dialog.dart';

final configDropdownKey = GlobalKey<pg.SelectState>();

// for isMobile
class ConfigListSmall extends ConsumerStatefulWidget {
  const ConfigListSmall({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfigListSmallState();
}

class ConfigListSmallState extends ConsumerState<ConfigListSmall> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);
    final config = ref.watch(selectedConfigProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgSectionCard(
      label: el.configLoc.label(count: '${allConfigs.length}'),
      labelTrail: IconButton.ghost(
        leading: Text(el.configLoc.new$),
        icon: const Icon(Icons.add),
        onPressed: _onNewConfigPressed,
      ),
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: pg.Select(
                key: configDropdownKey,
                onChanged: (value) =>
                    ref.read(selectedConfigProvider.notifier).state = value,
                filled: true,
                placeholder: const Text('Select config'),
                value: config,
                popup: SelectPopup(
                  items: SelectItemList(
                    children: allConfigs
                        .map((conf) => SelectItemButton(
                            value: conf,
                            child: IntrinsicHeight(
                                child: ConfigDropDownItem(config: conf))))
                        .toList(),
                  ),
                ).call,
                itemBuilder: (context, value) => Text(value.configName),
              ),
            ),
            PrimaryButton(
              onPressed: loading ? null : _start,
              child: loading
                  ? const CircularProgressIndicator().iconLarge()
                  : Text(el.configLoc.start),
            )
          ],
        )
      ],
    );
  }

  _onNewConfigPressed() {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedDevice != null) {
      final newconfig = newConfig.copyWith(id: const Uuid().v4());
      ref.read(configScreenConfig.notifier).setConfig(newconfig);
      context.push('/home/config-settings');
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ErrorDialog(
            title: el.noDeviceDialogLoc.title,
            content: [Text(el.noDeviceDialogLoc.contentsNew)]),
      );
    }
  }

  _start() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final selectedConfig = ref.read(selectedConfigProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: Text(el.noConfigDialogLoc.title),
          content: Text(el.noConfigDialogLoc.contents),
          actions: [
            SecondaryButton(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      if (selectedDevice == null) {
        if (ref.read(adbProvider).length == 1) {
          ref.read(selectedDeviceProvider.notifier).state =
              ref.read(adbProvider).first;

          _start();
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => ErrorDialog(
              title: el.noDeviceDialogLoc.title,
              content: [
                Text(el.noDeviceDialogLoc.contentsStart),
              ],
            ),
          );
        }
      } else {
        loading = true;
        setState(() {});
        await ScrcpyUtils.newInstance(
          ref,
          selectedConfig: selectedConfig,
          customInstanceName: selectedConfig.appOptions?.selectedApp != null
              ? '${selectedConfig.appOptions!.selectedApp!.name} (${selectedConfig.configName})'
              : '',
        );
        await Db.saveLastUsedConfig(selectedConfig);

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    }
  }
}

// for isDesktop || isTablet
class ConfigListBig extends ConsumerStatefulWidget {
  const ConfigListBig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfigListBigState();
}

class ConfigListBigState extends ConsumerState<ConfigListBig> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);

    return PgSectionCard(
      label: el.configLoc.label(count: '${allConfigs.length}'),
      labelTrail: IconButton.ghost(
        icon: const Icon(Icons.add),
        leading: Text(el.configLoc.new$),
        onPressed: _onNewConfigPressed,
      ),
      children: [
        ...allConfigs.mapIndexed(
          (index, conf) => Column(
            spacing: 8,
            children: [
              ConfigListTile(conf: conf),
              if (index != allConfigs.length - 1) const Divider()
            ],
          ),
        ),
      ],
    );
  }

  _onNewConfigPressed() {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedDevice != null) {
      final newconfig = newConfig.copyWith(id: const Uuid().v4());
      ref.read(configScreenConfig.notifier).setConfig(newconfig);
      context.push('/home/config-settings');
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ErrorDialog(
            title: el.noDeviceDialogLoc.title,
            content: [Text(el.noDeviceDialogLoc.contentsNew)]),
      );
    }
  }
}

class ConfigListTile extends ConsumerStatefulWidget {
  final ScrcpyConfig conf;
  const ConfigListTile({super.key, required this.conf});

  @override
  ConsumerState<ConfigListTile> createState() => _ConfigListTileState();
}

class _ConfigListTileState extends ConsumerState<ConfigListTile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PgListTile(
      title: widget.conf.configName,
      trailing: Row(
        children: [
          IconButton.ghost(
            onPressed: loading
                ? null
                : () {
                    ref.read(selectedConfigProvider.notifier).state =
                        widget.conf;
                    _start();
                  },
            icon: loading
                ? SizedBox.square(
                    dimension: 20,
                    child: Center(child: CircularProgressIndicator()))
                : const Icon(Icons.play_arrow_rounded),
          ),
        ],
      ),
      content: OutlinedContainer(
        borderRadius: theme.borderRadiusSm,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              IconButton.ghost(
                size: ButtonSize.small,
                onPressed: () => _onDetailPressed(widget.conf),
                icon: const Icon(Icons.info_rounded),
              ),
              if (widget.conf.isRecording)
                const VerticalDivider(indent: 10, endIndent: 10),
              if (widget.conf.isRecording)
                IconButton.ghost(
                  size: ButtonSize.small,
                  onPressed: () =>
                      DirectoryUtils.openFolder(widget.conf.savePath!),
                  icon: const Icon(Icons.folder),
                ),
              if (!defaultConfigs.contains(widget.conf))
                const VerticalDivider(indent: 10, endIndent: 10),
              if (!defaultConfigs.contains(widget.conf))
                IconButton.ghost(
                  size: ButtonSize.small,
                  onPressed: () => _onEditPressed(widget.conf),
                  icon: const Icon(Icons.edit_rounded),
                ),
              if (!defaultConfigs.contains(widget.conf))
                const VerticalDivider(indent: 10, endIndent: 10),
              if (!defaultConfigs.contains(widget.conf))
                IconButton.ghost(
                  size: ButtonSize.small,
                  onPressed: _onRemoveConfigPressed,
                  icon: const Icon(Icons.delete_rounded),
                ),
            ],
          ),
        ),
      ).paddingOnly(top: 8),
    );
  }

  _start() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final selectedConfig = ref.read(selectedConfigProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: Text(el.noConfigDialogLoc.title),
          content: Text(el.noConfigDialogLoc.contents),
          actions: [
            SecondaryButton(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      if (selectedDevice == null) {
        if (ref.read(adbProvider).length == 1) {
          ref.read(selectedDeviceProvider.notifier).state =
              ref.read(adbProvider).first;

          _start();
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => ErrorDialog(
              title: el.noDeviceDialogLoc.title,
              content: [
                Text(el.noDeviceDialogLoc.contentsStart),
              ],
            ),
          );
        }
      } else {
        loading = true;
        setState(() {});
        await ScrcpyUtils.newInstance(ref, selectedConfig: selectedConfig);
        await Db.saveLastUsedConfig(selectedConfig);

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    }
  }

  _onDetailPressed(ScrcpyConfig config) {
    configDropdownKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: config),
    );
  }

  _onRemoveConfigPressed() async {
    final config = ref.read(selectedConfigProvider)!;
    configDropdownKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: config),
    );
  }

  _onEditPressed(ScrcpyConfig config) {
    ref.read(selectedConfigProvider.notifier).state = config;
    configDropdownKey.currentState?.closePopup();

    if (ref.read(selectedDeviceProvider) == null) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(el.noDeviceDialogLoc.title),
          content: Text(
            el.noDeviceDialogLoc.contentsEdit,
            textAlign: TextAlign.start,
          ),
          actions: [
            SecondaryButton(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      ref.read(configScreenConfig.notifier).setConfig(config);
      context.push('/home/config-settings');
    }
  }
}
