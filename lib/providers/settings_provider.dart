import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return defaultSettings;
  }

  void setSettings(AppSettings settings) {
    state = settings;
  }

  void changeThememode(ThemeMode mode) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(themeMode: mode));
  }

  void changeColorScheme(ColorSchemesWithName scheme) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(scheme: scheme));
  }

  void toggleOldScheme() {
    var currentLooks = state.looks;
    state = state.copyWith(
        looks: currentLooks.copyWith(useOldScheme: !currentLooks.useOldScheme));
  }

  void changeTintLevel(double tintLevel) {
    var currentLooks = state.looks;
    state = state.copyWith(
        looks: currentLooks.copyWith(accentTintLevel: tintLevel));
  }

  void changeCornerRadius(double radius) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(widgetRadius: radius));
  }

  void changeMinimizeBehaviour(MinimizeAction behaviour) {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(minimizeAction: behaviour));
  }

  void changeLanguage(String languageCode) {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(languageCode: languageCode));
  }

  void changeHideConfig() {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(
            hideDefaultConfig: !state.behaviour.hideDefaultConfig));
  }

  void changeRememberWinSize() {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(
            rememberWinSize: !state.behaviour.rememberWinSize));
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(() => SettingsNotifier());
