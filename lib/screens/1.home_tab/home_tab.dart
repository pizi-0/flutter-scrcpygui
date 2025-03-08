import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/bottom_bar/widgets/config_combobox_item.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/connection_error_dialog.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/device_tile.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:scrcpygui/widgets/custom_ui/pg_select.dart' as pg;

import '../../db/db.dart';
import '../../utils/const.dart';

final configDropdownKey = GlobalKey<pg.SelectState>();

class HomeTab extends ConsumerStatefulWidget {
  static const route = '/home';
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final connected = ref.watch(adbProvider);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return PgScaffold(
          title: el.homeLoc.title,
          footers: [
            if (sizingInformation.deviceScreenType == DeviceScreenType.mobile ||
                sizingInformation.deviceScreenType == DeviceScreenType.tablet)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PgSectionCard(
                  label: el.configLoc.label,
                  labelTrail: IconButton.ghost(
                    icon: const Icon(Icons.add),
                    onPressed: _onNewConfigPressed,
                  ),
                  children: const [
                    ConfigList(),
                  ],
                ),
              )
          ],
          children: [
            PgSectionCard(
              cardPadding: const EdgeInsets.all(8),
              // borderColor: Colors.transparent,
              label: el.homeLoc.devices.label(count: '${connected.length}'),
              children: connected
                  .mapIndexed(
                    (index, conn) => Column(
                      spacing: 8,
                      children: [
                        DeviceTile(device: conn),
                        if (index != connected.length - 1) const Divider()
                      ],
                    ),
                  )
                  .toList(),
            ),
            if (sizingInformation.deviceScreenType == DeviceScreenType.desktop)
              PgSectionCard(
                label: el.configLoc.label,
                labelTrail: IconButton.ghost(
                  icon: const Icon(Icons.add),
                  onPressed: _onNewConfigPressed,
                ),
                children: const [
                  ConfigList(),
                ],
              ),
          ],
        );
      },
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
        builder: (context) => ErrorDialog(
            title: el.noDeviceDialogLoc.title,
            content: [Text(el.noDeviceDialogLoc.contentsNew)]),
      );
    }
  }
}

class ConfigList extends ConsumerStatefulWidget {
  const ConfigList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfigListState();
}

class ConfigListState extends ConsumerState<ConfigList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);
    final config = ref.watch(selectedConfigProvider);

    return Row(
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
}
