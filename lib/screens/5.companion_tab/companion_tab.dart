// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/server_utils_ws.dart';
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

    return PgScaffold(
      title: el.companionLoc.title,
      children: [
        ServerSettings(),
        ClientList(),
      ],
    );
  }
}
