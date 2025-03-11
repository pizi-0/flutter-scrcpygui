import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
          variance: ButtonVariance.ghost,
          size: ButtonSize.small,
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
            size: ButtonSize.small,
            variance: ButtonVariance.ghost,
            icon: const Icon(Icons.folder),
            onPressed: () => {
              configDropdownKey.currentState?.closePopup(),
              DirectoryUtils.openFolder(widget.config.savePath!)
            },
          ),
        if (widget.config.isRecording &&
            !defaultConfigs.contains(widget.config))
          const VerticalDivider(),
        if (!defaultConfigs.contains(widget.config))
          IconButton(
            size: ButtonSize.small,
            variance: ButtonVariance.ghost,
            icon: const Icon(Icons.edit),
            onPressed: () => _onEditPressed(widget.config),
          ),
        if (!defaultConfigs.contains(widget.config)) const VerticalDivider(),
        if (!defaultConfigs.contains(widget.config))
          IconButton(
            size: ButtonSize.small,
            variance: ButtonVariance.ghost,
            icon: const Icon(Icons.delete),
            onPressed: _onRemoveConfigPressed,
          ),
      ],
    );
  }

  _onDetailPressed() {
    configDropdownKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: widget.config),
    );
  }

  _onRemoveConfigPressed() async {
    configDropdownKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: widget.config),
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
      ref.read(configScreenConfig.notifier).state = config;
      context.push('/home/config-settings');
    }
  }
}
