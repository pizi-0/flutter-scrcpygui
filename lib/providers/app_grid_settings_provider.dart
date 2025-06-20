import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_grid_settings.dart';

class AppGridSettingsNotifier extends StateNotifier<AppGridSettings> {
  AppGridSettingsNotifier(super.state) {
    super.state = AppGridSettings(gridExtent: 80, hideName: false);
  }

  void setSettings(AppGridSettings settings) {
    state = settings;
  }

  void modifyExtent(double extent) {
    state = state.copyWith(gridExtent: extent);
  }

  void toggleHideName() {
    state = state.copyWith(hideName: !state.hideName);
  }

  void setLastUsedConfig(String? configId) {
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
