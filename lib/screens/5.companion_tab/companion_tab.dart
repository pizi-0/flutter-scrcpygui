// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/server_utils_ws.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'widgets/client_list.dart';
import 'widgets/server_settings.dart';

class CompanionTab extends ConsumerStatefulWidget {
  static const route = '/companion';
  const CompanionTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanionTabState();
}

class _CompanionTabState extends ConsumerState<CompanionTab> {
  final serverUtils = ServerUtilsWs();

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider.select((s) => s.behaviour.languageCode));

    return PgScaffoldCustom(
      title: Text(el.companionLoc.title).xLarge().bold(),
      scaffoldBody: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          return AnimatedSwitcher(
            duration: 200.milliseconds,
            child: sizeInfo.isMobile || sizeInfo.isTablet
                ? CompanionTabSmall()
                : CompanionTabBig(),
          );
        },
      ),
    );
  }
}

class CompanionTabSmall extends StatelessWidget {
  const CompanionTabSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Gap(6),
            Column(
              spacing: 8,
              children: [
                ServerSettings(),
                ClientList(),
              ],
            ),
            Gap(8)
          ],
        ),
      ),
    );
  }
}

class CompanionTabBig extends StatelessWidget {
  const CompanionTabBig({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        LeftColumn(
          child: ServerSettings(
            expandContent: true,
          ),
        ),
        RightColumn(
            child: ClientList(
          expandContent: true,
        )),
      ],
    );
  }
}
