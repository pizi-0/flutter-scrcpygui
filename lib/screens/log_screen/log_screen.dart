import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';

import '../../providers/theme_provider.dart';

class LogScreen extends ConsumerStatefulWidget {
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
    final settings = ref.watch(appThemeProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context)
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
            title: Text('PID: ${widget.instance.scrcpyPID}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(settings.widgetRadius),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    )),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: logs.map((l) => Text(l)).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
