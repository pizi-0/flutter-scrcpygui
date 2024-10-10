import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/utils/const.dart';

class ConfigsNotifier extends Notifier<List<ScrcpyConfig>> {
  @override
  List<ScrcpyConfig> build() {
    return [...defaultConfigs];
  }

  addConfig(ScrcpyConfig config) {
    state = [...state, config];
  }

  removeConfig(ScrcpyConfig config) {
    state = [...state.where((c) => c != config)];
  }

  overwriteConfig(ScrcpyConfig oldConfig, ScrcpyConfig newConfig) {
    final newState = state;

    final index = newState.indexOf(oldConfig);

    newState.removeAt(index);
    newState.insert(index, newConfig);

    state = [...newState];
  }
}

final configsProvider = NotifierProvider<ConfigsNotifier, List<ScrcpyConfig>>(
    () => ConfigsNotifier());

final selectedConfigProvider =
    StateProvider<ScrcpyConfig>((ref) => defaultConfigs[1]);

final configToEditProvider = StateProvider<ScrcpyConfig?>((ref) => null);
