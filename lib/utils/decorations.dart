import 'package:flutter/material.dart';
import 'package:scrcpygui/models/settings_model/app_theme.dart';

class Decorations {
  static BoxDecoration secondaryContainer(
      ColorScheme colorScheme, AppTheme looks) {
    return BoxDecoration(
      color: colorScheme.secondaryContainer,
      border: Border.all(color: colorScheme.primaryContainer, width: 4),
      borderRadius: BorderRadius.circular(looks.widgetRadius),
    );
  }
}
