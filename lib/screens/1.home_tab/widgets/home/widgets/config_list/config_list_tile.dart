import 'package:awesome_extensions/awesome_extensions.dart'
    show NumExtension, PaddingX;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../db/db.dart';
import '../../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../../providers/adb_provider.dart';
import '../../../../../../providers/config_provider.dart';
import '../../../../../../utils/const.dart';
import '../../../../../../utils/directory_utils.dart';
import '../../../../../../utils/scrcpy_utils.dart';
import '../../../../../../widgets/custom_ui/pg_list_tile.dart';
import '../../../bottom_bar/widgets/config_delete_dialog.dart';
import '../../../bottom_bar/widgets/config_detail_dialog.dart';
import '../connection_error_dialog.dart';
import '../config_list.dart';

class ConfigListTile extends ConsumerStatefulWidget {
  final ScrcpyConfig conf;
  final bool showStartButton;
  const ConfigListTile(
      {super.key, required this.conf, this.showStartButton = true});

  @override
  ConsumerState<ConfigListTile> createState() => _ConfigListTileState();
}

class _ConfigListTileState extends ConsumerState<ConfigListTile> {
  bool loading = false;
  bool loadingWithOverrides = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overrides = ref.watch(configOverridesProvider);

    return PgListTile(
      title: widget.conf.configName,
      trailing: widget.showStartButton
          ? Row(
              children: [
                AnimatedSwitcher(
                  duration: 200.milliseconds,
                  child: overrides.isEmpty
                      ? null
                      : IntrinsicHeight(
                          child: Stack(
                            children: [
                              IconButton.ghost(
                                onPressed: loadingWithOverrides
                                    ? null
                                    : () {
                                        ref
                                            .read(
                                                selectedConfigProvider.notifier)
                                            .state = widget.conf;
                                        _start(withOverrides: true);
                                      },
                                icon: loadingWithOverrides
                                    ? SizedBox.square(
                                        dimension: 20,
                                        child: Center(
                                            child: CircularProgressIndicator()))
                                    : const Icon(Icons.play_arrow_rounded),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Icon(
                                  Icons.settings_rounded,
                                  color: Colors.amber,
                                ).iconX3Small(),
                              )
                            ],
                          ),
                        ),
                ),
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
            )
          : null,
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
                  onPressed: () => _onRemoveConfigPressed(widget.conf),
                  icon: const Icon(Icons.delete_rounded),
                ),
            ],
          ),
        ),
      ).paddingOnly(top: 8),
    );
  }

  Future<void> _start({bool withOverrides = false}) async {
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
        if (!withOverrides) {
          loading = true;
        } else {
          loadingWithOverrides = true;
        }
        setState(() {});

        ScrcpyConfig finalConfig = selectedConfig;

        if (withOverrides) {
          final overrides = ref.read(configOverridesProvider);
          finalConfig = ScrcpyUtils.handleOverrides(overrides, selectedConfig);
        }

        await ScrcpyUtils.newInstance(ref, selectedConfig: finalConfig);
        await Db.saveLastUsedConfig(selectedConfig);

        if (mounted) {
          loading = false;
          loadingWithOverrides = false;
          setState(() {});
        }
      }
    }
  }

  void _onDetailPressed(ScrcpyConfig config) {
    configDropdownKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: config),
    );
  }

  Future<void> _onRemoveConfigPressed(ScrcpyConfig config) async {
    configDropdownKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: config),
    );
  }

  void _onEditPressed(ScrcpyConfig config) {
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
