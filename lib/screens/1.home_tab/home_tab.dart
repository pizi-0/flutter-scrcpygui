import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/device_tile.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../utils/const.dart';
import 'widgets/home/widgets/config_list.dart';

class HomeTab extends ConsumerWidget {
  static const route = '/home';
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return ResponsiveBuilder(
      builder: (context, size) {
        return PgScaffoldCustom(
          title: Text(el.homeLoc.title).xLarge.bold.underline,
          scaffoldBody: ResponsiveBuilder(
            builder: (context, sizingInfo) {
              double sidebarWidth = 52;

              if (sizingInfo.isTablet || sizingInfo.isDesktop) {
                sidebarWidth = AppUtils.findSidebarWidth();
              }

              if (sizingInfo.isMobile) {
                sidebarWidth = 52;
              }
              bool wrapped = sizingInfo.screenSize.width >=
                  ((appWidth * 2) + sidebarWidth + 40);

              if (!wrapped) {
                return HomeSmall();
              } else {
                return HomeBig();
              }
            },
          ),
        );
      },
    );
  }
}

class HomeSmall extends ConsumerWidget {
  const HomeSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 8,
      children: [Expanded(child: ConnectedDevices()), ConfigListSmall()],
    );
  }
}

class HomeBig extends ConsumerWidget {
  const HomeBig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        ConnectedDevices(),
        ConfigListBig(),
      ],
    );
  }
}

class ConnectedDevices extends ConsumerWidget {
  const ConnectedDevices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(adbProvider);

    return PgSectionCardNoScroll(
      cardPadding: const EdgeInsets.all(8),
      expandContent: true,
      label: el.homeLoc.devices.label(count: '${connected.length}'),
      content: CustomScrollView(
        slivers: [
          if (connected.isEmpty)
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text('Connect your devices to get started').muted.small,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Icon(BootstrapIcons.usbPlug).iconMutedForeground(),
                      Text('/'),
                      Icon(BootstrapIcons.wifi).iconMutedForeground(),
                    ],
                  ),
                ],
              ),
            ),
          SliverList.separated(
            itemCount: connected.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(),
            ),
            itemBuilder: (context, index) {
              final device = connected[index];
              return DeviceTile(device: device);
            },
          )
        ],
      ),
    );
  }
}
