import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/companion_server/server_state.dart';

class ServerStateNotifier extends StateNotifier<ServerState> {
  ServerStateNotifier() : super(defaultState);

  void setServerState(
      {bool? isRunning, String? ip, String? port, List<Socket>? clients}) {
    state = state.copyWith(
      isRunning: isRunning ?? state.isRunning,
      ip: ip ?? state.ip,
      port: port ?? state.port,
      clients: clients ?? state.clients,
    );
  }
}

final companionServerStateProvider =
    StateNotifierProvider<ServerStateNotifier, ServerState>((ref) {
  return ServerStateNotifier();
});
