import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';

import '../models/settings_model/companion_server_settings.dart';

class CompanionServerNotifier extends Notifier<CompanionServerSettings> {
  @override
  build() {
    return defaultCompanionServerSettings;
  }

  setSettings(CompanionServerSettings settings) {
    state = settings;
  }

  setServerName(String name) {
    state = state.copyWith(name: name);
  }

  setSecret(String secret) {
    state = state.copyWith(secret: secret);
  }

  setEndpoint(String endpoint) {
    state = state.copyWith(endpoint: endpoint);
  }

  setPort(String port) {
    state = state.copyWith(port: port);
  }

  setStartOnLaunch() {
    final current = state.startOnLaunch;
    state = state.copyWith(startOnLaunch: !current);
  }
}

final companionServerProvider =
    NotifierProvider<CompanionServerNotifier, CompanionServerSettings>(
        () => CompanionServerNotifier());
