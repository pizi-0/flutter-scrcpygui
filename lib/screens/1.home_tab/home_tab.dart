import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/device_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';

import 'widgets/home/widgets/config_list.dart';

class HomeTab extends ConsumerStatefulWidget {
  static const route = '/home';
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final connected = ref.watch(adbProvider);

    return ResponsiveBuilder(
      builder: (context, size) {
        return PgScaffold(
          wrap: size.isDesktop,
          title: el.homeLoc.title,
          shouldScroll: size.isDesktop || size.isTablet,
          children: [
            if (size.isMobile)
              Expanded(
                child: PgSectionCard(
                  cardPadding: EdgeInsets.all(8),
                  borderColor: theme.colorScheme.primary,
                  label: el.homeLoc.devices.label(count: '${connected.length}'),
                  childSpacing: 4,
                  children: connected
                      .mapIndexed(
                        (index, conn) => Column(
                          spacing: 4,
                          children: [
                            DeviceTile(device: conn),
                            if (index != connected.length - 1)
                              FDivider(
                                style: theme.dividerStyles.horizontalStyle
                                    .copyWith(padding: EdgeInsets.zero),
                              )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            if (!size.isMobile)
              PgSectionCard(
                cardPadding: EdgeInsets.all(8),
                borderColor: theme.colorScheme.primary,
                label: el.homeLoc.devices.label(count: '${connected.length}'),
                childSpacing: 4,
                children: connected
                    .mapIndexed(
                      (index, conn) => Column(
                        spacing: 4,
                        children: [
                          DeviceTile(device: conn),
                          if (index != connected.length - 1)
                            FDivider(
                              style: theme.dividerStyles.horizontalStyle
                                  .copyWith(padding: EdgeInsets.zero),
                            )
                        ],
                      ),
                    )
                    .toList(),
              ),
            if (size.isMobile)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ConfigListSmall(),
              ),
            if (size.isDesktop || size.isTablet) const ConfigListBig(),
          ],
        );
      },
    );
  }
}
