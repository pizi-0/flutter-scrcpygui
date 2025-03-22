// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:localization/localization.dart';
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

  @override
  bool operator ==(covariant ColorSchemesWithName other) {
    if (identical(this, other)) return true;

    return other.light == light && other.dark == dark;
  }

  @override
  int get hashCode => name.hashCode ^ light.hashCode ^ dark.hashCode;
}

List<ColorSchemesWithName> mySchemes() {
  return [
    ColorSchemesWithName(el.colorSchemeNameLoc.blue, ColorSchemes.lightBlue(),
        ColorSchemes.darkBlue()),
    ColorSchemesWithName(el.colorSchemeNameLoc.gray, ColorSchemes.lightGray(),
        ColorSchemes.darkGray()),
    ColorSchemesWithName(el.colorSchemeNameLoc.green, ColorSchemes.lightGreen(),
        ColorSchemes.darkGreen()),
    ColorSchemesWithName(el.colorSchemeNameLoc.neutral,
        ColorSchemes.lightNeutral(), ColorSchemes.darkNeutral()),
    ColorSchemesWithName(el.colorSchemeNameLoc.orange,
        ColorSchemes.lightOrange(), ColorSchemes.darkOrange()),
    ColorSchemesWithName(el.colorSchemeNameLoc.red, ColorSchemes.lightRed(),
        ColorSchemes.darkRed()),
    ColorSchemesWithName(el.colorSchemeNameLoc.rose, ColorSchemes.lightRose(),
        ColorSchemes.darkRose()),
    ColorSchemesWithName(el.colorSchemeNameLoc.slate, ColorSchemes.lightSlate(),
        ColorSchemes.darkSlate()),
    ColorSchemesWithName(el.colorSchemeNameLoc.stone, ColorSchemes.lightStone(),
        ColorSchemes.darkStone()),
    ColorSchemesWithName(el.colorSchemeNameLoc.violet,
        ColorSchemes.lightViolet(), ColorSchemes.darkViolet()),
    ColorSchemesWithName(el.colorSchemeNameLoc.yellow,
        ColorSchemes.lightYellow(), ColorSchemes.darkYellow()),
    ColorSchemesWithName(el.colorSchemeNameLoc.zinc, ColorSchemes.lightZinc(),
        ColorSchemes.darkZinc()),
  ];
}
