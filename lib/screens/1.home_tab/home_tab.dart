import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/device_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'widgets/home/widgets/config_list.dart';

class HomeTab extends ConsumerWidget {
  static const route = '/home';
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final connected = ref.watch(adbProvider);

    return ResponsiveBuilder(
      builder: (context, size) {
        return PgScaffold(
          title: el.homeLoc.title,
          footers: [
            if (size.isMobile || size.isTablet)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ConfigListSmall(),
              )
          ],
          children: [
            PgSectionCard(
              cardPadding: const EdgeInsets.all(8),
              // borderColor: Colors.transparent,
              label: el.homeLoc.devices.label(count: '${connected.length}'),
              children: connected.isEmpty
                  ? [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('Connect your devices to get started')
                                        .muted
                                        .small,
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Icon(BootstrapIcons.usbPlug)
                                      .iconMutedForeground(),
                                  Text('/'),
                                  Icon(BootstrapIcons.wifi)
                                      .iconMutedForeground(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]
                  : connected
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
            if (size.isDesktop) const ConfigListBig(),
          ],
        );
      },
    );
  }
}
