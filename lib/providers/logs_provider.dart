import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_instance_logs.dart';

class LogsNotifier extends Notifier<List<ScrcpyInstanceLogs>> {
  @override
  build() {
    return [];
  }

  log(ScrcpyInstanceLogs log) {
    state.removeWhere((e) => e.pid == log.pid);
    state = [...state, log];
  }
}

final scrcpyInstanceLogsProvider =
    NotifierProvider<LogsNotifier, List<ScrcpyInstanceLogs>>(
        () => LogsNotifier());
