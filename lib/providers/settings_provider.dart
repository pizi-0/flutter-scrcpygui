import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/utils/const.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return defaultSettings;
  }

  setSettings(AppSettings settings) {
    state = settings;
  }

  changeThememode(ThemeMode mode) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(themeMode: mode));
  }

  changeAccentColor(AccentColor color) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(accentColor: color));
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(() => SettingsNotifier());
