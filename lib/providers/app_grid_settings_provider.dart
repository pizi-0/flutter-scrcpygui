import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_grid_settings.dart';

class AppGridSettingsNotifier extends StateNotifier<AppGridSettings> {
  AppGridSettingsNotifier(super.state) {
    super.state = AppGridSettings(gridExtent: 80, hideName: false);
  }

  setSettings(AppGridSettings settings) {
    state = settings;
  }

  modifyExtent(double extent) {
    state = state.copyWith(gridExtent: extent);
  }

  toggleHideName() {
    state = state.copyWith(hideName: !state.hideName);
  }

  setLastUsedConfig(String? configId) {
    if (configId != null) {
      state = state.copyWith(lastUsedConfig: configId);
    }
  }
}

final appGridSettingsProvider =
    StateNotifierProvider<AppGridSettingsNotifier, AppGridSettings>(
  (ref) =>
      AppGridSettingsNotifier(AppGridSettings(gridExtent: 80, hideName: false)),
);
