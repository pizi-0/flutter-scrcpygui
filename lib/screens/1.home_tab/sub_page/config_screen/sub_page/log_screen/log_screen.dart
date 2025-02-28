import 'dart:async';
import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/utils/scrcpy_command.dart';

import '../../../../../../providers/config_provider.dart';

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
    final selectedConfig = ref.watch(configScreenConfig);
    final selectedDevice = ref.watch(selectedDeviceProvider);

    return NavigationView(
      appBar: NavigationAppBar(
        title: Text(el.logScreen.title),
        actions: IconButton(
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FluentIcons.info),
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => ContentDialog(
                title: Text(el.logScreen.dialog.title),
                content: Text(
                    'scrcpy ${ScrcpyCommand.buildCommand(ref, selectedConfig!, selectedDevice!, customName: '[TEST] ${selectedConfig.configName}').join(' ')}'),
                actions: [
                  Button(
                    child: Text(el.buttonLabel.close),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      content: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: logs.map((l) => Text(l)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
