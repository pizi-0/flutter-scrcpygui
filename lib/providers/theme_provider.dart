import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/utils/app_utils.dart';

import '../models/app_theme.dart';

class AppThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() {
    return defaultTheme;
  }

  toggleBrightness() {
    if (state.brightness == Brightness.dark) {
      state = state.copyWith(brightness: Brightness.light);
      AppUtils.saveAppTheme(state);
    } else {
      state = state.copyWith(brightness: Brightness.dark);
      AppUtils.saveAppTheme(state);
    }
  }

  setFromWall(bool fromWall) {
    state = state.copyWith(fromWall: fromWall);
  }

  setTheme(AppTheme theme) {
    state = theme;
  }

  setBrightness(Brightness brightness) {
    state = state.copyWith(brightness: brightness);
  }

  setColor(Color color) {
    state = state.copyWith(color: color);
  }

  setWidgetRadius(double radius) {
    state = state.copyWith(widgetRadius: radius);
  }
}

final appThemeProvider =
    NotifierProvider<AppThemeNotifier, AppTheme>(() => AppThemeNotifier());

// final defaultThemeProvider = StateProvider<AppTheme>((ref) =>
//     AppTheme(color: const Color(0xff006D66), brightness: Brightness.dark));

final defaultTheme = AppTheme(
  widgetRadius: 10,
  color: const Color(0xff00b8d4),
  brightness: Brightness.dark,
  fromWall: false,
);
