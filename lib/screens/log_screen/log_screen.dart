import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_instance_logs.dart';
import 'package:pg_scrcpy/providers/logs_provider.dart';

class LogScreen extends ConsumerStatefulWidget {
  final String pid;
  const LogScreen({super.key, required this.pid});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(scrcpyInstanceLogsProvider).firstWhere(
          (e) => e.pid == widget.pid,
          orElse: () => ScrcpyInstanceLogs(pid: widget.pid, logs: []),
        );

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
            title: Text('PID: ${widget.pid}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    )),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: logs.logs.map((l) => Text(l)).toList(),
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
