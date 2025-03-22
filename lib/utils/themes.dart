// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:forui/forui.dart';

class ColorSchemesWithName {
  final String name;
  final FThemeData light;
  final FThemeData dark;

  const ColorSchemesWithName(this.name, this.light, this.dark);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'light': light.hashCode,
      'dark': dark.hashCode,
    };
  }

  factory ColorSchemesWithName.fromMap(Map<String, dynamic> map) {
    return ColorSchemesWithName(
      map['name'] as String,
      lightThemes.firstWhere((theme) => theme.hashCode == map['light'] as int),
      darkThemes.firstWhere((theme) => theme.hashCode == map['dark'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorSchemesWithName.fromJson(String source) =>
      ColorSchemesWithName.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<FThemeData> lightThemes = [
  FThemes.blue.light,
  FThemes.green.light,
  FThemes.orange.light,
  FThemes.red.light,
  FThemes.rose.light,
  FThemes.slate.light,
  FThemes.violet.light,
  FThemes.yellow.light,
  FThemes.zinc.light,
];

List<FThemeData> darkThemes = [
  FThemes.blue.dark,
  FThemes.green.dark,
  FThemes.orange.dark,
  FThemes.red.dark,
  FThemes.rose.dark,
  FThemes.slate.dark,
  FThemes.violet.dark,
  FThemes.yellow.dark,
  FThemes.zinc.dark,
];

List<ColorSchemesWithName> mySchemes() {
  return [
    ColorSchemesWithName('blue', FThemes.blue.light, FThemes.blue.dark),
    ColorSchemesWithName('green', FThemes.green.light, FThemes.green.dark),
    ColorSchemesWithName('orange', FThemes.orange.light, FThemes.orange.dark),
    ColorSchemesWithName('red', FThemes.red.light, FThemes.red.dark),
    ColorSchemesWithName('rose', FThemes.rose.light, FThemes.rose.dark),
    ColorSchemesWithName('slate', FThemes.slate.light, FThemes.slate.dark),
    ColorSchemesWithName('violet', FThemes.violet.light, FThemes.violet.dark),
    ColorSchemesWithName('yellow', FThemes.yellow.light, FThemes.yellow.dark),
    ColorSchemesWithName('zinc', FThemes.zinc.light, FThemes.zinc.dark),
  ];
}
