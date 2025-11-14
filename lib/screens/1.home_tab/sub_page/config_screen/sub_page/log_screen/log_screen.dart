import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../../../providers/settings_provider.dart';

class LogScreen extends ConsumerStatefulWidget {
  static const route = 'config-settings/config-log/:instance';
  final ScrcpyRunningInstance instance;
  const LogScreen({super.key, required this.instance});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  StreamSubscription? stdout;
  StreamSubscription? stderr;

  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    stdout ??= widget.instance.process.stdout
        .transform(const Utf8Decoder())
        .listen((a) => setState(() => logs.add(a)));

    stderr ??= widget.instance.process.stderr
        .transform(const Utf8Decoder())
        .listen((a) => setState(() => logs.add(a)));
  }

  @override
  void dispose() {
    stdout?.cancel();
    stderr?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return PgScaffold(
      title: el.logScreenLoc.title,
      wrap: false,
      onBack: () => context.pop(),
      children: [
        PgSectionCard(
          constraints: BoxConstraints(maxWidth: width),
          children: logs
              .map((l) => Text(
                    l.trim(),
                    style: theme.typography.small,
                  ))
              .toList(),
        )
      ],
    );
  }
}
