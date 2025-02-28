// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/4.settings_tab/widgets/behaviour_section.dart';

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
    return ScaffoldPage.scrollable(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: PageHeader(title: Text(el.settings.title)),
      ),
      children: const [
        ThemeSection(),
        BehaviourSection(),
      ],
    );
  }
}
