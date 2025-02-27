import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/directory_utils.dart';

import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../home_bottom_bar.dart';
import 'config_delete_dialog.dart';
import 'config_detail_dialog.dart';

class ConfigDropDownItem extends ConsumerStatefulWidget {
  final ScrcpyConfig config;
  const ConfigDropDownItem({super.key, required this.config});

  @override
  ConsumerState<ConfigDropDownItem> createState() => _ConfigDropDownItemState();
}

class _ConfigDropDownItemState extends ConsumerState<ConfigDropDownItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: el.homeTab.config.details,
          child: IconButton(
            icon: const Icon(FluentIcons.info),
            onPressed: _onDetailPressed,
          ),
        ),
        Expanded(
          child: Text(
            widget.config.configName,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
        if (widget.config.isRecording)
          IconButton(
            icon: const Icon(FluentIcons.open_folder_horizontal),
            onPressed: () => DirectoryUtils.openFolder(widget.config.savePath!),
          ),
        if (widget.config.isRecording &&
            !defaultConfigs.contains(widget.config))
          const Divider(
            direction: Axis.vertical,
            size: 18,
          ),
        if (!defaultConfigs.contains(widget.config))
          IconButton(
            icon: const Icon(FluentIcons.edit),
            onPressed: () => _onEditPressed(widget.config),
          ),
        if (!defaultConfigs.contains(widget.config))
          const Divider(
            direction: Axis.vertical,
            size: 18,
          ),
        if (!defaultConfigs.contains(widget.config))
          IconButton(
            icon: const Icon(FluentIcons.delete),
            onPressed: _onRemoveConfigPressed,
          ),
      ],
    );
  }

  _onDetailPressed() {
    configKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: widget.config),
    );
  }

  _onRemoveConfigPressed() async {
    configKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: widget.config),
    );
  }

  _onEditPressed(ScrcpyConfig config) {
    configKey.currentState?.closePopup();

    ref.read(selectedConfigProvider.notifier).state = config;

    if (ref.read(selectedDeviceProvider) == null) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ContentDialog(
          title: Text(el.noDeviceDialog.title),
          content: Text(
            el.noDeviceDialog.contents,
            textAlign: TextAlign.start,
          ),
          actions: [
            Button(
              child: Text(el.buttonLabel.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
      );
    } else {
      ref.read(configScreenConfig.notifier).state = config;
      context.push('/config-settings');
    }
  }
}
