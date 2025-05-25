import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/models/app_config_pair.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/app_config_pair_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/device_control_page.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_control/widgets/control_buttons.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../models/adb_devices.dart';
import '../../../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../../../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import '../../../../../providers/config_provider.dart';
import '../../../../../utils/const.dart';
import '../../../../../widgets/custom_ui/pg_list_tile.dart';

final FocusNode searchBoxFocusNode = FocusNode();

class BigControlPage2 extends ConsumerStatefulWidget {
  final AdbDevices device;
  const BigControlPage2({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BigControlPage2State();
}

class _BigControlPage2State extends ConsumerState<BigControlPage2> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(
      adbProvider,
      (previous, next) {
        if (!next.contains(widget.device)) {
          context.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;

    return Column(
      spacing: 10,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              ControlButtons(device: device),
              DeviceRunningInstances(device: device),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
          child: Divider(),
        ),
        Expanded(
          child: AppGrid(device: device),
        ),
      ],
    );
  }
}

class DeviceRunningInstances extends ConsumerWidget {
  final AdbDevices device;
  const DeviceRunningInstances({required this.device, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInstance = ref
        .watch(scrcpyInstanceProvider)
        .where((i) => i.device == device)
        .toList();

    return PgSectionCardNoScroll(
      label: 'Running instances',
      content: PgListTile(
        title: '${deviceInstance.length} instance(s)',
        trailing: PrimaryButton(
          onPressed: () async {
            await openSheet(
              context: context,
              position: OverlayPosition.right,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InstanceList(device: device),
                );
              },
            );
            controlPageKeyboardListenerNode.requestFocus();
          },
          child: Text('Manage'),
        ),
      ),
    );
  }
}

class InstanceList extends ConsumerStatefulWidget {
  const InstanceList({super.key, required this.device});

  final AdbDevices device;

  @override
  ConsumerState<InstanceList> createState() => _InstanceListState();
}

class _InstanceListState extends ConsumerState<InstanceList> {
  @override
  Widget build(BuildContext context) {
    final deviceInstance = ref
        .watch(scrcpyInstanceProvider)
        .where((i) => i.device == widget.device)
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: appWidth * 0.8),
      child: Column(
        children: [
          if (deviceInstance.isNotEmpty) ...[
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(8),
                separatorBuilder: (context, index) => Divider(),
                itemCount: deviceInstance.length,
                itemBuilder: (context, index) {
                  final instance = deviceInstance[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InstanceListTile(instance: instance),
                  );
                },
              ),
            )
          ] else ...[
            Expanded(
              child: Center(child: Text('No instances').textSmall.muted),
            )
          ],
          InstanceListBottomBar(deviceInstance: deviceInstance),
        ],
      ),
    );
  }
}

class InstanceListTile extends StatefulWidget {
  const InstanceListTile({
    super.key,
    required this.instance,
  });

  final ScrcpyRunningInstance instance;

  @override
  State<InstanceListTile> createState() => _InstanceListTileState();
}

class _InstanceListTileState extends State<InstanceListTile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return PgListTile(
      title: widget.instance.instanceName,
      trailing: IconButton.destructive(
          enabled: !loading,
          onPressed: loading
              ? null
              : () async {
                  loading = true;
                  setState(() {});
                  try {
                    await ScrcpyUtils.killServer(widget.instance);
                    await Future.delayed(300.milliseconds);
                  } catch (e) {
                    debugPrint(e.toString());
                  } finally {
                    if (mounted) {
                      loading = false;
                      setState(() {});
                    }
                  }
                },
          icon: Icon(Icons.stop_rounded)),
    );
  }
}

class InstanceListBottomBar extends StatefulWidget {
  const InstanceListBottomBar({
    super.key,
    required this.deviceInstance,
  });

  final List<ScrcpyRunningInstance> deviceInstance;

  @override
  State<InstanceListBottomBar> createState() => _InstanceListBottomBarState();
}

class _InstanceListBottomBarState extends State<InstanceListBottomBar> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 8,
        children: [
          Expanded(
            child: DestructiveButton(
              enabled: widget.deviceInstance.isNotEmpty && !loading,
              onPressed: loading
                  ? null
                  : () async {
                      loading = true;
                      setState(() {});
                      try {
                        List<Future> future = [];
                        for (final instance in widget.deviceInstance) {
                          future.add(ScrcpyUtils.killServer(instance));
                        }
                        future.add(Future.delayed(300.milliseconds));
                        await Future.wait(future);
                      } catch (e) {
                        debugPrint(e.toString());
                      } finally {
                        if (mounted) {
                          loading = false;
                          setState(() {});
                        }
                      }
                    },
              child: Text('Stop all'),
            ),
          ),
          Expanded(
            child: SecondaryButton(
              onPressed: () => closeDrawer(context),
              child: Text('Close'),
            ),
          )
        ],
      ),
    );
  }
}

class AppGrid extends ConsumerStatefulWidget {
  final AdbDevices device;
  const AppGrid({super.key, required this.device});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppGridState();
}

class _AppGridState extends ConsumerState<AppGrid> {
  TextEditingController appSearchController = TextEditingController();
  ScrollController appScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final allConfigs = ref.watch(configsProvider);
    final config = ref.watch(controlPageConfigProvider);

    final devicePairs = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == device.id)
        .toList();

    final appsList = (device.info?.appList ?? [])
        .where((app) => devicePairs.where((dp) => dp.app == app).isEmpty)
        .toList();

    appsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    devicePairs.sort(
        (a, b) => a.app.name.toLowerCase().compareTo(b.app.name.toLowerCase()));

    final finalList = [...devicePairs.map((p) => p.app), ...appsList];

    final filteredList = finalList
        .where((app) => app.name
            .toLowerCase()
            .contains(appSearchController.text.toLowerCase()))
        .toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: (appWidth * 2) + 10),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Text('All apps ').textSmall,
              Spacer(),
              SizedBox(height: 20, child: VerticalDivider()),
              Text('Config:').textSmall,
              SizedBox(
                width: 250,
                height: 20,
                child: Select<ScrcpyConfig>(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
                  filled: true,
                  placeholder: Text('Select config'),
                  value: config,
                  onChanged: (value) {
                    ref.read(controlPageConfigProvider.notifier).state = value;
                  },
                  popup: SelectPopup(
                    items: SelectItemList(
                        children: allConfigs
                            .map((c) => SelectItemButton(
                                value: c,
                                child: OverflowMarquee(
                                    duration: 3.seconds,
                                    delayDuration: 0.5.seconds,
                                    child: Text(c.configName))))
                            .toList()),
                  ).call,
                  itemBuilder: (context, value) => Text(value.configName),
                ),
              ),
              SizedBox(height: 20, child: VerticalDivider()),
              Text('Search:').textSmall,
              SizedBox(
                width: 250,
                height: 20,
                child: TextField(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  filled: true,
                  placeholder: Text("Press '/' to search"),
                  focusNode: searchBoxFocusNode,
                  controller: appSearchController,
                  onChanged: (value) => setState(() {}),
                  features: [
                    InputFeature.trailing(IconButton(
                        variance: ButtonVariance.link,
                        onPressed: () {
                          appSearchController.clear();
                          controlPageKeyboardListenerNode.requestFocus();

                          setState(() {});
                        },
                        density: ButtonDensity.compact,
                        icon: Icon(Icons.close_rounded)))
                  ],
                  onSubmitted: (value) {
                    controlPageKeyboardListenerNode.requestFocus();
                  },
                ),
              )
            ],
          ).paddingVertical(8),
          Expanded(
            child: Scrollbar(
              controller: appScrollController,
              child: Card(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: CustomScrollView(
                    controller: appScrollController,
                    slivers: [
                      if (filteredList.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                              child: Text('No apps found').textSmall.muted),
                        ),
                      if (filteredList.isNotEmpty)
                        SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            mainAxisExtent: 40,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final app = filteredList[index];

                            return AppGridTile(
                                ref: ref, app: app, device: widget.device);
                          },
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppGridTile extends ConsumerStatefulWidget {
  const AppGridTile({
    super.key,
    required this.ref,
    required this.device,
    required this.app,
  });

  final WidgetRef ref;
  final AdbDevices device;
  final ScrcpyApp app;

  @override
  ConsumerState<AppGridTile> createState() => _AppGridTileState();
}

class _AppGridTileState extends ConsumerState<AppGridTile> {
  bool loading = false;
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = ref.watch(controlPageConfigProvider);
    final allConfigs = ref.watch(configsProvider);
    final devicePair = ref
        .watch(appConfigPairProvider)
        .where((p) => p.deviceId == widget.device.id)
        .toList();

    final isPinned = devicePair.where((p) => p.app == widget.app).isNotEmpty;

    final configForPinned =
        devicePair.firstWhereOrNull((p) => p.app == widget.app)?.config;

    final isMissingConfig = isPinned &&
        allConfigs.where((c) => c.id == configForPinned?.id).isEmpty;

    return Tooltip(
      tooltip: TooltipContainer(
          child: Text(
        isMissingConfig
            ? 'Missing config: ${configForPinned?.configName}'
            : isPinned
                ? 'On: ${configForPinned?.configName}'
                : widget.app.packageName,
        textAlign: TextAlign.center,
      )).call,
      child: ContextMenu(
        items: [
          if (config == null && !isPinned) ...[
            MenuLabel(
                leading: Icon(
                  Icons.warning_rounded,
                  color: theme.colorScheme.destructive,
                ),
                child: Text('Select a config first')),
            MenuDivider(),
          ],
          if (!isPinned)
            MenuButton(
              enabled: config != null,
              onPressed: (context) async {
                controlPageKeyboardListenerNode.requestFocus();
                ref.read(appConfigPairProvider.notifier).addOrEditPair(
                    AppConfigPair(
                        deviceId: widget.device.id,
                        app: widget.app,
                        config: config!));

                await Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
              },
              leading: Icon(Icons.push_pin_rounded),
              child: Text('Pin on ${config?.configName ?? 'config'}'),
            ),
          if (isPinned)
            MenuButton(
              enabled: config != null || isPinned,
              onPressed: (context) async {
                controlPageKeyboardListenerNode.requestFocus();
                final config = devicePair
                    .firstWhereOrNull((p) => p.app == widget.app)
                    ?.config;

                ref.read(appConfigPairProvider.notifier).removePair(
                    AppConfigPair(
                        deviceId: widget.device.id,
                        app: widget.app,
                        config: config!));

                await Db.saveAppConfigPairs(ref.read(appConfigPairProvider));
              },
              leading: Icon(Icons.push_pin_rounded),
              child: Text('Unpin'),
            ),
          MenuDivider(),
          MenuButton(
            enabled:
                enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
            onPressed: (context) =>
                _startScrcpy(isPinned: isPinned, devicePair: devicePair),
            leading: Icon(Icons.play_arrow_rounded),
            child: Text('Force close & start'),
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            Button(
              onHover: (value) {
                hover = value;
                setState(() {});
              },
              style: isPinned ? ButtonStyle.secondary() : ButtonStyle.outline(),
              enabled:
                  enabled(isMissingConfig: isMissingConfig, isPinned: isPinned),
              onPressed: () =>
                  _startScrcpy(isPinned: isPinned, devicePair: devicePair),
              child: hover
                  ? OverflowMarquee(
                      duration: 2.seconds,
                      delayDuration: 0.5.seconds,
                      child: Text(
                        widget.app.name,
                      ).textAlignment(TextAlign.center),
                    )
                  : Text(
                      widget.app.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ).textAlignment(TextAlign.center),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                isPinned
                    ? isMissingConfig
                        ? Icons.warning_rounded
                        : Icons.push_pin_rounded
                    : Icons.more_vert_rounded,
                color: isMissingConfig ? theme.colorScheme.destructive : null,
              ).iconXSmall().paddingOnly(right: 4),
            ),
            if (loading)
              Positioned.fill(
                  child: Container(
                color: theme.colorScheme.background.withAlpha(200),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ))
          ],
        ),
      ),
    );
  }

  bool enabled({required bool isMissingConfig, required bool isPinned}) {
    final config = ref.watch(controlPageConfigProvider);

    if (isMissingConfig || loading || (!isPinned && config == null)) {
      return false;
    } else {
      return true;
    }
  }

  _startScrcpy(
      {required bool isPinned, required List<AppConfigPair> devicePair}) async {
    final config = ref.watch(controlPageConfigProvider);

    loading = true;
    setState(() {});

    controlPageKeyboardListenerNode.requestFocus();
    final selectedConfig = isPinned
        ? devicePair.firstWhere((p) => p.app == widget.app).config
        : config;

    await ScrcpyUtils.newInstance(
      widget.ref,
      selectedConfig: selectedConfig!.copyWith(
          appOptions: selectedConfig.appOptions
              .copyWith(selectedApp: widget.app, forceClose: true)),
      selectedDevice: widget.device,
      customInstanceName: '${widget.app.name} (${selectedConfig.configName})',
    );

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }
}

class AppListTile extends StatefulWidget {
  final ScrcpyApp app;
  final ScrcpyConfig? config;

  const AppListTile({
    super.key,
    required this.app,
    required this.config,
  });

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final config = widget.config;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PgListTile(
        title: app.name,
        subtitle: app.packageName,
        showSubtitle: true,
        trailing: Row(
          children: [
            IconButton.ghost(
                icon: Icon(Icons.push_pin_rounded),
                onPressed: config == null ? null : () {}),
            IconButton.ghost(
                icon: Icon(Icons.play_arrow_rounded),
                onPressed: config == null ? null : () {}),
          ],
        ),
      ),
    );
  }
}
