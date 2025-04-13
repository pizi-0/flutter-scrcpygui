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

  setSettings(AppSettings settings) {
    state = settings;
  }

  changeThememode(ThemeMode mode) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(themeMode: mode));
  }

  changeColorScheme(ColorSchemesWithName scheme) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(scheme: scheme));
  }

  changeTintLevel(double tintLevel) {
    var currentLooks = state.looks;
    state = state.copyWith(
        looks: currentLooks.copyWith(accentTintLevel: tintLevel));
  }

  changeCornerRadius(double radius) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(widgetRadius: radius));
  }

  changeMinimizeBehaviour(MinimizeAction behaviour) {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(minimizeAction: behaviour));
  }

  changeLanguage(String languageCode) {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(languageCode: languageCode));
  }

  changeHideConfig() {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(
            hideDefaultConfig: !state.behaviour.hideDefaultConfig));
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(() => SettingsNotifier());
