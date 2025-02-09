import 'package:awesome_extensions/awesome_extensions.dart'
    show NumExtension, StyledText;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/utils/adb/adb_utils.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/const.dart';
import '../config_list_view.dart';
import '../connected_devices_view.dart';

final homeDeviceAttention = StateProvider((ref) => false);

class HomeTabSmall extends ConsumerStatefulWidget {
  const HomeTabSmall({super.key});

  @override
  ConsumerState<HomeTabSmall> createState() => _HomeTabSmallState();
}

class _HomeTabSmallState extends ConsumerState<HomeTabSmall>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  int deviceFlex = 300;
  int configFlex = 200;

  bool configAutoExpand = false;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: 200.milliseconds,
        reverseDuration: 200.milliseconds,
        vsync: this);
    _animation = IntTween(begin: 200, end: 750).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: appWidth,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: deviceFlex,
                    child: ConnectedDevicesView(
                      animation: _animation,
                      animationController: _animationController,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: _animation.value,
                    child: ConfigListView(
                      animation: _animation,
                      animationController: _animationController,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeSmall extends ConsumerWidget {
  const HomeSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FluentTheme.of(context);
    final connected = ref.watch(adbProvider);

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.all(0),
      content: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connected devices (${connected.length})')
              .textStyle(theme.typography.body)
              .fontWeight(FontWeight.w600),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: connected.length,
              itemBuilder: (context, index) {
                final dev = connected[index];
                return DeviceTile(device: dev, key: ValueKey(dev.id));
              },
            ),
          )
        ],
      ),
      bottomBar: const HomeBottomBar(),
    );
  }
}

class DeviceTile extends ConsumerStatefulWidget {
  const DeviceTile({
    super.key,
    required this.device,
  });

  final AdbDevices device;

  @override
  ConsumerState<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends ConsumerState<DeviceTile> {
  final contextMenuController = FlyoutController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    final selectedDevice = ref.watch(selectedDeviceProvider);
    final runningInstances = ref.watch(scrcpyInstanceProvider);
    final deviceInstance =
        runningInstances.where((i) => i.device.id == widget.device.id).toList();

    final isSelected = selectedDevice == widget.device;
    final hasRunningInstance = deviceInstance.isNotEmpty;
    final isWireless = widget.device.id.isIpv4 ||
        widget.device.id.isIpv6 ||
        widget.device.id.contains(adbMdns);

    return FlyoutTarget(
      controller: contextMenuController,
      child: Card(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.only(bottom: 4),
        child: SizedBox(
          height: 60,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onSecondaryTapUp: (details) => _showContextMenu(
                    details, hasRunningInstance, deviceInstance, isWireless),
                child: ListTile.selectable(
                  onPressed: () {
                    ref.read(selectedDeviceProvider.notifier).state =
                        widget.device;
                  },
                  tileColor: const WidgetStatePropertyAll(Colors.transparent),
                  leading: Icon(
                    widget.device.id.isIpv4 ||
                            widget.device.id.contains(adbMdns)
                        ? FluentIcons.wifi
                        : FluentIcons.usb,
                  ),
                  selected: isSelected,
                  title: Row(
                    spacing: 10,
                    children: [
                      Text(widget.device.name!),
                      if (hasRunningInstance)
                        Card(
                          backgroundColor: theme.selectionColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text('Running: ${deviceInstance.length}')
                              .fontSize(10)
                              .textColor(Colors.white),
                        ),
                    ],
                  ),
                  subtitle: Text(widget.device.id),
                  trailing: IconButton(
                    icon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(FluentIcons.settings),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/dev_settings',
                        arguments: widget.device,
                      );
                    },
                  ),
                ),
              ),
              if (loading)
                Card(
                  backgroundColor: Colors.black.withAlpha(100),
                  child: const SizedBox(),
                )
            ],
          ),
        ),
      ),
    );
  }

  _showContextMenu(TapUpDetails details, bool hasRunningInstance,
      List<ScrcpyRunningInstance> deviceInstance, bool isWireless) {
    contextMenuController.showFlyout(
      position: Offset(details.globalPosition.dx - kCompactNavigationPaneWidth,
          details.globalPosition.dy - kCompactNavigationPaneWidth),
      builder: (context) {
        return MenuFlyout(
          items: [
            if (hasRunningInstance)
              MenuFlyoutSubItem(
                text: const Text('Kill running'),
                items: (context) => deviceInstance
                    .map(
                      (i) => MenuFlyoutItem(
                          text: Text(i.instanceName),
                          onPressed: () {
                            ScrcpyUtils.killServer(i);
                          }),
                    )
                    .toList(),
              ),
            if (isWireless)
              MenuFlyoutItem(
                  text: const Text('Disconnect'),
                  onPressed: () async {
                    loading = true;
                    setState(() {});

                    try {
                      final workDir = ref.read(execDirProvider);

                      await AdbUtils.disconnectWirelessDevice(
                          workDir, widget.device);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }

                    if (mounted) {
                      loading = false;
                      setState(() {});
                    }
                  }),
            if (!isWireless)
              MenuFlyoutItem(
                text: const Text('To wireless'),
                onPressed: () async {
                  loading = true;
                  setState(() {});

                  final workDir = ref.read(execDirProvider);

                  try {
                    final ip =
                        await AdbUtils.getIpForUSB(workDir, widget.device);

                    await AdbUtils.tcpip5555(workDir, widget.device.id);

                    await AdbUtils.connectWithIp(ref, ipport: '$ip:5555');
                  } on Exception catch (e) {
                    debugPrint(e.toString());
                  }

                  if (mounted) {
                    loading = false;
                    setState(() {});
                  }
                },
              ),
          ],
        );
      },
    );
  }
}

class HomeBottomBar extends ConsumerStatefulWidget {
  const HomeBottomBar({super.key});

  @override
  ConsumerState<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends ConsumerState<HomeBottomBar> {
  ScrcpyConfig? selectedConfig;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final allconfigs = ref.watch(configsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          children: [
            const Text('Start scrcpy')
                .textStyle(theme.typography.body)
                .fontWeight(FontWeight.w600),
            const Spacer(),
            HyperlinkButton(
              child: const Text('New config'),
              onPressed: () {
                final selectedDevice = ref.read(selectedDeviceProvider);
                if (selectedDevice != null) {
                  final newconfig = newConfig.copyWith(id: const Uuid().v4());
                  ref.read(configScreenConfig.notifier).state = newconfig;
                  Navigator.pushNamed(context, '/create_config');
                } else {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => ContentDialog(
                      title: const Text('Device'),
                      content: const Text(
                          'No device selected.\nSelect a device to create scrcpy config.'),
                      actions: [
                        Button(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
        Card(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: ComboBox(
                  isExpanded: true,
                  placeholder: const Text('Select a config'),
                  value: selectedConfig,
                  onChanged: (value) {
                    selectedConfig = value;
                    setState(() {});
                  },
                  items: allconfigs
                      .map((c) => ComboBoxItem(
                            value: c,
                            child: Row(
                              children: [
                                Text(c.configName),
                                const Spacer(),
                                if (c.isRecording)
                                  IconButton(
                                    icon: const Icon(
                                        FluentIcons.open_folder_horizontal),
                                    onPressed: () =>
                                        AppUtils.openFolder(c.savePath!),
                                  )
                              ],
                            ),
                          ))
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
                      : const Text('Start'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _start() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    if (selectedConfig == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ContentDialog(
          title: const Text('Config'),
          content: const Text(
              'No config selected.\nSelect a scrcpy config to start.'),
          actions: [
            Button(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } else {
      if (selectedDevice == null) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => ContentDialog(
            title: const Text('Device'),
            content: const Text(
                'No device selected.\nSelect a device to start scrcpy.'),
            actions: [
              Button(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      } else {
        loading = true;
        setState(() {});
        await ScrcpyUtils.newInstance(ref, selectedConfig: selectedConfig!);

        if (mounted) {
          loading = false;
          setState(() {});
        }
      }
    }
  }
}
