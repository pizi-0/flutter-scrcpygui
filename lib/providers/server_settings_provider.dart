import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/companion_server/authenticated_client.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:uuid/uuid.dart';

import '../models/settings_model/companion_server_settings.dart';

class CompanionServerNotifier extends Notifier<CompanionServerSettings> {
  @override
  build() {
    return defaultCompanionServerSettings.copyWith(secret: Uuid().v4());
  }

  void setSettings(CompanionServerSettings settings) {
    state = settings;
  }

  void setServerName(String name) {
    state = state.copyWith(name: name);
  }

  void setSecret(String secret) {
    state = state.copyWith(secret: secret);
  }

  void setEndpoint(String endpoint) {
    state = state.copyWith(endpoint: endpoint);
  }

  void setPort(String port) {
    state = state.copyWith(port: port);
  }

  void setStartOnLaunch() {
    final current = state.startOnLaunch;
    state = state.copyWith(startOnLaunch: !current);
  }

  void addToBlocklist(BlockedClient client) {
    final current = state.blocklist;
    state = state
        .copyWith(blocklist: [...current.where((c) => c != client), client]);
  }

  void removeFromBlocklist(BlockedClient client) {
    final current = state.blocklist;
    state = state.copyWith(blocklist: [...current.where((c) => c != client)]);
  }
}

final companionServerProvider =
    NotifierProvider<CompanionServerNotifier, CompanionServerSettings>(
        () => CompanionServerNotifier());
