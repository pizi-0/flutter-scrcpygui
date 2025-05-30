import 'dart:ui';

import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

ColorScheme mySchemeDark(Color color) {
  return ColorScheme(
    brightness: Brightness.dark,
    background: color.darken(92),
    foreground: Colors.white,
    card: color.darken(92),
    cardForeground: Colors.white,
    popover: color.darken(92),
    popoverForeground: Colors.white,
    primary: color,
    primaryForeground: color.getContrastColor(),
    secondary: color.lighten(50).darken(80),
    secondaryForeground: color.darken(70).lighten(5).getContrastColor(),
    muted: color.lighten(50).darken(80),
    mutedForeground:
        color.darken(70).lighten(5).getContrastColor().withAlpha(150),
    accent: color.lighten(50).darken(80),
    accentForeground: Colors.white,
    destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
    destructiveForeground:
        HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor().getContrastColor(),
    border: color.lighten(50).darken(80),
    input: color.lighten(50).darken(80),
    ring: color,
    chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
    chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
    chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
    chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
    chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
  );
}

ColorScheme mySchemeLight(Color color) {
  return ColorScheme(
    brightness: Brightness.light,
    background: color.lighten(100),
    foreground: color.lighten(100).getContrastColor(),
    card: color.lighten(100),
    cardForeground: color.lighten(100).getContrastColor(),
    popover: color.lighten(100),
    popoverForeground: color.lighten(100).getContrastColor(),
    primary: color.lighten(30),
    primaryForeground: color.lighten(30).getContrastColor(),
    secondary: color.darken(15).lighten(85),
    secondaryForeground: color.darken(15).lighten(85).getContrastColor(),
    muted: color.darken(15).lighten(85),
    mutedForeground:
        color.darken(15).lighten(85).getContrastColor().withAlpha(150),
    accent: color.darken(15).lighten(85),
    accentForeground: color.lighten(100).getContrastColor(),
    destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
    destructiveForeground:
        HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor().getContrastColor(),
    border: color.darken(15).lighten(85),
    input: color.darken(15).lighten(85),
    ring: color,
    chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
    chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
    chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
    chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
    chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
  );
}
