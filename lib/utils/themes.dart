// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shadcn_flutter/shadcn_flutter.dart';

class ColorSchemesWithName {
  final String name;
  final ColorScheme light;
  final ColorScheme dark;

  const ColorSchemesWithName(this.name, this.light, this.dark);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'light': light.toMap(),
      'dark': dark.toMap(),
    };
  }

  factory ColorSchemesWithName.fromMap(Map<String, dynamic> map) {
    return ColorSchemesWithName(
      map['name'] as String,
      ColorScheme.fromMap(map['light'] as Map<String, dynamic>),
      ColorScheme.fromMap(map['dark'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorSchemesWithName.fromJson(String source) =>
      ColorSchemesWithName.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<ColorSchemesWithName> mySchemes = [
  ColorSchemesWithName(
      'Blue', ColorSchemes.lightBlue(), ColorSchemes.darkBlue()),
  ColorSchemesWithName(
      'Gray', ColorSchemes.lightGray(), ColorSchemes.darkGray()),
  ColorSchemesWithName(
      'Green', ColorSchemes.lightGreen(), ColorSchemes.darkGreen()),
  ColorSchemesWithName(
      'Neutral', ColorSchemes.lightNeutral(), ColorSchemes.darkNeutral()),
  ColorSchemesWithName(
      'Orange', ColorSchemes.lightOrange(), ColorSchemes.darkOrange()),
  ColorSchemesWithName('Red', ColorSchemes.lightRed(), ColorSchemes.darkRed()),
  ColorSchemesWithName(
      'Rose', ColorSchemes.lightRose(), ColorSchemes.darkRose()),
  ColorSchemesWithName(
      'Slate', ColorSchemes.lightSlate(), ColorSchemes.darkSlate()),
  ColorSchemesWithName(
      'Stone', ColorSchemes.lightStone(), ColorSchemes.darkStone()),
  ColorSchemesWithName(
      'Violet', ColorSchemes.lightViolet(), ColorSchemes.darkViolet()),
  ColorSchemesWithName(
      'Yellow', ColorSchemes.lightYellow(), ColorSchemes.darkYellow()),
  ColorSchemesWithName(
      'Zinc', ColorSchemes.lightZinc(), ColorSchemes.darkZinc()),
];
