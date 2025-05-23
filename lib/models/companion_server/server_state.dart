// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:scrcpygui/models/companion_server/authenticated_client.dart';

class ServerState {
  final bool isRunning;
  final String ip;
  final String port;
  final List<AuthdClient> clients;

  ServerState(
      {required this.isRunning,
      required this.ip,
      required this.port,
      required this.clients});

  ServerState copyWith({
    bool? isRunning,
    String? ip,
    String? port,
    List<AuthdClient>? clients,
  }) {
    return ServerState(
      isRunning: isRunning ?? this.isRunning,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      clients: clients ?? this.clients,
    );
  }
}

final defaultState =
    ServerState(isRunning: false, ip: "", port: "", clients: []);
