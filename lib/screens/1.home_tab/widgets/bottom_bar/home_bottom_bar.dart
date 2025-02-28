// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:uuid/uuid.dart';

import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

import '../../../../providers/adb_provider.dart';
import '../../../../providers/config_provider.dart';
import '../../../../utils/const.dart';
import '../../../../utils/scrcpy_utils.dart';
import 'widgets/config_combobox_item.dart';

final configKey = GlobalKey<ComboBoxState>(debugLabel: 'config list combo box');

class HomeBottomBar extends ConsumerStatefulWidget {
  const HomeBottomBar({super.key});

  @override
  ConsumerState<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends ConsumerState<HomeBottomBar> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final allconfigs = ref.watch(configsProvider);
    final selectedConfig = ref.watch(selectedConfigProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ConfigCustom(
            title: el.homeLoc.config.label,
            child: Tooltip(
              message: el.homeLoc.config.new$,
              child: IconButton(
                  onPressed: _onNewConfigPressed,
                  icon: const Icon(FluentIcons.add)),
            ),
          ),
        ),
        Card(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: ComboBox(
                  key: configKey,
                  isExpanded: true,
                  placeholder: Text(el.homeLoc.config.select),
                  value: selectedConfig,
                  onChanged: (value) {
                    ref.read(selectedConfigProvider.notifier).state = value;
                    setState(() {});
                  },
                  items: allconfigs
                      .map(
                        (c) => ComboBoxItem(
                            value: c, child: ConfigDropDownItem(config: c)),
                      )
                      .toList(),
                ),
              ),
              Button(
                onPressed: loading ? null : _start,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: loading
                      ? const SizedBox.square(
                          dimension: 18, child: ProgressRing())
                      : Text(el.homeLoc.config.start),
                ),
              )
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
      ref.read(configScreenConfig.notifier).state = newconfig;
      context.push('/home/config-settings');
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ContentDialog(
          title: Text(el.noDeviceDialogLoc.title),
          content: Text(el.noDeviceDialogLoc.contents),
          actions: [
            Button(
              child: Text(el.buttonLabelLoc.close),
              onPressed: () => context.pop(),
            )
          ],
        ),
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
        builder: (context) => ContentDialog(
          title: Text(el.noConfigDialogLoc.title),
          content: Text(el.noConfigDialogLoc.contents),
          actions: [
            Button(
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
            builder: (context) => ContentDialog(
              title: Text(el.noDeviceDialogLoc.title),
              content: Text(el.noDeviceDialogLoc.contents),
              actions: [
                Button(
                  child: Text(el.buttonLabelLoc.close),
                  onPressed: () => context.pop(),
                )
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
}
