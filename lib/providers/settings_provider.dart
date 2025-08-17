import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../models/settings_model/auto_arrange_origin.dart';

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

  void changeOpacity(double opacity) {
    var currentLooks = state.looks;
    state =
        state.copyWith(looks: currentLooks.copyWith(surfaceOpacity: opacity));
  }

  void changeBlur(double blur) {
    var currentLooks = state.looks;
    state = state.copyWith(looks: currentLooks.copyWith(surfaceBlur: blur));
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

  void toggleAutoArrangeStatus() {
    var currentBehaviour = state.behaviour;

    final currentInt = currentBehaviour.autoArrangeOrigin.index;

    final newStatus = AutoArrangeOrigin
        .values[(currentInt + 1) % AutoArrangeOrigin.values.length];

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(autoArrangeOrigin: newStatus));
  }

  void changeAutoArrangeOrigin(AutoArrangeOrigin status) {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(autoArrangeOrigin: status));
  }

  void changeWindowToScreenHeightRatio(double ratio) {
    var currentBehaviour = state.behaviour;

    state = state.copyWith(
        behaviour: currentBehaviour.copyWith(windowToScreenHeightRatio: ratio));
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(() => SettingsNotifier());
