import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/widgets/device_tile.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'widgets/home/widgets/config_list.dart';

class HomeTab extends ConsumerStatefulWidget {
  static const route = '/home';
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();

    _handleControlPageConfigOnConfigsProviderChange();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return ResponsiveBuilder(
      builder: (context, size) {
        return PgScaffoldCustom(
          title: Text(el.homeLoc.title).xLarge().bold(),
          scaffoldBody: ResponsiveBuilder(
            builder: (context, sizingInfo) {
              return AnimatedSwitcher(
                duration: 200.milliseconds,
                child: sizingInfo.isMobile || sizingInfo.isTablet
                    ? HomeSmall()
                    : HomeBig(),
              );
            },
          ),
        );
      },
    );
  }

  void _handleControlPageConfigOnConfigsProviderChange() {
    ref.listenManual(
      configsProvider,
      (previous, next) {
        final controlPageConfig = ref.read(controlPageConfigProvider);
        if (controlPageConfig != null) {
          final config = next.firstWhereOrNull(
              (element) => element.id == controlPageConfig.id);

          if (config != null) {
            ref.read(controlPageConfigProvider.notifier).state = config;
          } else {
            ref.read(controlPageConfigProvider.notifier).state = null;
          }
        }
      },
    );
  }
}

class HomeSmall extends ConsumerWidget {
  const HomeSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Gap(6),
        Expanded(
          child: Column(
            spacing: 8,
            children: [
              Expanded(child: ConnectedDevices()),
              ConfigListSmall(),
            ],
          ),
        ),
        Gap(8),
      ],
    );
  }
}

class HomeBig extends ConsumerWidget {
  const HomeBig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        LeftColumn(child: ConnectedDevices()),
        RightColumn(child: ConfigListBig()),
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
          SliverList.builder(
            itemCount: connected.length,
            itemBuilder: (context, index) {
              final device = connected[index];
              return Column(
                children: [
                  DeviceTile(device: device),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Divider(),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
