import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_subtitle.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../providers/adb_provider.dart';
import '../../../../../../providers/version_provider.dart';
import '../../../../../../utils/command_runner.dart';

class AppConfig extends ConsumerStatefulWidget {
  const AppConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppConfigState();
}

class AppConfigState extends ConsumerState<AppConfig> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(configScreenConfig)!;
    final showInfo = ref.watch(configScreenShowInfo);

    final appList = selectedDevice!.info?.appList ?? [];

    appList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return PgSectionCard(
      label: el.appSection.title,
      labelTrail: IconButton.ghost(
        onPressed: loading ? null : _onRefreshApp,
        icon: loading
            ? SizedBox.square(
                dimension: 20,
                child: Center(child: CircularProgressIndicator()))
            : Icon(Icons.refresh),
      ),
      children: [
        PgSubtitle(
          subtitle: selectedConfig.appOptions.selectedApp != null
              ? selectedConfig.appOptions.forceClose
                  ? el.appSection.select.info.fc(
                      app: selectedConfig.appOptions.selectedApp!.packageName)
                  : el.appSection.select.info.alt(
                      app: selectedConfig.appOptions.selectedApp!.packageName)
              : el.appSection.select.label.toLowerCase(),
          showSubtitle: showInfo,
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: Select(
                  filled: true,
                  value: selectedConfig.appOptions.selectedApp,
                  placeholder: Text('Select an app'),
                  popupConstraints: BoxConstraints(maxHeight: appWidth - 100),
                  onChanged: (app) {
                    ref
                        .read(configScreenConfig.notifier)
                        .setAppConfig(selectedApp: app);
                  },
                  popup: SelectPopup.builder(
                    searchPlaceholder: Text('Search'),
                    builder: (context, searchQuery) {
                      return SelectItemList(
                        children: appList
                            .where((app) => app.name
                                .toLowerCase()
                                .contains(searchQuery?.toLowerCase() ?? ''))
                            .map((e) =>
                                SelectItemButton(value: e, child: Text(e.name)))
                            .toList(),
                      );
                    },
                  ).call,
                  itemBuilder: (context, value) => Text(value.name),
                ),
              ),
              if (selectedConfig.appOptions.selectedApp != null)
                SizedBox.square(
                  dimension: 33,
                  child: IconButton.ghost(
                    density: ButtonDensity.iconDense,
                    onPressed: () => ref
                        .read(configScreenConfig.notifier)
                        .setAppConfig(reset: true),
                    icon: Icon(Icons.clear),
                  ),
                )
            ],
          ),
        ),
        Divider(),
        ConfigCustom(
          onPressed: selectedConfig.appOptions.selectedApp != null
              ? () => _onForceCloseCheck()
              : null,
          title: el.appSection.forceClose.label,
          childExpand: false,
          subtitle: selectedConfig.appOptions.forceClose
              ? el.appSection.forceClose.info.alt
              : el.appSection.forceClose.label.toLowerCase(),
          showinfo: showInfo,
          child: Checkbox(
            state: selectedConfig.appOptions.forceClose
                ? CheckboxState.checked
                : CheckboxState.unchecked,
            onChanged: selectedConfig.appOptions.selectedApp != null
                ? (val) => _onForceCloseCheck()
                : null,
          ),
        )
      ],
    );
  }

  _onForceCloseCheck() {
    final config = ref.read(configScreenConfig);
    var currentAppOption = config!.appOptions;

    ref
        .read(configScreenConfig.notifier)
        .setAppConfig(forceClose: !currentAppOption.forceClose);
  }

  _onRefreshApp() async {
    loading = true;
    setState(() {});

    var dev = ref.read(selectedDeviceProvider)!;
    final workDir = ref.read(execDirProvider);

    final res = await CommandRunner.runScrcpyCommand(workDir, dev,
        args: ['--list-apps']);

    final applist = getAppsList(res.stdout);

    dev = dev.copyWith(info: dev.info!.copyWith(appList: applist));

    ref.read(savedAdbDevicesProvider.notifier).addEditDevices(dev);

    ref.read(selectedDeviceProvider.notifier).state = dev;

    await Db.saveAdbDevice(ref.read(savedAdbDevicesProvider));

    loading = false;
    setState(() {});
  }
}
