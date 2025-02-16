import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/directory_utils.dart';

import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/const.dart';
import '../../../sub_page/config_screen/config_screen.dart';
import '../bottom_bar.dart';
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
          message: 'Show details',
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
          Tooltip(
            message: 'Open save folder',
            child: IconButton(
              icon: const Icon(FluentIcons.open_folder_horizontal),
              onPressed: () =>
                  DirectoryUtils.openFolder(widget.config.savePath!),
            ),
          ),
        if (widget.config.isRecording &&
            !defaultConfigs.contains(widget.config))
          const Divider(
            direction: Axis.vertical,
            size: 18,
          ),
        if (!defaultConfigs.contains(widget.config))
          Tooltip(
            message: 'Edit config',
            child: IconButton(
              icon: const Icon(FluentIcons.edit),
              onPressed: () => _onEditPressed(widget.config),
            ),
          ),
        if (!defaultConfigs.contains(widget.config))
          const Divider(
            direction: Axis.vertical,
            size: 18,
          ),
        if (!defaultConfigs.contains(widget.config))
          Tooltip(
            message: 'Edit config',
            child: IconButton(
              icon: const Icon(FluentIcons.delete),
              onPressed: _onRemoveConfigPressed,
            ),
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
          title: const Text('Device'),
          content: const Text(
              'No device selected.\nSelect a device to edit scrcpy config.'),
          actions: [
            Button(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } else {
      ref.read(configScreenConfig.notifier).state = config;
      AppUtils.push(context, const ConfigScreen());
    }
  }
}
