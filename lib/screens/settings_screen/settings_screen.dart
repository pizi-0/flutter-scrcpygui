// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/theme_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context),
      },
      child: ScaffoldPage.scrollable(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        header: const PageHeader(
          title: Text('Settings'),
        ),
        children: const [
          ThemeSection(),
        ],
      ),
    );
  }
}
