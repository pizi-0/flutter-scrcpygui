import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScrcpyInstanceLogs {
  final String pid;
  final List<String> logs;

  ScrcpyInstanceLogs({required this.pid, required this.logs});

  ScrcpyInstanceLogs copyWith({
    String? pid,
    List<String>? logs,
  }) {
    return ScrcpyInstanceLogs(
      pid: pid ?? this.pid,
      logs: logs ?? this.logs,
    );
  }

  @override
  bool operator ==(covariant ScrcpyInstanceLogs other) {
    if (identical(this, other)) return true;

    return other.pid == pid && listEquals(other.logs, logs);
  }

  @override
  int get hashCode => pid.hashCode ^ logs.hashCode;

  @override
  String toString() => 'ScrcpyInstanceLogs(pid: $pid, logs: $logs)';
}
