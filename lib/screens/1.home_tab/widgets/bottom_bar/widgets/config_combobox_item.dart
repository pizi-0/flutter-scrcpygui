import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/directory_utils.dart';

import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../home/widgets/config_list.dart';
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
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: _onDetailPressed,
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
            icon: const Icon(Icons.folder),
            onPressed: () =>
                {DirectoryUtils.openFolder(widget.config.savePath!)},
          ),
        if (widget.config.isRecording &&
            !defaultConfigs.contains(widget.config))
          const VerticalDivider(),
        if (!defaultConfigs.contains(widget.config))
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _onEditPressed(widget.config),
          ),
        if (!defaultConfigs.contains(widget.config)) const VerticalDivider(),
        if (!defaultConfigs.contains(widget.config))
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _onRemoveConfigPressed,
          ),
      ],
    );
  }

  _onDetailPressed() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: widget.config),
    );
  }

  _onRemoveConfigPressed() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: widget.config),
    );
  }

  _onEditPressed(ScrcpyConfig config) {
    ref.read(selectedConfigProvider.notifier).state = config;

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
            FButton(
              style: FButtonStyle.primary,
              label: Text(el.buttonLabelLoc.close),
              onPress: () => context.pop(),
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
