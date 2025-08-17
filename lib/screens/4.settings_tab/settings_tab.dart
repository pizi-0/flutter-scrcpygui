// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/behaviour_section.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../providers/settings_provider.dart';
import 'widgets/theme_section.dart';

class SettingsTab extends ConsumerStatefulWidget {
  static const route = '/settings';
  const SettingsTab({super.key});

  @override
  ConsumerState<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgScaffold(
      title: el.settingsLoc.title,
      children: const [
        ThemeSection(),
        BehaviourSection(),
        Gap(0),
      ],
    );
  }
}
