import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/settings_model/app_theme.dart';
import 'package:scrcpygui/providers/settings_provider.dart';

class Decorations {
  static BoxDecoration secondaryContainer(
      ColorScheme colorScheme, AppTheme looks) {
    return BoxDecoration(
      color: colorScheme.secondaryContainer,
      border: Border.all(color: colorScheme.primaryContainer, width: 4),
      borderRadius: BorderRadius.circular(looks.widgetRadius),
    );
  }

  static ButtonStyle textButtonStyle(WidgetRef ref) {
    final looks = ref.read(settingsProvider).looks;
    return ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(looks.widgetRadius))));
  }
}
