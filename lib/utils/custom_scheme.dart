import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

ColorScheme mySchemeDark(WidgetRef ref, Color color) {
  final luminance = color.computeLuminance();
  final tintLevel =
      ref.watch(settingsProvider.select((sett) => sett.looks.accentTintLevel));

  Color primaryForeground() {
    Color? color;

    if (luminance > 0.3) {
      color = Colors.black;
    } else {
      color = Colors.white;
    }

    return color;
  }

  return ColorScheme(
    brightness: Brightness.dark,
    background: color.darken(tintLevel.toInt()),
    foreground: Colors.white,
    card: color.darken(tintLevel.toInt()),
    cardForeground: Colors.white,
    popover: color.darken(tintLevel.toInt()),
    popoverForeground: Colors.white,
    primary: color,
    primaryForeground: primaryForeground(),
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
    sidebar: Color(0xFF18181B),
    sidebarForeground: Color(0xFFFAFAFA),
    sidebarPrimary: Color(0xFF155DFC),
    sidebarPrimaryForeground: Color(0xFF1C398E),
    sidebarAccent: Color(0xFF27272A),
    sidebarAccentForeground: Color(0xFFFAFAFA),
    sidebarBorder: Color(0x1AFFFFFF),
    sidebarRing: Color(0xFF1447E6),
  );
}

ColorScheme mySchemeLight(WidgetRef ref, Color color) {
  final luminance = color.computeLuminance();
  final tintLevel =
      ref.watch(settingsProvider.select((sett) => sett.looks.accentTintLevel));

  Color primaryForeground() {
    Color? color;

    if (luminance > 0.3) {
      color = Colors.black;
    } else {
      color = Colors.white;
    }

    return color;
  }

  int secondaryTint = (tintLevel - 10).clamp(0, tintLevel - 10).toInt();

  return ColorScheme(
    brightness: Brightness.light,
    background: color.lighten(tintLevel.toInt()),
    foreground: color.lighten(100).getContrastColor(),
    card: color.lighten(tintLevel.toInt()),
    cardForeground: color.lighten(100).getContrastColor(),
    popover: color.lighten(tintLevel.toInt()),
    popoverForeground: color.lighten(100).getContrastColor(),
    primary: color,
    primaryForeground: primaryForeground(),
    secondary: color.lighten(secondaryTint),
    secondaryForeground: color.lighten(secondaryTint).getContrastColor(),
    muted: color.lighten(secondaryTint),
    mutedForeground:
        color.lighten(secondaryTint).getContrastColor().withAlpha(150),
    accent: color.lighten(secondaryTint),
    accentForeground: color.lighten(100).getContrastColor(),
    destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
    destructiveForeground:
        HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor().getContrastColor(),
    border: color.lighten(secondaryTint),
    input: color.lighten(secondaryTint),
    ring: color,
    chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
    chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
    chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
    chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
    chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    sidebar: Color(0xFFFAFAFA),
    sidebarForeground: Color(0xFF09090B),
    sidebarPrimary: Color(0xFF2B7FFF),
    sidebarPrimaryForeground: Color(0xFFEFF6FF),
    sidebarAccent: Color(0xFFF4F4F5),
    sidebarAccentForeground: Color(0xFF18181B),
    sidebarBorder: Color(0xFFE4E4E7),
    sidebarRing: Color(0xFF2B7FFF),
  );
}

Color background(BuildContext context) {
  final theme = Theme.of(context);

  return theme.colorScheme.background;
}
