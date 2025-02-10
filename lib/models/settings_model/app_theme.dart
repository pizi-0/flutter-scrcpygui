// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hexcolor/hexcolor.dart';

class AppTheme {
  final double widgetRadius;
  final bool fromWall;
  final AccentColor accentColor;
  final ThemeMode themeMode;
  final double accentTintLevel;

  AppTheme({
    required this.accentColor,
    required this.themeMode,
    this.fromWall = false,
    this.widgetRadius = 10,
    required this.accentTintLevel,
  });

  AppTheme copyWith({
    double? widgetRadius,
    bool? fromWall,
    AccentColor? accentColor,
    ThemeMode? themeMode,
    double? accentTintLevel,
  }) {
    return AppTheme(
      widgetRadius: widgetRadius ?? this.widgetRadius,
      fromWall: fromWall ?? this.fromWall,
      accentColor: accentColor ?? this.accentColor,
      themeMode: themeMode ?? this.themeMode,
      accentTintLevel: accentTintLevel ?? this.accentTintLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetRadius': widgetRadius,
      'fromWall': fromWall,
      'accentColor': accentColor.hex,
      'themeMode': ThemeMode.values.indexOf(themeMode),
      'accentTintLevel': accentTintLevel,
    };
  }

  factory AppTheme.fromMap(Map<String, dynamic> map) {
    return AppTheme(
      widgetRadius: map['widgetRadius'] ?? 10,
      fromWall: map['fromWall'] ?? false,
      accentColor: HexColor(map['accentColor']).toAccentColor(),
      themeMode: ThemeMode.values[map['themeMode']],
      accentTintLevel: map['accentTintLevel'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppTheme.fromJson(String source) =>
      AppTheme.fromMap(json.decode(source));
}
