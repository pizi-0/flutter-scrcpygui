import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/1.home_tab/sub_page/device_settings_screen/device_settings_state_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../db/db.dart';
import '../../../../../models/adb_devices.dart';
import '../../../../../models/device_info_model.dart';
import '../../../../../providers/adb_provider.dart';
import '../../../../../providers/device_info_provider.dart';
import '../../../../../providers/version_provider.dart';
import '../../../../../utils/adb_utils.dart';
import '../../../../../utils/const.dart';
import '../../../../../widgets/custom_ui/pg_list_tile.dart';
import '../../../../../widgets/custom_ui/pg_section_card.dart';

class InfoPane extends ConsumerStatefulWidget {
  final AdbDevices device;
  final bool expandContent;
  const InfoPane({super.key, required this.device, this.expandContent = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfoPaneState();
}

class _InfoPaneState extends ConsumerState<InfoPane> {
  @override
  Widget build(BuildContext context) {
    final dev = widget.device;
    final state = ref.watch(deviceSettingsStateProvider(dev));
    final loading = state.loading;

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    return PgSectionCardNoScroll(
      expandContent: widget.expandContent,
      cardPadding: EdgeInsets.zero,
      label: el.deviceSettingsLoc.scrcpyInfo.label,
      labelTrail: IconButton.ghost(
        density: ButtonDensity.dense,
        onPressed: _getDeviceInfo,
        icon: const Icon(Icons.refresh),
      ),
      content: widget.expandContent
          ? CustomScrollView(
              slivers: [
                if (loading || deviceInfo == null)
                  SliverFillRemaining(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _children(deviceInfo),
                      ),
                    ),
                  )
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loading || deviceInfo == null
                    ? [
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      ]
                    : _children(deviceInfo),
              ),
            ),
    );
  }

  List<Widget> _children(DeviceInfo deviceInfo) {
    final dev = widget.device;
    final theme = Theme.of(context);

    return [
      PgListTile(
          title: el.deviceSettingsLoc.scrcpyInfo
              .id(id: dev.id.replaceAll('.$adbMdns', ''))),
      // const Divider(),
      PgListTile(
          title: el.deviceSettingsLoc.scrcpyInfo.model(model: dev.modelName)),
      // const Divider(),
      PgListTile(
          title: el.deviceSettingsLoc.scrcpyInfo
              .version(version: deviceInfo.buildVersion)),
      PgListTile(
        title: el.deviceSettingsLoc.scrcpyInfo
            .displays(count: '${deviceInfo.displays.length}'),
        content: Padding(
          padding: const EdgeInsets.all(4.0),
          child: OutlinedContainer(
            backgroundColor: theme.colorScheme.accent,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: deviceInfo.displays
                  .map((d) => Text(d.toString()).li())
                  .toList(),
            ),
          ),
        ),
      ),
      PgListTile(
        title: el.deviceSettingsLoc.scrcpyInfo
            .cameras(count: '${deviceInfo.cameras.length}'),
        content: Padding(
          padding: const EdgeInsets.all(2.0),
          child: OutlinedContainer(
            backgroundColor: theme.colorScheme.accent,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: deviceInfo.cameras
                  .map((c) => Text(c.toString()).li())
                  .toList(),
            ),
          ),
        ),
      ),

      PgListTile(
        title: el.deviceSettingsLoc.scrcpyInfo
            .videoEnc(count: '${deviceInfo.videoEncoders.length}'),
        content: Padding(
          padding: const EdgeInsets.all(2.0),
          child: OutlinedContainer(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Accordion(
                  items: deviceInfo.videoEncoders
                      .map((c) => AccordionItem(
                            trigger: ComponentTheme(
                              data: AccordionTheme(padding: 8),
                              child: AccordionTrigger(
                                child: Text(c.codec).li(),
                              ),
                            ),
                            content: OutlinedContainer(
                              backgroundColor: theme.colorScheme.accent,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                spacing: 4,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: c.encoder
                                    .map((en) => Text(en).li())
                                    .toList(),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      PgListTile(
        title: el.deviceSettingsLoc.scrcpyInfo
            .audioEnc(count: '${deviceInfo.audioEncoder.length}'),
        content: Padding(
            padding: const EdgeInsets.all(2.0),
            child: OutlinedContainer(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Accordion(
                    items: deviceInfo.audioEncoder
                        .map((c) => AccordionItem(
                              trigger: ComponentTheme(
                                  data: AccordionTheme(padding: 8),
                                  child: AccordionTrigger(
                                      child: Text(c.codec).li())),
                              content: OutlinedContainer(
                                backgroundColor: theme.colorScheme.accent,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  spacing: 4,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: c.encoder
                                      .map((en) => Text(en).li())
                                      .toList(),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            )),
      ),
    ];
  }

  Future<void> _getDeviceInfo() async {
    final selectedDevice = ref.read(selectedDeviceProvider);
    final dev = widget.device;

    ref.read(deviceSettingsStateProvider(dev).notifier).toggleLoading();

    final deviceInfo = ref
        .read(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == dev.serialNo);

    final info =
        await AdbUtils.getDeviceInfoFor(ref.read(execDirProvider), dev);

    if (deviceInfo == null) {
      ref.read(infoProvider.notifier).addOrEditDeviceInfo(info);
    } else {
      final updatedInfo = info.copyWith(deviceName: deviceInfo.deviceName);
      ref.read(infoProvider.notifier).addOrEditDeviceInfo(updatedInfo);
    }

    await Db.saveDeviceInfos(ref.read(infoProvider));

    if (selectedDevice != null) {
      if (selectedDevice.id == dev.id) {
        ref.read(selectedDeviceProvider.notifier).state = dev;
      }
    }

    if (mounted) {
      ref.read(deviceSettingsStateProvider(dev).notifier).toggleLoading();
    }
  }
}
