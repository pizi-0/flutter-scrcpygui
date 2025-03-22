// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/utils/themes.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppTheme {
  final double widgetRadius;
  final bool fromWall;
  final ColorSchemesWithName scheme;
  final ThemeMode themeMode;
  final double accentTintLevel;

  AppTheme({
    required this.scheme,
    required this.themeMode,
    this.fromWall = false,
    this.widgetRadius = 0.5,
    required this.accentTintLevel,
  });

  AppTheme copyWith({
    double? widgetRadius,
    bool? fromWall,
    ColorSchemesWithName? scheme,
    ThemeMode? themeMode,
    double? accentTintLevel,
  }) {
    return AppTheme(
      widgetRadius: widgetRadius ?? this.widgetRadius,
      fromWall: fromWall ?? this.fromWall,
      scheme: scheme ?? this.scheme,
      themeMode: themeMode ?? this.themeMode,
      accentTintLevel: accentTintLevel ?? this.accentTintLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetRadius': widgetRadius,
      'fromWall': fromWall,
      'scheme': scheme.toMap(),
      'themeMode': ThemeMode.values.indexOf(themeMode),
      'accentTintLevel': accentTintLevel,
    };
  }

  factory AppTheme.fromMap(Map<String, dynamic> map) {
    ColorSchemes();

    return AppTheme(
      widgetRadius: map['widgetRadius'] ?? 0.5,
      fromWall: map['fromWall'] ?? false,
      scheme: map['scheme'] != null
          ? ColorSchemesWithName.fromMap(map['scheme'])
          : mySchemes().first,
      themeMode: ThemeMode.values[map['themeMode']],
      accentTintLevel: map['accentTintLevel'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppTheme.fromJson(String source) =>
      AppTheme.fromMap(json.decode(source));
}
