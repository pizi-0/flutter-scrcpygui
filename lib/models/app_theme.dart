// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class AppTheme {
  final double widgetRadius;
  final bool fromWall;
  final Color color;
  final Brightness brightness;

  AppTheme(
      {required this.color,
      required this.brightness,
      this.fromWall = false,
      this.widgetRadius = 10});

  AppTheme copyWith({
    double? widgetRadius,
    bool? fromWall,
    Color? color,
    Brightness? brightness,
  }) {
    return AppTheme(
      widgetRadius: widgetRadius ?? this.widgetRadius,
      fromWall: fromWall ?? this.fromWall,
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetRadius': widgetRadius,
      'fromWall': fromWall,
      'color': color.value,
      'brightness': Brightness.values.indexOf(brightness),
    };
  }

  factory AppTheme.fromMap(Map<String, dynamic> map) {
    return AppTheme(
      widgetRadius: map['widgetRadius'] ?? 10,
      fromWall: map['fromWall'] ?? false,
      color: Color(map['color']),
      brightness: Brightness.values[map['brightness']],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppTheme.fromJson(String source) =>
      AppTheme.fromMap(json.decode(source));

  @override
  bool operator ==(covariant AppTheme other) {
    if (identical(this, other)) return true;

    return other.widgetRadius == widgetRadius &&
        other.fromWall == fromWall &&
        other.color == color &&
        other.brightness == brightness;
  }

  @override
  int get hashCode =>
      widgetRadius.hashCode ^
      fromWall.hashCode ^
      color.hashCode ^
      brightness.hashCode;
}
