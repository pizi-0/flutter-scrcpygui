import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/app_options.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_subtitle.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../providers/adb_provider.dart';

class AppConfig extends ConsumerStatefulWidget {
  const AppConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppConfigState();
}

class AppConfigState extends ConsumerState<AppConfig> {
  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final selectedConfig = ref.watch(configScreenConfig)!;
    final showInfo = ref.watch(configScreenShowInfo);

    final appList = selectedDevice!.info?.appList ?? [];

    appList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return PgSectionCard(
      label: 'Start app',
      labelTrail: IconButton.ghost(
        onPressed: () {},
        icon: Icon(Icons.refresh),
      ),
      children: [
        PgSubtitle(
          subtitle: '',
          showSubtitle: showInfo,
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: Select(
                  filled: true,
                  value: selectedConfig.appOptions?.selectedApp,
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
              if (selectedConfig.appOptions?.selectedApp != null)
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
          onPressed: selectedConfig.appOptions?.selectedApp != null
              ? () => _onForceCloseCheck()
              : null,
          title: 'Force close app before starting',
          childExpand: false,
          child: Checkbox(
            state: selectedConfig.appOptions?.forceClose ?? false
                ? CheckboxState.checked
                : CheckboxState.unchecked,
            onChanged: selectedConfig.appOptions?.selectedApp != null
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
    currentAppOption ??= SAppOptions(
      forceClose: false,
      selectedApp: null,
    );

    ref
        .read(configScreenConfig.notifier)
        .setAppConfig(forceClose: !currentAppOption.forceClose);
  }
}
