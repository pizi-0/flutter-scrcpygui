// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/utils/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppTheme {
  final double widgetRadius;
  final bool useOldScheme;
  final ColorSchemesWithName scheme;
  final ThemeMode themeMode;
  final double accentTintLevel;
  final double surfaceBlur;
  final double surfaceOpacity;

  AppTheme({
    required this.scheme,
    required this.themeMode,
    this.useOldScheme = false,
    this.widgetRadius = 0.5,
    this.surfaceBlur = 0,
    this.surfaceOpacity = 1,
    required this.accentTintLevel,
  });

  AppTheme copyWith({
    double? widgetRadius,
    bool? useOldScheme,
    ColorSchemesWithName? scheme,
    ThemeMode? themeMode,
    double? accentTintLevel,
    double? surfaceBlur,
    double? surfaceOpacity,
  }) {
    return AppTheme(
      widgetRadius: widgetRadius ?? this.widgetRadius,
      useOldScheme: useOldScheme ?? this.useOldScheme,
      scheme: scheme ?? this.scheme,
      themeMode: themeMode ?? this.themeMode,
      accentTintLevel: accentTintLevel ?? this.accentTintLevel,
      surfaceBlur: surfaceBlur ?? this.surfaceBlur,
      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetRadius': widgetRadius,
      'useOldScheme': useOldScheme,
      'scheme': scheme.toMap(),
      'themeMode': ThemeMode.values.indexOf(themeMode),
      'accentTintLevel': accentTintLevel,
      'surfaceBlur': surfaceBlur,
      'surfaceOpacity': surfaceOpacity,
    };
  }

  factory AppTheme.fromMap(Map<String, dynamic> map) {
    ColorSchemes();

    return AppTheme(
      widgetRadius: map['widgetRadius'] ?? 0.5,
      useOldScheme: map['useOldScheme'] ?? false,
      scheme: map['scheme'] != null
          ? ColorSchemesWithName.fromMap(map['scheme'])
          : mySchemes().first,
      themeMode: ThemeMode.values[map['themeMode']],
      accentTintLevel: map['accentTintLevel'],
      surfaceBlur: map['surfaceBlur'] ?? 0,
      surfaceOpacity: map['surfaceOpacity'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppTheme.fromJson(String source) =>
      AppTheme.fromMap(json.decode(source));
}
