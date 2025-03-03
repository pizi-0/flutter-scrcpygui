// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

import '../../../../providers/adb_provider.dart';
import '../../../../providers/config_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../utils/const.dart';
import '../../../../utils/scrcpy_utils.dart';
import 'widgets/config_combobox_item.dart';

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
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ConfigCustom(
            title: el.configLoc.label,
            child: IconButton(
                variance: ButtonVariance.ghost,
                onPressed: _onNewConfigPressed,
                icon: const Icon(Icons.add)),
          ),
        ),
        Card(
          padding: const EdgeInsets.all(8),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: Select(
                  itemBuilder: (context, value) => Text(value.configName),
                  placeholder: Text(el.configLoc.select),
                  value: selectedConfig,
                  onChanged: (value) {
                    ref.read(selectedConfigProvider.notifier).state = value;
                    setState(() {});
                  },
                  popup: SelectPopup(
                    items: SelectItemList(
                        children: allconfigs
                            .map(
                              (c) => SelectItemButton(
                                  value: c,
                                  child: ConfigDropDownItem(config: c)),
                            )
                            .toList()),
                  ).call,
                ),
              ),
              PrimaryButton(
                onPressed: loading ? null : _start,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: loading
                      ? const SizedBox.square(
                          dimension: 18, child: CircularProgressIndicator())
                      : Text(el.configLoc.start),
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
        builder: (context) => AlertDialog(
          title: Text(el.noDeviceDialogLoc.title),
          content: Text(el.noDeviceDialogLoc.contentsNew),
          actions: [
            SecondaryButton(
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
            builder: (context) => AlertDialog(
              title: Text(el.noDeviceDialogLoc.title),
              content: Text(el.noDeviceDialogLoc.contentsStart),
              actions: [
                SecondaryButton(
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
