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
    final isRecording = widget.config.isRecording;
    final isDefaultConfig = defaultConfigs.contains(widget.config);

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
        IconButton(
          size: ButtonSize.small,
          variance: ButtonVariance.ghost,
          icon: Icon(Icons.folder,
              color: !isRecording ? Colors.transparent : null),
          onPressed: !isRecording
              ? null
              : () => {
                    configDropdownKey.currentState?.closePopup(),
                    DirectoryUtils.openFolder(widget.config.savePath!)
                  },
        ),
        VerticalDivider(indent: 8, endIndent: 8),
        IconButton(
          size: ButtonSize.small,
          variance: ButtonVariance.ghost,
          icon: Icon(
            Icons.edit,
            color: isDefaultConfig ? Colors.transparent : null,
          ),
          onPressed:
              isDefaultConfig ? null : () => _onEditPressed(widget.config),
        ),
        VerticalDivider(indent: 8, endIndent: 8),
        IconButton(
          size: ButtonSize.small,
          variance: ButtonVariance.ghost,
          icon: Icon(
            Icons.delete,
            color: isDefaultConfig ? Colors.transparent : null,
          ),
          onPressed: isDefaultConfig ? null : _onRemoveConfigPressed,
        ),
      ],
    );
  }

  void _onDetailPressed() {
    configDropdownKey.currentState?.closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDetailDialog(config: widget.config),
    );
  }

  Future<void> _onRemoveConfigPressed() async {
    configDropdownKey.currentState?.closePopup();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfigDeleteDialog(config: widget.config),
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
