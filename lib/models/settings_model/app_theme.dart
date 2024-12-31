// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:scrcpygui/utils/extension.dart';

class AppTheme {
  final double widgetRadius;
  final bool fromWall;
  final Color color;
  final Brightness brightness;
  final ColorTintLevel tintLevel;

  AppTheme({
    required this.color,
    required this.brightness,
    this.fromWall = false,
    this.widgetRadius = 10,
    required this.tintLevel,
  });

  AppTheme copyWith({
    double? widgetRadius,
    bool? fromWall,
    Color? color,
    Brightness? brightness,
    ColorTintLevel? tintLevel,
  }) {
    return AppTheme(
      widgetRadius: widgetRadius ?? this.widgetRadius,
      fromWall: fromWall ?? this.fromWall,
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      tintLevel: tintLevel ?? this.tintLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetRadius': widgetRadius,
      'fromWall': fromWall,
      'color': color.hex,
      'brightness': Brightness.values.indexOf(brightness),
      'tintLevel': tintLevel.toMap(),
    };
  }

  factory AppTheme.fromMap(Map<String, dynamic> map) {
    return AppTheme(
      widgetRadius: map['widgetRadius'] ?? 10,
      fromWall: map['fromWall'] ?? false,
      color: HexColor.fromHex(map['color']),
      brightness: Brightness.values[map['brightness']],
      tintLevel: map['tintLevel'] == null
          ? ColorTintLevel()
          : ColorTintLevel.fromMap(
              map['tintLevel'],
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppTheme.fromJson(String source) =>
      AppTheme.fromMap(json.decode(source));
}

class ColorTintLevel {
  final int surfaceTintLevel;
  final int primaryTintLevel;
  final int secondaryTintLevel;
  final int tertiaryTintLevel;

  ColorTintLevel(
      {this.surfaceTintLevel = 90,
      this.primaryTintLevel = 40,
      this.secondaryTintLevel = 80,
      this.tertiaryTintLevel = 90});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'surfaceTintLevel': surfaceTintLevel,
      'primaryTintLevel': primaryTintLevel,
      'secondaryTintLevel': secondaryTintLevel,
      'tertiaryTintLevel': tertiaryTintLevel,
    };
  }

  factory ColorTintLevel.fromMap(Map<String, dynamic> map) {
    return ColorTintLevel(
      surfaceTintLevel: map['surfaceTintLevel'] ?? 90,
      primaryTintLevel: map['primaryTintLevel'] ?? 90,
      secondaryTintLevel: map['secondaryTintLevel'] ?? 90,
      tertiaryTintLevel: map['tertiaryTintLevel'] ?? 90,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorTintLevel.fromJson(String source) =>
      ColorTintLevel.fromMap(json.decode(source) as Map<String, dynamic>);

  ColorTintLevel copyWith({
    int? surfaceTintLevel,
    int? primaryTintLevel,
    int? secondaryTintLevel,
    int? tertiaryTintLevel,
  }) {
    return ColorTintLevel(
      surfaceTintLevel: surfaceTintLevel ?? this.surfaceTintLevel,
      primaryTintLevel: primaryTintLevel ?? this.primaryTintLevel,
      secondaryTintLevel: secondaryTintLevel ?? this.secondaryTintLevel,
      tertiaryTintLevel: tertiaryTintLevel ?? this.tertiaryTintLevel,
    );
  }
}
